#ifndef __COMPONENT__
#define __COMPONENT__
#include "tracker.h"

class Component
{
    public:
        Component();
        virtual ~Component();
        virtual void execute() = 0;
};
#endif
