#!/bin/bash

#save the state of current free space on the disk
df -h > ./srcs/dfh_bck.txt

rm -rf ~/Library/Caches/*
rm -rf ~/Library/Application\ Support/Code/CachedExtensionVSIXs/*
rm -rf ~/Library/Application\ Support/Code/Cache/*
rm -rf ~/Library/Application\ Support/Code/CachedData/*
rm -rf ~/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/*
rm -rf ~/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/*
rm -rf ~/Library/Application\ Support/com.operasoftware.OperaGX/Service Worker/CacheStorage/*
rm -rf ~/Library/Application\ Support/Slack/Cache/*
rm -rf ~/Library/Application\ Support/Telegram\ Desktop/tdata
rm -rf ~/Library/Application\ Support/com.operasoftware.OperaGX/Service\ Worker/CacheStorage/*
rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage/*
rm -rf ~/Library/Application\ Support/Code/CachedExtensionVSIXs/*
rm -rf ~/Library/Caches/vscode-cpptools/ipch/*
rm -rf ~/Library/Containers/*

#compare the state of free space on the disk before and after the cleaning
df -h > ./srcs/dfh_after.txt
diff ./srcs/dfh_bck.txt ./srcs/dfh_after.txt
# readable form of the diff
printf "You freed this much space: " && cat ./srcs/dfh_after.txt | grep -E "Filesystem|disk1s1" | awk '{print $4}'

#remove the backup files
rm -rf ./srcs/dfh_bck.txt
rm -rf ./srcs/dfh_after.txt