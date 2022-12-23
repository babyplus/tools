file=${1:-wireshark_example.txt}
interface=${2:-enp0s8}

gcc main.c -o packet_sender

[[ $1 == "-h" ]] && {
  echo "Usage: $0 [file] [interface]"
  exit 0
}

[ -f $file ] || {
  echo $file: No such file
  exit 1
}

str=`cat $file |awk '{$1="";print $0 }' | sed ":a;N;s/\\n//g;ta" |sed s/" "//g`

dst=${str:0:12}
src=${str:12:12}
data=${str:24}
echo $src
echo $dst
echo $data

./packet_sender $interface $dst $data $src
