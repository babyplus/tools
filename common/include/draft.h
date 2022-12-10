#ifndef DRAFT
#define DRAFT
#include <vector>
#include <tuple>
#include <cassert>
#include <cstring>

class Draft
{
    private:
    public:
        long size;
        std::vector<std::tuple <void *, int>> content;
        void write(void* el, long len);
        char* confirm();
        Draft(void* el, long len);
        Draft();
        ~Draft();
};

#endif
