#include "component.h"
#include "tools.h"
#include "custom.h"
#include <string>
#include <cstring>
#include <curl/curl.h>

#define ENTITY_RAW  (1<<Entity::raw)
#define ENTITY_FILE (1<<Entity::file)
#define ENTITY_EMAIL (1<<Entity::email)

typedef unsigned int flags_t;
extern char * payload_text;

class Entity : public Component
{
    private:
        std::string description;
        flags_t flags;
        bool data_is_malloc = false;
        void _Entity_raw(const char *, const int);
        void _Entity_email(const char *, const long, void * options);
        void _Entity_file(const char *);

    public:
        void * options;
        const char* data;
        int data_len;
        enum type
        {
            raw,
            file,
            email,
            end,
        };
        Entity(const std::string&, Entity::type, const char *);
        Entity(const std::string&, Entity::type, char *, const long, void *);
        virtual ~Entity();
        virtual void execute();
        static size_t payload_source(char *ptr, size_t size, size_t nmemb, void *userp);
};
