#!/bin/bash
ps -aux | grep scp | awk '{print $11}' | grep scp && exit

host=$1

timezone="UTC"
local_path=/tmp

local_A_data_path="$local_path/logs/class_A/$host"
local_A_data_format="Test-|+%Y-%m-%d|.log"
local_A_record="$local_A_data_path/record.txt"
remote_A_data_path="/tmp/Test"
remote_A_data_format="Test-|+%Y-%m-%d|.log"

local_B_data_path="$local_path/logs/class_B/$host"
local_B_data_format="Sample_|+%Y-%m-%d|.log"
local_B_record="$local_B_data_path/record.txt"
remote_B_data_path="/tmp/Sample"
remote_B_data_format="Sample_|+%Y-%m-%d|.log"

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
        local_x_log=${local_x_path}/${local_x_prefix}${local_archived_date}${local_x_suffix}
        local_x_zip=${local_x_log}.gzip
        remote_archived_date=`TZ="$timezone" date $remote_x_date -d "-${i}day"`
        remote_x_log=${remote_x_path}/${remote_x_prefix}${remote_archived_date}${remote_x_suffix}
        remote_x_zip=${remote_x_log}.gzip
        remote_archived_date=`TZ="$timezone" date $remote_x_date -d "-${i}day"`
        grep "md5sum_check: $host:$remote_x_log No such file or directory" $local_x_record &>/dev/null
        [ 0 -eq $? -o -f $local_x_log ] || {
            [ -f $local_x_zip ] && {
                # echo $local_x_zip exist.
                tmp_path=/tmp/tar_$RANDOM
                mkdir -p $tmp_path
                tar -xzf $local_x_zip -C $tmp_path &>/dev/null
                rm -f $local_x_zip
                mv $tmp_path/$remote_x_log $local_x_log
                rm -rf $tmp_path
                local_x_md5=(`md5sum $local_x_log`)
                remote_x_md5=(`grep "$remote_x_log $host" $local_x_record | tail -1`)
                [ "$local_x_md5" = "$remote_x_md5" ] || rm $local_x_log
                ssh -o ConnectTimeout=5 $host rm $remote_x_zip
                exit
            } || {
                # echo $local_x_zip does not exist.
                # echo try to pull the $remote_x_zip from $host.
                ping $host -c 1 &>/dev/null
                [ 0 -ne $? ] || {
                    remote_x_md5=`ssh -o ConnectTimeout=5 $host md5sum $remote_x_zip 2>&1`
                    echo $remote_x_md5 | grep 'Connection timed out' &>/dev/null
                    [ 0 -eq $? ] && {
                        echo ssh: ssh $host Connection timed out >> $local_x_record
                        exit
                    }
                    echo $remote_x_md5 | grep 'No such file or directory' &>/dev/null
                    [ 0 -eq $? ] && {
                        remote_x_md5=`ssh -o ConnectTimeout=5 $host md5sum $remote_x_log 2>&1`
                        echo $remote_x_md5 | grep 'No such file or directory' &>/dev/null
                        [ 0 -eq $? ] && {
                            echo md5sum_check: $host:$remote_x_log No such file or directory >> $local_x_record
                            exit
                        }||{
                            ssh -o ConnectTimeout=5 $host tar -Pczf $remote_x_zip $remote_x_log
                            echo $remote_x_md5 $host >> $local_x_record
                            exit
                        }
                    } || {
                        ps -aux | grep scp | awk '{print $11}' | grep scp && exit
                        scp -o ConnectTimeout=5 $host:$remote_x_zip $local_x_zip
                        local_x_md5=(`md5sum $local_x_zip`)
                        remote_x_md5=($remote_x_md5)
                        [ "$local_x_md5" = "$remote_x_md5" ]||rm $local_x_zip
                        exit
                    }
                }
            }
        }
    done
}

pull $local_A_data_path $local_A_data_format $local_A_record $remote_A_data_path $remote_A_data_format
pull $local_B_data_path $local_B_data_format $local_B_record $remote_B_data_path $remote_B_data_format
