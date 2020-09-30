#查看当前文件中lua文件有多少行
find . "(" -name "*.lua" ")" -print | xargs wc -l
