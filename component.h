#ifndef __COMPONENT__
#define __COMPONENT__

class Component
{
    public:
        Component();
        virtual ~Component();
        virtual void execute() = 0;
};
#endif
