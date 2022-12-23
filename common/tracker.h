#ifndef TRACK
#include <cstdio>
#define HIGHER_4BITS_MASK 240
#define LOWER_4BITS_MASK 15
#define GET_HIGHER_4BITS(x) ((x | HIGHER_4BITS_MASK)>>4)
#define GET_LOWER_4BITS(x) (x | LOWER_4BITS_MASK)
#define TRACK(code, ...) printf("%50s(%3d) --> \"%s\" " code "\n" , __FILE__, __LINE__, __PRETTY_FUNCTION__,  ##__VA_ARGS__);
#endif
