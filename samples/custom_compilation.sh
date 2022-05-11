file=/tmp/sample_generated_$RANDOM.csv
temp=/tmp/sample_generated_$RANDOM.csv.temp
output=/tmp/sample_output_$RANDOM.csv
date_format='+%Y-%m-%d %H:%M:%S'
echo='echo -e -------------------\n'

for n in {0..2}
do
    for n in {0..5}
    do
        date=`date "$date_format"`
        echo "$date, $((RANDOM%9)), $RANDOM$RANDOM$RANDOM" >> $temp
        echo "$date, `printf \"\x$(printf %x $((RANDOM%26+65)))\"`, $RANDOM$RANDOM$RANDOM" >> $temp
        echo "$date, `printf \"\x$(printf %x $((RANDOM%26+97)))\"`, $RANDOM$RANDOM$RANDOM" >> $temp
    done
    sleep 2
done

sort -V $temp > $file
rm $temp

key_length=$((`date "$date_format" | wc -c`-1))
type_position=$(($key_length+`printf ", "| wc -c`))
data_begin_position=$(($type_position+`echo ", "| wc -c`))
maximum_capacity_of_row=`awk 'BEGIN {max=0} {current=length($0);max=(max<current)?current:max} END {print max+1}' $file`
first_row="\"\\\",0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z\\\"\""
separator="\"\\\", \\\"\""
default_placeholder="\"\\\", \\\"\""

$echo data for test \($file\):
cat $file | awk '{print "    "$0}'

compile_cmd="gcc -D KEY_LENGTH=$key_length -D TYPE_POSITION=$type_position -D DATA_BEGIN_POSITION=$data_begin_position -D MAXIMUM_CAPACITY_OF_ROW=$maximum_capacity_of_row -D FIRST_ROW=$first_row -D SEPARATOR=$separator -D DEFAULT_PLACEHOLDER=$default_placeholder merger.c"
$echo 'compile command:\n    '$compile_cmd
bash -c "$compile_cmd"

execute_cmd="./a.out $file $output"
$echo 'execute command:\n    '$execute_cmd
$execute_cmd

$echo output \($output\):
cat $output | awk '{print "    "$0}'
