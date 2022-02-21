path="`pwd`"
project_path=${path%/*}
date=`date +%Y%m%d`
data_path=${1:-/tmp}
data_file=${2:-$data_path/test_$date.txt}
output=${3:-$data_path/images/$date/}
url=${4:-http://172.17.0.1/pic/}
mkdir -p $output
docker run -v $data_path:/tmp --net host -it export_client node export_images.js --output $output --data $data_file --url $url 
