<!--
Copyright (c) 2012 - 2018 YCSB contributors. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You
may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing
permissions and limitations under the License. See accompanying
LICENSE file.
-->

## Quick Start

This section describes how to run YCSB on RocksDB running locally (within the same JVM).
NOTE: RocksDB is an embedded database and so articles like [How to run in parallel](https://github.com/brianfrankcooper/YCSB/wiki/Running-a-Workload-in-Parallel) are not applicable here.

### 1. Set Up YCSB

Clone the YCSB git repository and compile:

    git clone https://github.com/brianfrankcooper/YCSB.git
    cd YCSB
    mvn clean package

### 2. Run YCSB

Now you are ready to run! First, load the data:

    ./bin/ycsb load rocksdb -s -P workloads/workloada -p rocksdb.dir=/tmp/ycsb-rocksdb-data

Then, run the workload:

    ./bin/ycsb run rocksdb -s -P workloads/workloada -p rocksdb.dir=/tmp/ycsb-rocksdb-data

### 3. Provide RocksDB Connection Parameters

Connection Parameters Added

- `rocksdb.comp`
  * Set rocksdb background compaction threads

## RocksDB Configuration Parameters

* ```rocksdb.dir``` - (required) A path to a folder to hold the RocksDB data files.
    * EX. ```/tmp/ycsb-rocksdb-data```

* for additional configuration, refer to [java configuration interface](https://github.com/facebook/rocksdb/blob/master/java/src/main/java/org/rocksdb/DBOptionsInterface.java) / [java db option](https://github.com/facebook/rocksdb/blob/master/java/src/main/java/org/rocksdb/DBOptions.java) / [java column family option](https://github.com/facebook/rocksdb/blob/master/java/src/main/java/org/rocksdb/ColumnFamilyOptions.java)

### 내가 사용한 옵션들
```bash
# DBOptions
.setWritableFileMaxBufferSize("buffer size in byte") // buffer 사이즈 조정
.setStatsDumpPeriodSec("time in second") // log dump 하는 시간 간격
.setDbLogDir("$PATH")                    // log path
.setMaxBackgroundCompactions("# of compaction thread")  // 최대 compaction thread 개수 조정
.setUseDirectIoForFlushAndCompaction("T/F")  // direct IO 사용 여부

# ColumnFamilyOptions
.setTargetFileSizeBase("target file size in byte")   // SST 파일 사이즈 조정
```
