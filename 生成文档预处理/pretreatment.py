if __name__ == '__main__':
    result = ["# 拓扑\r\n",'\r\n','![实验拓扑](topo_0.png)  \r\n',
              "参考手册: 配置基于VLAN的以太网CFM基本功能示例(二层网络)  \r\n",
              "* *手册例子中的拓扑使用较多机器,因此进行部分裁减*  \r\n"]
    _tmp = []
    _tmp2 = ["操作步骤:\r\n",'\r\n']
    _tmp2_index = 1
    _ignore = False
    with open("_note.md",'rb') as _f:
        for line in _f:
            if line.startswith("# ".encode()):
                _tmp2.append("{}. {}".format(_tmp2_index, line.decode().replace("# ","")))
                _tmp2_index += 1
            if line.startswith("#".encode()):
                line = line.replace("#".encode(), "\r\n#".encode(), 1)
            if b'```' in line:
                _ignore = not _ignore
                _tmp.append(line.decode())
                continue
            if _ignore or b'#' in line:
                _tmp.append(line.decode())
                continue
            if not 2 == len(line):
                if not line.startswith("**".encode()):
                    _tmp.append("*" + line.decode().lstrip().rstrip() + "*  \r\n")
                else:
                    _tmp.append(line.decode().replace("**","") + " \r\n")
            else:
                _tmp.append(line.decode())
    result.extend(_tmp2)
    result.extend(_tmp)
    with open("note.md", 'wb') as _f:
        for line in result:
            _f.write(line.replace("**","").encode("utf-8"))
