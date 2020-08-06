import sys
try:
    file = sys.argv[1]
except:
    file = "OAM.md"
with open(file, encoding='utf-8') as _file:
    title = ["","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F",
             "","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F",]
    ret_list = []
    for line in _file.readlines():
        result = ""
        index  = 0
        if line.startswith("#"):
            index = line.count("#")
            if (1 == index) :
                continue
            title[index-1] = line.replace("\n", "").replace(line.split(" ")[0], "")
            title[index] = None
            for _t in title:
                if _t is None:
                    break
                result += _t
            ret_list.append(result)
        if "<cr>" in line:
            ret_list.append("  <cr>")
ret = []
for r in ret_list:
    if ("  <cr>" == r):
        ret[-1] = ret[-1] + r
    else:
        ret.append(r)
for txt in ret:
    if "<cr>" in txt :
        print(txt.replace("<cr>",""))