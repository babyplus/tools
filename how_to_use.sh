
gcc send_by_string.c -o sbs && ./sbs enp0s8 "01:80:c2:00:00:34" "8100 2002 | 8902 | 8005 | 80 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02"

# The last parameter is used to change the source address
gcc send_by_string.c -o sbs && ./sbs enp0s8 "01:80:c2:00:00:34" "8100 2002 | 8902 | 8005 | 80 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02" "112233445566"
