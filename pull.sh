host=$1

timezone="Europe/London"
local_path=/tmp
remote_path=/tmp/test

local_class_a_data_path=$local_path/logs/class_a/$host
local_class_a_data_format="Trace-|+%Y-%m-%d|.log"
local_class_a_record=$local_class_a_data_path/record.txt
remote_class_a_data_path=$remote_path
remote_class_a_data_format="Trace-|+%Y-%m-%d|.log"

local_class_b_data_path=$local_path/logs/class_b/$host
local_class_b_data_format="|+%Y%m%d|.log"
local_class_b_record=$local_class_b_data_path/record.txt
remote_class_b_data_path=$remote_path
remote_class_b_data_format="|+%Y%m%d|.log"

pull(){
    local_x_path=$1
    local_x_data_format=$2
    local_x_record=$3
    remote_x_path=$4
    remote_x_data_format=$5
    
    local_x_prefix=${local_x_data_format%%|*}
    local_x_date=`echo $local_x_data_format | awk -F '|' '{print $2}'`
    local_x_suffix=${local_x_data_format##*|}
    remote_x_prefix=${remote_x_data_format%%|*}
    remote_x_date=`echo $remote_x_data_format | awk -F '|' '{print $2}'`
    remote_x_suffix=${remote_x_data_format##*|}
    
    mkdir -p $local_x_path
    touch $local_x_record
    for i in {1..5}
    do
        local_archived_date=`TZ="$timezone" date $local_x_date -d "-${i}day"`
        local_x_file=$local_x_path/$local_x_prefix$local_archived_date$local_x_suffix
        remote_archived_date=`TZ="$timezone" date $remote_x_date -d "-${i}day"`
        remote_x_file=$remote_x_path/$remote_x_prefix$remote_archived_date$remote_x_suffix
        grep "md5sum_check: $host:$remote_x_file No such file or directory" $local_x_record &>/dev/null
        [ 0 -eq $? -o -f $local_x_file ] || {
            # No previous attempt was made to extract the file and $local_x_file does not exist.
            # Try to extract the $remote_x_file from $host.
            ping $host -c 1 &>/dev/null
            [ 0 -ne $? ] || {
                remote_x_md5=`ssh $host md5sum $remote_x_file 2>&1`
                echo $remote_x_md5 | grep 'No such file or directory' &>/dev/null
                [ 0 -eq $? ] && {
                    echo md5sum_check: $host:$remote_x_file No such file or directory >> $local_x_record
                } || {
                    scp $host:$remote_x_file $local_x_file
                    local_x_md5=(`md5sum $local_x_file`)
                    remote_x_md5=($remote_x_md5)
                    [ "$local_x_md5" = "$remote_x_md5" ] || rm $local_x_file
                }
            }
        }
    done
}

pull $local_class_a_data_path $local_class_a_data_format $local_class_a_record $remote_class_a_data_path $remote_class_a_data_format
pull $local_class_b_data_path $local_class_b_data_format $local_class_b_record $remote_class_b_data_path $remote_class_b_data_format
