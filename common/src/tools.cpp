#include "tools.h"

void my_sleep(unsigned msec)
{
    struct timespec req, rem;
    int err;
    req.tv_sec = msec / 1000;
    req.tv_nsec = (msec % 1000) * 1000000;
    while ((req.tv_sec != 0) || (req.tv_nsec != 0)) {
        if (nanosleep(&req, &rem) == 0)
            break;
        err = errno;
        // Interrupted; continue
        if (err == EINTR) {
            req.tv_sec = rem.tv_sec;
            req.tv_nsec = rem.tv_nsec;
        }
        // Unhandleable error (EFAULT (bad pointer), EINVAL (bad timeval in tv_nsec), or ENOSYS (function not supported))
        break;
    }
}

void print_hex(char *string, long length)
{
    uint8_t *p = (uint8_t *) string;

    for (int i=0; i < length; ++i)
    {
        if (! (i % 16) && i)
            printf("\n");
        printf("%02x ", p[i]);
    }
    printf("\n\n");
}

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
