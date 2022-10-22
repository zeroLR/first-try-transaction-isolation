#!/bin/sh

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

path=/usr/src/non-repeatable-read

cycle=300                   # 執行次數
snapshotAfterTransaction=0  # 另一筆 transaction commit 前取得的快照計數
snapshotBeforeTransaction=0 # 另一筆 transaction commit 後取得的快照計數
snapshotNonRepeatable=0     # 另一筆 transaction 中取到不同快照計數

for i in $(seq 1 $cycle);
do 
    
    # 執行 lab.sh 中的指令，並過濾出有400、500、600的結果
    output=$(sh $path/lab.sh | grep -E '400|500|600')

    # 儲存各種狀況結果
    ## 兩筆資料皆是另一筆 transaction commit 後的快照
    snapshot1=$(echo $output | grep '600 400')

    ## 兩筆資料皆是另一筆 transaction begin 前的快照
    snapshot2=$(echo $output | grep '500 500')

    ## 第一筆資料為另一筆 transaction begin 前的快照，第二筆則為 transaction commit 後的快照
    snapshot3=$(echo $output | grep '500 400')

    if [ ! -z "$snapshot1" ]
    then
        let snapshotAfterTransaction++
        echo -e "${GREEN}$snapshot1${NC}"
    fi

    if [ ! -z "$snapshot2" ]
    then
        let snapshotBeforeTransaction++
        echo -e "${BLUE}$snapshot2${NC}"
    fi

    if [ ! -z "$snapshot3" ]
    then
        let snapshotNonRepeatable++
        echo -e "${RED}$snapshot3${NC}"
    fi

    # 三種狀況結果統計
    if [ $i -eq $cycle ]
    then
        echo -e "${GREEN}AfterTransaction: ${snapshotAfterTransaction}\n${BLUE}BeforeTransaction: ${snapshotBeforeTransaction}\n${RED}Non-repeatable: $snapshotNonRepeatable${NC}"
    fi
done