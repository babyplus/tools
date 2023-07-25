echo arch, `uname -m`
echo boot_image, `ls -l /boot/vmlinuz | awk -F '-> ' '{print $2}'`
echo date, `date +%s`
echo uptime, `uptime -s`
echo disk, `disk -h`
