#ifndef CUSTOM_HEADER
#define CUSTOM_HEADER
struct options_t
{
    const char * subject;
    const char * body_text_head;
    const char * body_text_body;
    const char * file_name;
    const char * file_name_64;
    const char * url;
    const char * username;
    const char * password;
    const char * from;
    struct curl_slist * recipients;
    const char * message_id;
};
#endif
