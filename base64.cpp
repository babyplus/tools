#include "base64.h"

void base64_encode(char *out, long *out_length, char *in, long in_length)
{
    const final_quantum_e final_quantum = (final_quantum_e) (in_length % BASE64_24BITS_LEN);
    const long n_24bits_groups = in_length / BASE64_24BITS_LEN;

    char * position = 0;
    base64_24bits_u u24bits = {0};
    base64_32bits_u u32bits = {0};

    BASE64_SET_OUTPUT_LEN(*out_length, n_24bits_groups, final_quantum);

    for ( long i = 0; i < n_24bits_groups; i++ )
    {
        SET_POSITION(position, in, BASE64_24BITS_LEN * i);
        BASE64_SET_24BITS(u24bits, position); 
        BASE64_24BITS_TO_32BITS(u24bits, u32bits);
        BASE64_SAVE_32BITS(out + 4 * i, u32bits);
    }

    SET_POSITION(position, in, n_24bits_groups * BASE64_24BITS_LEN);

    if ( final_quantum_8bits == final_quantum )
    {
        BASE64_INIT_24BITS(u24bits);
        BASE64_LOAD_8BITS(u24bits, position, 0);
        BASE64_24BITS_TO_32BITS(u24bits, u32bits);
        BASE64_SAVE_8BITS(out + n_24bits_groups * 4, u32bits);
    }

    if ( final_quantum_16bits == final_quantum )
    {
        BASE64_INIT_24BITS(u24bits);
        BASE64_LOAD_8BITS(u24bits, position, 0);
        BASE64_LOAD_8BITS(u24bits, position, 1);
        BASE64_24BITS_TO_32BITS(u24bits, u32bits);
        BASE64_SAVE_16BITS(out + n_24bits_groups * 4, u32bits);
    }

    BASE64_SAVE_TERMINATOR(out + *out_length - 1);
}
