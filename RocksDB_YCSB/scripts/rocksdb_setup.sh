#!/bin/bash

CUR_DIR=`pwd -P` 
YCSB_DIR=$CUR_DIR/../YCSB
ROCKSDB_DIR=$CUR_DIR/../RocksDB/rocksdb

# compile RocksDB
cd $ROCKSDB_DIR
make rocksdbjavastaticrelease -j

# compile YCSB and change rocksdbjni file for using our own rocksdb build
cd $YCSB_DIR
# compile YCSB rocksdb-binding using maven
mvn -pl com.yahoo.ycsb:rocksdb-binding -am clean package

# remove exisiting rocksdbjni
rm ./rocksdb/target/dependency/rocksdbjni-*

# copy our own rocksdb (double-check your rocksdb veresion) 
cp ${ROCKSDB_DIR}/java/target/rocksdbjni-6.15.5.jar ./rocksdb/target/dependency/.

echo "RocksDB YCSB setup finish! : )"
