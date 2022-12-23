#include "entities.h"

Entities::Entities(const std::string& description)
{
    this->description = description;
}

Entities::~Entities()
{
}

void Entities::add(Component* e)
{
    this->entities.push_back(e);
}

void Entities::remove(Component* e)
{
    this->entities.remove(e);
}

void Entities::execute()
{
    TRACK("entities: ----%s", this->description.c_str());
    for (std::list<Component*>::iterator it=this->entities.begin(); it != entities.end(); ++it)
    {
        (*it)->execute();
    }
}

