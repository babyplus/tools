#ifndef BASE64
#define BASE64
#include <cstring>
#include <cstdint>
#include <cstdio>

#define BASE64_24BITS_LEN 3
#define BASE64_SET_OUTPUT_LEN(OUT_LEN, COUNT_24B_GROUPS, FINAL_TYPE) OUT_LEN = 4 * COUNT_24B_GROUPS + (FINAL_TYPE ? 5 : 1);
#define ALL_1_BITS(x) ((1 << x) - 1)
#define GET_8BITS(POSITION, OFFSET) *(POSITION+OFFSET) & ALL_1_BITS(8)
#define EXCERPT_IN_N_BITS(DATA, N, OFFSET) (DATA & ALL_1_BITS(N) << N * OFFSET)
#define SET_POSITION(POSITION, BEGIN, OFFSET) POSITION = BEGIN + OFFSET;
#define BASE64_24BITS_TO_32BITS(SRC, DEST) do { DEST = {0}; for (uint8_t n = 0; n < 4; n++) DEST.raw |= EXCERPT_IN_N_BITS(SRC.raw, 6, n)  << 2 * n; }while(0);
#define BASE64_INIT_24BITS(UNION) UNION = {0};
#define BASE64_LOAD_8BITS(UNION, POSITION, OFFSET) UNION.groups.g##OFFSET = GET_8BITS(POSITION, OFFSET);
#define BASE64_SET_24BITS(UNION, POSITION) do {\
BASE64_INIT_24BITS(UNION);\
BASE64_LOAD_8BITS(UNION, POSITION, 0);\
BASE64_LOAD_8BITS(UNION, POSITION, 1);\
BASE64_LOAD_8BITS(UNION, POSITION, 2);\
}while(0);
#define BASE64_SAVE(DEST, C0, C1, C2, C3) snprintf(DEST, 4 + 1, "%c%c%c%c", C0, C1, C2, C3);
#define BASE64_SAVE_32BITS(DEST, UNION) BASE64_SAVE(DEST, base64_alphabet[UNION.groups.g0],\
                                                          base64_alphabet[UNION.groups.g1],\
                                                          base64_alphabet[UNION.groups.g2],\
                                                          base64_alphabet[UNION.groups.g3]);
#define BASE64_SAVE_16BITS(DEST, UNION) BASE64_SAVE(DEST, base64_alphabet[UNION.groups.g0],\
                                                          base64_alphabet[UNION.groups.g1],\
                                                          base64_alphabet[UNION.groups.g2],\
                                                          '=');
#define BASE64_SAVE_8BITS(DEST, UNION)  BASE64_SAVE(DEST, base64_alphabet[UNION.groups.g0],\
                                                          base64_alphabet[UNION.groups.g1],\
                                                          '=',\
                                                          '=');
#define BASE64_SAVE_TERMINATOR(END_POSITION) memcpy(END_POSITION, "\n", 1);

typedef union
{
    uint32_t raw;
    struct{
        uint8_t g2;
        uint8_t g1;
        uint8_t g0;
    } groups;
} base64_24bits_u;

typedef union
{
    uint32_t raw;
    struct{
        uint8_t g3;
        uint8_t g2;
        uint8_t g1;
        uint8_t g0;
    } groups;
} base64_32bits_u;

typedef enum final_quantum_case
{
    final_quantum_24bits,
    final_quantum_8bits,
    final_quantum_16bits
} final_quantum_e;

const char base64_alphabet[64] = {
    'A','B','C','D','E','F','G','H',
    'I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X',
    'Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n',
    'o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3',
    '4','5','6','7','8','9','+','/'
};

void base64_encode(char *out, long *out_length, char *in, long in_length);

#endif
