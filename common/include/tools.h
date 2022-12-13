#ifndef TOOLS 
#define TOOLS

#include <cstdio>
#include <ctime>
#include <cerrno>
#include <climits>
#include <cstring>
#include <cstdint>
#include "base64.h"

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
    SET_OFFSET_DATA_FROM_THE_FILE_POINTER(fp, data, offset, file_size);\
    fclose(fp);\
}while(0);

#define MALLOC_AND_SET_BASE64_DATA_FROM_THE_FILE(data, data_len, file) do {\
    int offset = 0;\
    FILE *fp = fopen(file, "rb");\
    unsigned int file_size = 0;\
    GET_FILE_SIZE(file_size, fp);\
    final_quantum_e final_quantum = (final_quantum_e) (file_size % BASE64_24BITS_LEN);\
    long n_24bits_groups = file_size / BASE64_24BITS_LEN;\
    BASE64_SET_OUTPUT_LEN(data_len, n_24bits_groups, final_quantum);\
    data = (char *) malloc(data_len);\
    char * temp = NULL;\
    temp = (char *) malloc(file_size);\
    SET_OFFSET_DATA_FROM_THE_FILE_POINTER(fp, temp, offset, file_size);\
    base64_encode(data, &data_len, temp, file_size);\
    fclose(fp);\
    FREE(temp);\
}while(0);

#define MALLOC_AND_SET_BASE64_DATA_FROM_THE_FILE_WITH_BUFFER(data, data_len, file, buffer) do {\
    long buffer_len = sizeof(buffer);\
    assert(0 == buffer_len % 3);\
    FILE *fp = fopen(file, "rb");\
    long file_size = 0;\
    GET_FILE_SIZE(file_size, fp);\
    final_quantum_e final_quantum = (final_quantum_e) (file_size % BASE64_24BITS_LEN);\
    long n_24bits_groups = file_size / BASE64_24BITS_LEN;\
    BASE64_SET_OUTPUT_LEN(data_len, n_24bits_groups, final_quantum);\
    data = (char *) malloc(data_len);\
    long n_cycles = file_size / buffer_len;\
    long step_len,i,j = 0;\
    long step_n_groups = buffer_len / BASE64_24BITS_LEN;\
    BASE64_SET_OUTPUT_LEN(step_len, step_n_groups, final_quantum_24bits);\
    --step_len;\
    for (long n = 0; n < n_cycles; n++) {\
        fseek(fp, n * buffer_len, SEEK_SET);\
        i = buffer_len;\
        while(i) buffer[buffer_len-i--] = fgetc(fp);\
        base64_encode(data + n * step_len, &j, buffer, buffer_len);\
    }\
    if (final_quantum) {\
        fseek(fp, n_cycles * buffer_len, SEEK_SET);\
        for (long n = 0; n < buffer_len; n++) buffer[n] = 0;\
        long final_len = file_size % buffer_len;\
        i = final_len;\
        while(i) buffer[final_len-i--] = fgetc(fp);\
        base64_encode(data + n_cycles * step_len, &j, buffer, final_len);\
    }\
    fclose(fp);\
}while(0);

#define FREE(p) free(p);

void my_sleep(unsigned msec);
void print_hex(char *string, long length);
#endif
