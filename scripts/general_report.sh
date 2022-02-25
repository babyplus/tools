[ 5 -le $# ] || {
    echo Usage: $0 project_path images_path archived_path start_date end_date [host]
    exit 1
}

original_path=`pwd`
exec_path=`dirname $0`
cd $exec_path

directory=${1:-/vagrant/Documents/六捷/202202/0216.黄汉加.数据图像化/ping_results/}
input_subdirectory=${2:-/images/}
output_subdirectory=${3:-/archived/}
dates=`bash date_to_date.sh $4 $5`
host=$6
input=$directory/$input_subdirectory

[ ! "$host" ] || {
    output=$directory/$output_subdirectory/by_host/
    mkdir -p $output
    file="$output/$host.md"
    > $file
    echo '# '$host > $file
    for d in $dates
    do
        ls $input/$d | grep $host | awk -v date=$d '{print "## "date"\n\n![](../../images/" date "/"$1")\n\n"}' >> $file 
    done
    docker run -w /data/$output_subdirectory/by_host --rm --volume "$directory:/data" pandoc/latex $host.md -o $host.docx 
}
[ "$host" ] || {
    output=$directory/$output_subdirectory/by_date/
    mkdir -p $output
    for d in $dates
    do
        file="$output/$d.md"
        > $file
        echo '# '$d > $file
        ls $input/$d | sed s/.png//g | awk -v date=$d '{print "## "$1"\n\n![](../../images/" date "/" $1 ".png)\n\n"}' >> $file 
        docker run -w /data/$output_subdirectory/by_date --rm --volume "$directory:/data" pandoc/latex $d.md -o $d.docx 
    done
}

cd $original_path
