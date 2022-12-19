#include "entity.h"

Entity::Entity(const std::string& description, Entity::type type, const char * expression):
description(description),
flags(0)
{
    if (Entity::file == type) _Entity_file(expression);
    if (Entity::raw == type) _Entity_raw(expression, strlen(expression));
}

Entity::Entity(const std::string& description, Entity::type type, char * expression, const long len, void * options):
description(description),
flags(0)
{
    if (Entity::raw == type) _Entity_raw(expression, len);
    if (Entity::email == type) _Entity_email(expression, len, options);
}

void Entity::_Entity_raw(const char * data, int data_len)
{
    this->flags |= ENTITY_RAW;
    this->data = data;
    this->data_len = data_len;
}

void Entity::_Entity_email(const char * data, long data_len, void * options)
{
    this->flags |= ENTITY_EMAIL;
    this->data = data;
    this->data_len = data_len;
    this->options = options;
}

void Entity::_Entity_file(const char * file)
{
    this->flags |= ENTITY_FILE;
    unsigned int file_size = 0;
    char * data = 0;
    MALLOC_AND_SET_DATA_FROM_THE_FILE(data, file_size, file);
    this->data_is_malloc = true;
    this->data = data;
    this->data_len = file_size;
}

Entity::~Entity()
{
    if(this->data_is_malloc)
        FREE((void *)this->data);
}

struct upload_status {
    const void* data;
    size_t bytes_read;
};

size_t Entity::payload_source(char *ptr, size_t size, size_t nmemb, void *userp)
{
    struct upload_status *upload_ctx = (struct upload_status *)userp;
    const char *data = (char *)upload_ctx->data + upload_ctx->bytes_read;
    size_t room = size * nmemb;
  
    if((size == 0) || (nmemb == 0) || ((size*nmemb) < 1)) {
        return 0;
    }

    if(data) {
        size_t len = strlen(data);
        if(room < len)
          len = room;
        memcpy(ptr, data, len);
        upload_ctx->bytes_read += len;
        return len;
    }
    return 0;    
}

void mail_sender(const void* data, long data_len, struct options_t * options)
{
    CURL *curl;
    CURLcode res = CURLE_OK;
    struct upload_status upload_ctx = { 
    .data = data,
    .bytes_read = 0
    };
  
    curl = curl_easy_init();
    if(curl) {
      curl_easy_setopt(curl, CURLOPT_USERNAME, options->username);
      curl_easy_setopt(curl, CURLOPT_PASSWORD, options->password);
      curl_easy_setopt(curl, CURLOPT_URL, options->url);
#ifdef SKIP_PEER_VERIFICATION
      curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
#endif
#ifdef SKIP_HOSTNAME_VERIFICATION
      curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);
#endif
      curl_easy_setopt(curl, CURLOPT_MAIL_FROM, options->from);
      curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, options->recipients);
      curl_easy_setopt(curl, CURLOPT_READFUNCTION, Entity::payload_source);
      curl_easy_setopt(curl, CURLOPT_READDATA, &upload_ctx);
      curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
//      curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
      curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
      const char * http_proxy = std::getenv("http_proxy");
      if (NULL != http_proxy)
            curl_easy_setopt(curl, CURLOPT_PROXY, http_proxy);
  
      res = curl_easy_perform(curl);
      if(res != CURLE_OK)
        fprintf(stderr, "curl_easy_perform() failed: %s\n",
                curl_easy_strerror(res));
      curl_easy_cleanup(curl);
    }

}

void Entity::execute()
{
    if ( (this->flags & ENTITY_EMAIL) > 0 )
    {
        mail_sender(this->data, this->data_len, (struct options_t *)this->options);
    }
}

