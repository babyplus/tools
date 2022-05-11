file=/tmp/sample_generated_$RANDOM.csv
output=/tmp/sample_output_$RANDOM.csv
echo='echo -e -------------------\n'

cat > $file << eof
0001, 0, test000100
0001, 1, test000101
0001, 2, test000102
0001, 3, test000103
0001, A, test00010A
0001, B, test00010B
0001, H, test00010H
0001, Y, test00010Y
0001, a, test00010a
0001, b, test00010b
0001, o, test00010o
0001, z, test00010z
0009, 0, test000900
0009, 1, test000901
0009, 2, test000902
0009, 3, test000903
0009, A, test00090A
0009, B, test00090B
0009, H, test00090H
0009, Y, test00090Y
0009, a, test00090a
0009, b, test00090b
0009, o, test00090o
0009, z, test00090z
eof

$echo data for test \($file\):
cat $file | awk '{print "    "$0}'

compile_cmd="gcc merger.c"
$echo 'compile command:\n    '$compile_cmd
bash -c "$compile_cmd"

execute_cmd="./a.out $file $output"
$echo 'execute command:\n    '$execute_cmd
$execute_cmd

$echo output \($output\):
cat $output | awk '{print "    "$0}'

