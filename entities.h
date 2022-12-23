#include "component.h"
#include <list>
#include <string>

class Entities : public Component
{
    private:
        std::string description;
        std::list<Component*> entities;
    public:
        Entities(const std::string&);
        virtual ~Entities();
        virtual void add(Component*);
        virtual void remove(Component*);
        virtual void execute();
};
