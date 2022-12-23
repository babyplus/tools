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

void print_hex(const char *string, int length)
{
    unsigned char *p = (unsigned char *) string;

    for (int i=0; i < length; ++i)
    {
        if (! (i % 16) && i)
            printf("\n");
        printf("%02x ", p[i]);
    }
    printf("\n\n");
}
