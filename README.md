# 描述

根据特定格式的文本生成图像

## 测试

```
for n in {1..20}; do echo field$n, $((RANDOM%16+1)), $((RANDOM%3)), $RANDOM;done | awk -f fields2diagram.awk
```
