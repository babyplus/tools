#include "entity.h"
#include <curl/curl.h>

Entity::Entity(const std::string& description, Entity::type type, const char * expression):
description(description),
flags(0)
{
    if (Entity::file == type) _Entity_file(expression);
    if (Entity::raw == type) _Entity_raw(expression, strlen(expression));
}

Entity::Entity(const std::string& description, Entity::type type, char * expression, const long len):
description(description),
flags(0)
{
    if (Entity::raw == type) _Entity_raw(expression, len);
}

void Entity::_Entity_raw(const char * data, int data_len)
{
    this->flags |= ENTITY_RAW;
    this->data = data;
    this->data_len = data_len;
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

void Entity::execute()
{
    TRACK("data[%s]: %.*s", this->description.c_str(), this->data_len, this->data);
}

