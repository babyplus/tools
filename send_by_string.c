#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>           // close()
#include <string.h>           // strcpy, memset(), and memcpy()
#include <netdb.h>            // struct addrinfo
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t
#include <sys/socket.h>       // needed for socket()
#include <netinet/in.h>       // IPPROTO_ICMP, INET_ADDRSTRLEN
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <netinet/ip_icmp.h>  // struct icmp, ICMP_ECHO
#include <arpa/inet.h>        // inet_pton() and inet_ntop()
#include <sys/ioctl.h>        // macro ioctl is defined
#include <net/if.h>           // struct ifreq
#include <linux/if_ether.h>   // ETH_P_IP = 0x0800, ETH_P_IPV6 = 0x86DD
#include <linux/if_packet.h>  // struct sockaddr_ll (see man 7 packet)
#include <net/ethernet.h>
#include <errno.h>            // errno, perror()


int _translate_str_to_uint8_t(char * str, uint8_t * uint8, int len)
{
	char tmp, data_iter;
	int data_len = 0;
        while (str[data_len] != 0) ++data_len;
	int i = 0;
	int r = 0;
	int uint8_tmp_index = 0;
	uint8_t uint8_tmp[len];
	memset(uint8_tmp, 0, len);
        while (i < data_len) {
                data_iter = str[i];
                if (('0' <= data_iter) && (data_iter <= '9')) {
                        tmp = data_iter - '0';
			uint8_tmp[uint8_tmp_index] = r ? ((uint8_tmp[uint8_tmp_index] << 4) + tmp) :  (uint8_tmp[uint8_tmp_index] + tmp);
                }
                else if (('a' <= data_iter) && (data_iter <= 'f')) {
                        tmp = data_iter - 'a' + 10;
			uint8_tmp[uint8_tmp_index] = r ? ((uint8_tmp[uint8_tmp_index] << 4) + tmp) :  (uint8_tmp[uint8_tmp_index] + tmp);
                }
                else if (('A' <= data_iter) && (data_iter <= 'F')) {
                        tmp = data_iter - 'A' + 10;
			uint8_tmp[uint8_tmp_index] = r ? ((uint8_tmp[uint8_tmp_index] << 4) + tmp) :  (uint8_tmp[uint8_tmp_index] + tmp);
                }
		else if ( ':' == data_iter | ' ' == data_iter | '|' == data_iter ) {
			++i;
			continue;
		}
                else {
                        printf("Unexpected char: %c\n", data_iter);
                        return 1;
                }
		if (r) {
			uint8_tmp_index++;
			r = 0;
		}else r=1;
                ++i;
        }
	memcpy (uint8 , uint8_tmp, sizeof(uint8_tmp));
}

int _count_char_of_hex(char * data_str, int * p_hex_num)
{
        int num = 0;
        int i = 0;
        int data_len = 0;
        while (data_str[data_len] != 0) ++data_len;
        for ( i=0; i < data_len; i++ ) {
                if (('0' <= data_str[i]) && (data_str[i] <= '9')
                        || ('a' <= data_str[i]) && (data_str[i] <= 'f')
                        || ('A' <= data_str[i]) && (data_str[i] <= 'F')
                ) num++;
        }
	*p_hex_num = num;
        printf("%s --> %d\n", data_str, num);
        return (EXIT_SUCCESS);
}

int  main( int argc, char** argv ) 
{
	 /*
	 * root@plus:~/C# gcc send_by_string.c && ./a.out enp0s3 "01:80:c2:00:00:36" "8100 2002 | 8902 | 8005 | 80 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02"
	 * 
	 */
	uint8_t tmp_data[] = {};
	int tmp_data_len = 0;
	char * interface = argv[1];
	int sd;
	uint8_t src_mac[6];
	uint8_t dst_mac[6];
	struct ifreq ifr;
	struct sockaddr_ll device;

	if ((sd = socket (PF_PACKET, SOCK_RAW, htons (ETH_P_ALL))) < 0) {
	        perror ("socket() failed to get socket descriptor for using ioctl() ");
	        exit (EXIT_FAILURE);
	}
	memset(&ifr, 0, sizeof(ifr));
	snprintf (ifr.ifr_name, sizeof (ifr.ifr_name), "%s", interface);
	if (ioctl (sd, SIOCGIFHWADDR, &ifr) < 0) {
		perror ("ioctl() failed to get source MAC address ");
		return (EXIT_FAILURE);
	}
	close (sd);
	memcpy (src_mac, ifr.ifr_hwaddr.sa_data, sizeof(src_mac));
	if (argv[4]) {
		char * src_mac_str = argv[4];
		_translate_str_to_uint8_t(src_mac_str, src_mac, 6);
	}
	int i = 0;
	for(i = 0; i < sizeof(src_mac); i++){
		printf( i==5 ? "%.2x\n" : "%.2x:", src_mac[i]);
	}

	memset(&device, 0 ,sizeof(device));
	if ((device.sll_ifindex = if_nametoindex (interface)) == 0) {
		perror("if_nametoindex() failed to obtain interface index.");
		return (EXIT_FAILURE);
	}
	printf("Index for interface %s is %i \n", interface, device.sll_ifindex);

	device.sll_family = AF_PACKET;
	memcpy(device.sll_addr, src_mac, 6);
	device.sll_halen = htons(6);

	char * dst_mac_str = argv[2];
	_translate_str_to_uint8_t(dst_mac_str, dst_mac, 6);
        for(i = 0; i < sizeof(dst_mac); i++){
                printf( i==5 ? "%.2x\n" : "%.2x:", dst_mac[i]);
        }

	char * data_str = argv[3];
	int hex_num = 0;
	int data_len = 0;
	_count_char_of_hex(data_str, &hex_num);
	data_len = hex_num/2;
	uint8_t data[data_len];
	memset(data , 0, sizeof(uint8_t) * data_len);
	_translate_str_to_uint8_t(data_str, data, data_len);
        for(i = 0; i < sizeof(data); i++){
                printf("%.2x", data[i]);
        }
	printf("\n");

	int frame_length = 6+6+2+ data_len +2;
	uint8_t ether_frame[IP_MAXPACKET];
	memcpy(ether_frame, dst_mac, 6);
	memcpy(ether_frame + 6, src_mac, 6);
	memcpy(ether_frame + 12, data, data_len);

	int bytes;
	// Submit request for a raw socket descriptor.
	if ((sd = socket (PF_PACKET, SOCK_RAW, htons (ETH_P_ALL))) < 0) {
	    perror ("socket() failed ");
	    exit (EXIT_FAILURE);
	}
	// Send ethernet frame to socket.
	if ((bytes = sendto (sd, ether_frame, frame_length, 0, (struct sockaddr *) &device, sizeof (device))) <= 0) {
	    perror ("sendto() failed");
	    exit (EXIT_FAILURE);
	}
	printf ("send num=%d,read num=%d\n",frame_length,bytes);     
	close (sd);
}
