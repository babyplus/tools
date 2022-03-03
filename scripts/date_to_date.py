import sys
import datetime
begin = datetime.date(int(sys.argv[1][0:4]),int(sys.argv[1][4:6].lstrip('0')),int(sys.argv[1][6:8].lstrip('0')))
end = datetime.date(int(sys.argv[2][0:4]),int(sys.argv[2][4:6].lstrip('0')),int(sys.argv[2][6:8].lstrip('0')))
delta = datetime.timedelta(days=1)
d = begin
while d <= end:
    print(d.strftime("%Y%m%d"))
    d += delta
