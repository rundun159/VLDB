@@Writer TaehyungGil xogud1231@gmail.com   

#### 순서
1. RockDBClient.java에서 setDbLogDir변수를 자신의 환경에 맞게 변경   
(/RocksDB-YCSB/YCSB/rocksdb/src/main/java/com/yahoo/ycsb/db/rocksdb/)
2. RocksDB Directory에 원하는 버전의 RocksDB Code 넣기
(/Rocksdb_YCSB/RocksDB)
3. YCSB&RocksDB Compile _ scripts/rocksdb_setup.sh 실행
(/Rocksdb_YCSB/scripts)   
실행 Argument : 1) Compile Thread 개수 2) RocksDB Version
ex) ./rocksdb_setup.sh 8 6.18.0-linux64
4. workload_test의 recordcount&operationcount 수정
(/Rocksdb_YCSB/scripts)   
Record/Operation 1000000개당 1GB
5. YCSB 실험 실행 _ scripts/run_rocksdb.sh 실행
(/Rocksdb_YCSB/scripts)   
실행 Argument : 1) Block Device Name 2) Log_Path 3) sudoPW  4) SSD Device
ex) ./run_rocksdb.sh /dev/sdb /home/th/rocksdb_log vldb7988 micron
6. run_waf/cun_waf 추출 _ micron.sh or msssd.sh 실행
(/Rocksdb_YCSB/scripts)   
ex) ./micron.sh micron_log.log
7. 그래프 그리기 _ mkplotr.sh 실행
(/Rocksdb_YCSB/scripts)   
29 Line에서 "cum_waf" using <=> "run_waf" using
4 Line에서 set output 'cum_waf.png' <=> set output 'run_waf.png'
바꿔가면서 실행하면 됨

<hr></hr>

#### 수정 내용들   

1. rocksdb_setup.sh Argument 추가
2. workload_test 에서 Count 수정
