#!/bin/sh

# 執行 initdb 中的 query 初始化實驗環境
psql -U postgres -f ./initdb.sql  --out log.txt

# 將兩個執行 transaction 放到背景並發執行
psql -U postgres -f ./alice.sql &

psql -U postgres -f ./transfer.sql &

