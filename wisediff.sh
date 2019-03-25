#/bin/bash

if [[ $# -ne 2 ]];then
    echo "将本脚本放到项目顶层"
    echo "请输入参数！eg: wisediff.sh master release-1.6.0-cmft "
    exit 0;
fi

src1=$1
src2=$2

time=$(date "+%Y%m%d")
path=$PWD
diffDir=$path/$time-diff
mkdir $diffDir

for dir in $path/*/
do
    cd $dir
    #过滤掉非git文件夹和输出文件夹
    if [ ! -d "$diffDir" ] || [ ! -d ".git" ];then
        continue
    fi
    git pull -f > /dev/null
    
    if [ $(git branch -a | grep $src1 -c) -lt 1 ];then
        echo "\033[31m $dir 没有 $src1 分支 \033[0m"
        continue
    fi
    if [ $(git branch -a | grep $src2 -c) -lt 1 ];then
        echo "\033[31m $dir 没有 $src2 分支 \033[0m"
        continue
    fi

    basename=`basename $PWD`
    echo "diff 文件重定向到 $diffDir/$basename.diff"
    git diff $src1 $src2 > $diffDir/$basename.diff
done
echo "请打开$diffDir 文件查看git diff"
open $diffDir

