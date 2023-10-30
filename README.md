# 简介

根据markdown文件中的前三级目录分别生成目录、drawio文件以及图

*前两级目录不要有空格*

```
for n in `seq 3`;do echo "# 目录"$n;for m in `seq $((RANDOM%5))`;do echo "## 文件名"$m;for l in `seq $((RANDOM%5))`;do echo "### 图"$l; done;done;done  | awk -f md2drawio.awk
```

