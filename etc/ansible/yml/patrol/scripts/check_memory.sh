for n in `seq ${1:-1}`
do
    free -h
    #top -n 1 -p 0 | grep -E '%Cpu' | awk '{print strftime("%Z %H:%M:%S") ", " $0}'
    sleep ${2:-5}
done
