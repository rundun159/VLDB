#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Usage: $0 [DEV_NAME] [LOG_PATH] [BG Thread]"
	exit 1
fi

PWD=`pwd`
BLKDEV=$1
LOG_PATH=$2
# (jhpark): still needed?
#THREAD=$3

# (jhpark): create mount and backup directory
BACKUP_DIR=/home/$user/backup
MOUNT_DIR=/home/$user/ssd
mkdir -p $MOUNT_DIR
mkdir -p $BACKUP_DIR

echo "london159" -S 

format() {
	echo $sudoPW | sudo umount ${BLKDEV}p1

# re-fresh device
  sudo blkdiscard ${BLKDEV}
  sleep 600
  echo "finish discard the device"

#	echo "Fill SSD w/ sequential data ... loop 1"
#	sudo dd if=/dev/zero bs=1M oflag=direct of=$BLKDEV
#	echo "Fill SSD w/ sequential data ... loop 2"
#	sudo dd if=/dev/zero bs=1M oflag=direct of=$BLKDEV

	echo -e "d\n \n n\n \n \n \n \n w\n" | sudo fdisk $BLKDEV

# (jhpark): Choose file system ext4 vs. f2fs current file system is ext4
	echo "Make FS"
### EXT4
	echo -e "y" | sudo mkfs.ext4 -Elazy_itable_init=0  ${BLKDEV}p1 

### F2FS
#	 echo -e "y" | sudo mkfs.f2fs -f -Elazy_itable_init=0  ${BLKDEV}p1

	echo "Mount"
### EXT4
sudo mount -t ext4 -o discard -o nobarrier ${BLKDEV}p1 ${MOUNT_DIR}
  
### F2FS
#	 sudo mount -t f2fs -odiscard -onobarrier ${BLKDEV}p1 ${MOUNT_DIR}

	sudo chown -R $USER:$USER ${MOUNT_DIR}
}

# smartctl log, WAF
log_streams(){
	while true
	do
# (jhpark): for Micron SSD
		date && sudo smartctl -A ${BLKDEV}p1
# (jhpark) : for Samsung Multi-stream SSD 983a
#    date && sudo nvme get-log ${BLKDEV}p1 --log-id=0xc1 --log-len=512
		sleep 300
	done

}

# dirty log
dirty_streams() {
	while true
	do
		date && du -h ${MOUNT_DIR}
		sleep 300
	done
}


# YCSB log, IOPS
# YCSB directory 에서 수행해야만 돌아감.
load_rocksdb() {
	./bin/ycsb.sh load rocksdb -s -P workload_test -p rocksdb.dir=${MOUNT_DIR}/rocksdb 
}

run_rocksdb() {
	# for multiple thread `-threads N`
	./bin/ycsb.sh run rocksdb -s -P workload_test -threads 1 -p rocksdb.dir=${MOUNT_DIR}/rocksdb  &> ${LOG_PATH}/rocksdb_run.txt 
}

# (jhpark): first you need to load database and copy backup dir 
# you must commeted out this section
######################################################################################
load_rocksdb
cp -r ${MOUNT_DIR}/rocksdb ${BACKUP_DIR}
######################################################################################


# (jhpark): after you loaded database then run rocksdb!
format
rm -rf ${MOUNT_DIR}/*
cp -r ${BACKUP_DIR}/rocksdb ${MOUNT_DIR}/rocksdb 
sync

sleep 10
echo "\nloading end!!!!\n" 

# for iostat
#(iostat -xm 1 /dev/nvme0n1 > ${LOG_PATH}/iostat.log) &

(dirty_streams >> ${LOG_PATH}/db_size.log) &
dirty_pid=$!
(log_streams >> ${LOG_PATH}/nvme_log.log) &
stream_pid=$!

run_rocksdb

sudo kill -9 $stream_pid
sudo kill -9 $dirty_pid

#sudo killall -15 iostat

