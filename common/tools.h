#ifndef TOOLS 

#include <ctime>
#include <cerrno>
#include <climits>

#define GET_FILE_SIZE(file_size, fp) do {\
    char ch = 0;\
    fseek(fp, 0, SEEK_END);\
    file_size = ftell(fp);\
    fseek(fp, 0, SEEK_SET);\
} while(0);

#define SET_OFFSET_DATA_FROM_THE_FILE_POINTER(fp, data, offset, file_size) do {\
    fseek(fp, 0, SEEK_SET);\
    char ch = 0;\
    unsigned long i = file_size;\
    while(i--)\
    {\
        ch = fgetc(fp);\
        data[offset++] = ch;\
    }\
}while(0);

#define MALLOC_AND_SET_DATA_FROM_THE_FILE(data, file_size, file) do {\
    int offset = 0;\
    FILE *fp = fopen(file, "rb");\
    GET_FILE_SIZE(file_size, fp);\
    data = (char *) malloc(file_size);\
    SET_OFFSET_DATA_FROM_THE_FILE_POINTER(fp, data, offset, file_size)\
    fclose(fp);\
}while(0);

#define FREE(p) free(p);

void my_sleep(unsigned msec);
void print_hex(const char *string, int length);
#endif
