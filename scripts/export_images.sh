original_path=`pwd`
exec_path=`dirname $0`
cd $exec_path

data_path=${1:-/tmp}
url=${2:-http://172.17.0.1/pic/}
data_file_prefix=${3:-test_}
data_file_suffix=${4:-.txt}

for i in {1..3}
do
    date=`date +%Y%m%d -d "-${i}day"`
    data_file=$data_path/${data_file_prefix}${date}${data_file_suffix}
    [ ! -f $data_file ] || {
        output=$data_path/images/$date/
        mkdir -p $output
        [ 0 -ne `ls -A $output  | wc -l` ] || {
            docker run -v $data_path:$data_path --net host -it export_client node export_images.js --output $output --data $data_file --url $url
        }
    }
done

cd $original_path
