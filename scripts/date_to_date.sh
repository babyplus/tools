THIS_PATH=$(cd `dirname $0`;)
cd $THIS_PATH
##要求传入的数据格式为yyyyMMdd的两个开始和结束参数，如20170201 20170310
start_input=$1
end_input=$2

##将输入的日期转为的时间戳格式
startDate=`date -d "${start_input}" +%s`
endDate=`date -d "${end_input}" +%s`

##计算两个时间戳的差值除于每天86400s即为天数差
stampDiff=`expr $endDate - $startDate`
dayDiff=`expr $stampDiff / 86400`

##根据天数差循环输出日期
for((i=0;i<$dayDiff;i++))
do
    process_date=`date -d "${start_input} $i day" +'%Y%m%d'`
    echo $process_date
done
