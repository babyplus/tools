file=/tmp/sample_generated_$RANDOM.csv
output=/tmp/sample_output_$RANDOM.csv
echo='echo -e -------------------\n'

cat > $file << eof
0001, 0, test000100a
0001, 1, test000101a, test000101b
0001, 2, test000102a, test000102b, test000102c, test000102d
0001, 3, test000103a, test000103b, test000103c
0002, 0, test000200a
0002, 3, test000203a, test000203b, test000203c
0003, 3, test000303a, test000303b, test000303c
eof

first_row="\"\\\",0a,1a,1b,2a,2b,2c,2d,3a,3b,3c\\\"\""
placeholder_type_0="\"\\\", \\\"\""
placeholder_type_1="\"\\\", , \\\"\""
placeholder_type_2="\"\\\", , , , \\\"\""
placeholder_type_3="\"\\\", , , \\\"\""
maximum_capacity_of_row=`awk 'BEGIN {max=0} {current=length($0);max=(max<current)?current:max} END {print max+1}' $file`
separator="\"\\\", \\\"\""

$echo data for test \($file\):
cat $file | awk '{print "    "$0}'

compile_cmd="gcc -D FIRST_ROW=$first_row -D MAXIMUM_CAPACITY_OF_ROW=$maximum_capacity_of_row -D SEPARATOR=$separator -D PLACEHOLDER_TYPE_0=$placeholder_type_0 -D PLACEHOLDER_TYPE_1=$placeholder_type_1 -D PLACEHOLDER_TYPE_2=$placeholder_type_2 -D PLACEHOLDER_TYPE_3=$placeholder_type_3 merger.c"
$echo 'compile command:\n    ' $compile_cmd
bash -c "$compile_cmd"

execute_cmd="./a.out $file $output"
$echo 'execute command:\n    '$execute_cmd
$execute_cmd

$echo output \($output\):
cat $output | awk '{print "    "$0}'

