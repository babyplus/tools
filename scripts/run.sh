path="`pwd`"
project_path=${path%/*}
data_path=${1:-/tmp}
docker run -v $data_path:/tmp  --net host -it export_client
