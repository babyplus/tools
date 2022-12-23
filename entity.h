#include "component.h"
#include "tools.h"
#include <string>
#include <cstring>

#define ENTITY_RAW  (1<<Entity::raw)
#define ENTITY_FILE (1<<Entity::file)

typedef unsigned int flags_t;
extern char * payload_text;

class Entity : public Component
{
    private:
        std::string description;
        flags_t flags;
        const char* data;
        int data_len;
        bool data_is_malloc = false;
        void _Entity_raw(const char *, const int);
        void _Entity_file(const char *);

    public:
        enum type
        {
            raw,
            file,
        };
        Entity(const std::string&, Entity::type, const char *);
        Entity(const std::string&, Entity::type, char *, const long);
        virtual ~Entity();
        virtual void execute();
};
