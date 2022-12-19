#include "draft.h"

Draft::Draft(void* el, long len):size(0)
{
    this->size += len;
    content.push_back(std::tuple <void *, int>(el, len));
}

Draft::Draft():size(0)
{   
}

Draft::~Draft()
{   
}

void Draft::write(void* el, long len)
{
    this->size += len;
    content.push_back(std::tuple <void *, int>(el, len));
}

char* Draft::confirm()
{
    long size = 0;
    for (std::vector<std::tuple <void *, int>>::iterator it = content.begin() ; it != content.end(); ++it)
        size += std::get<1>(*it);
    assert(size == this->size);
    
    char *publication = (char *) malloc(size);
    long position = 0;
    for (auto it = content.begin(); it != content.end(); ++it)
    {
        memcpy(publication+position, std::get<0>(*it), std::get<1>(*it));
        position += std::get<1>(*it); 
    }

    return publication;
}
