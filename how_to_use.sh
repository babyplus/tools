
gcc main.c -o packet_sender && ./packet_sender enp0s8 "01:80:c2:00:00:34" "8100 2002 | 8902 | 8005 | 80 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02"

# The last parameter is used to change the source address
gcc main.c -o packet_sender && ./packet_sender enp0s8 "01:80:c2:00:00:34" "8100 2002 | 8902 | 8005 | 80 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02" "112233445566"
