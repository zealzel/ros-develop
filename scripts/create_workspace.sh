#!/bin/bash
workspace=$1
if [ ! -d "$HOME/$workspace/src" ]; then
    echo "目錄 ~/$workspace 不存在，是否要建立 ~/$workspace/src? (y/n)"
    read answer

    if [ "$answer" == "y" ]; then
        mkdir -p "$HOME/$workspace/src"
        echo "已成功建立 ~/$workspace/src"
    else
        exit 1
    fi
else
    echo "~/$workspace 目錄已存在"
fi
