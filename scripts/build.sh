original_path=`pwd`
exec_path=`dirname $0`
cd $exec_path

cd .. 
docker build -t export_client .

cd $original_path
