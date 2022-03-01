original_path=`pwd`
exec_path=`dirname $0`
cd $exec_path

image="${1:-export_client}"
cd .. 
docker build -t $image .

cd $original_path
