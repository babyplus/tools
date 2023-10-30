# 简介

根据markdown文件中的前三级目录分别生成目录、drawio文件以及图

*前两级目录不要有空格*

## 测试

```
for n in `seq 3`;do echo "# 目录"$n;for m in `seq $((RANDOM%5))`;do echo "## 文件名"$m;for l in `seq $((RANDOM%5))`;do echo "### 图"$l; done;done;done  | awk -f md2drawio.awk
```
## 配合其他项目使用

*其他项目中需要有格式符合要求的markdown文件*

```
git submodule add -b awk_md2drawio git@github.com:babyplus/tools.git md2drawio
mkdir -p drawio
awk -v dir=drawio -f md2drawio/md2drawio.awk README.md
```
