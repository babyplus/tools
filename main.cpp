#include "entity.h"
#include "tools.h"
#include "draft.h"

long malloc_and_set_mail(char ** mail, long * size, struct options_t * options)
{
    long mail_size = 0;
    Draft draft = Draft();

    time_t curr_time;
    tm * curr_tm;
    time(&curr_time);
    curr_tm = localtime(&curr_time);
    char time_text[128] = "";
    const char * time_text_format = "Date: %a, %b %d %T %Y +0000\r\n";
    strftime(time_text, 50, time_text_format, curr_tm);
    draft.write((void *)time_text, strlen(time_text));

    char to[strlen(options->recipients->data)+1] = "";
    memcpy(to, options->recipients->data, strlen(options->recipients->data));

    const char *rt_text_format =
    "To: %s\r\n"
    "From: %s\r\n";
    char rt_text[strlen(rt_text_format)+strlen(to)+strlen(options->from)] = "";
    sprintf(rt_text, rt_text_format, to, options->from);
    draft.write((void *)rt_text, strlen(rt_text));

    int cc_len = 1;
    struct curl_slist * _recipients = NULL;
    if (NULL != options->recipients->next)
    {
        _recipients = options->recipients->next;
        cc_len = strlen(_recipients->data) + 1;
    }
    char cc[cc_len] = "";
    if (NULL != _recipients) memcpy(cc, _recipients->data, strlen(_recipients->data));

    const char *cc_text_format = "Cc: %s\r\n";
    char cc_text[strlen(cc_text_format)+strlen(cc)] = "";
    if ( cc_len > 1 )
    {
        sprintf(cc_text, cc_text_format, cc);
        draft.write((void *)cc_text, strlen(cc_text));
    }

    const char *msg_text_format = "Message-ID: %s\r\n";
    char msg_text[strlen(msg_text_format)+strlen(options->message_id)] = "";
    sprintf(msg_text, msg_text_format, options->message_id);
    draft.write((void *)msg_text, strlen(msg_text));

    const char * subject_text_format = "Subject: %s\r\n";
    char subject_text[strlen(subject_text_format)+strlen(options->subject)] = "";
    sprintf(subject_text, subject_text_format, options->subject);
    draft.write((void *)subject_text, strlen(subject_text));
    
    const char *multipart_header =
    "MIME-Version: 1.0\r\n"
    "Content-Type: multipart/mixed; boundary=\"simple boundary\"\r\n"
    "\r\n"; /* empty line to divide headers from body, see RFC5322 */
    draft.write((void *)multipart_header, strlen(multipart_header));

    const char * body_text_format = 
    "--simple boundary\r\n"
    "Content-Type: text/html\r\n"
    "Content-Transfer-Encoding: 7bit\r\n"
    "\r\n"
    "<html><head>%s</head><body><b>%s</b></body>\r\n";
    char body_text[strlen(body_text_format)+strlen(options->body_text_head)+strlen(options->body_text_body)] = "";
    sprintf(body_text, body_text_format, options->body_text_head, options->body_text_body);
    draft.write((void *)body_text, strlen(body_text));
    
    const char * file_header_format = 
    "--simple boundary\r\n"
    "Content-Type: application/octet-stream\r\n"
    "Content-Transfer-Encoding: base64\r\n"
    "Content-Disposition: attachment; filename=%s;\r\n"
    "\r\n";
    char file_header[strlen(file_header_format)+strlen(options->file_name)] = "";
    sprintf(file_header, file_header_format, options->file_name);
    draft.write((void *)file_header, strlen(file_header));

    long attachment_size = 0;
    char * attachment = 0;
    char buffer[6] = {0};
    MALLOC_AND_SET_BASE64_DATA_FROM_THE_FILE_WITH_BUFFER(attachment, attachment_size, options->file_name, buffer);
    draft.write((void *)attachment, attachment_size);

    const char * tail =
    "--simple boundary\r\n"
    "\r\n";
    draft.write((void *)tail, strlen(tail));

    *mail = draft.confirm();
    *size = draft.size;

    FREE(attachment);
    return *size;
}

int main (int argc,char **argv) 
{
    if (argc<11)
    {
        printf("Usage: %s SUBJECT CONTENT_HEADER CONTENT_BODY ATTACHMENT EMAIL_URL EMAIL_USER EMAIL_PASS FROM TO CC MESSAGE_ID\n", argv[0]);
        return 1;
    }

    struct curl_slist *recipients = NULL;
    recipients = curl_slist_append(recipients, argv[9]);
    if ( strlen(argv[10])>0 ) recipients = curl_slist_append(recipients, argv[10]);

    struct options_t options = {
    .subject = argv[1],
    .body_text_head = argv[2],
    .body_text_body = argv[3],
    .file_name = argv[4],
    .url = argv[5],
    .username = argv[6],
    .password = argv[7],
    .from = argv[8],
    .recipients = recipients,
    .message_id = argv[11]
    };
    
    char * mail = 0;
    long size = 0;
    malloc_and_set_mail(&mail, &size, &options);
    Entity task_email("email", Entity::email, mail, size, &options);

    task_email.execute();

    free(mail);
    curl_slist_free_all(recipients);
    return 0;
}
