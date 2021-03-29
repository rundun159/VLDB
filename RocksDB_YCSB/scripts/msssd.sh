#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Usage $0 [inputfile]"
  exit 1
fi

INPUT_FILE=$1

# read host_written with little endian format

rm cum_waf
rm run_waf

cat $INPUT_FILE | grep "0020:" > xx
cat $INPUT_FILE | grep "0030:" > yy
cat $INPUT_FILE | grep "0040:" > zz
while true
do
	host_big=''
	nand_big=''
  read -r tmp_1 <&3 || break
  read -r tmp_2 <&4 || break
	read -r tmp_3 <&5 || break

	tmp_host_1=`echo $tmp_1 | awk -F' ' '{print $14 $15 $16 $17}'`
	tmp_host_2=`echo $tmp_2 | awk -F' ' '{print $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13}'`
	tmp_nand_1=`echo $tmp_2 | awk -F' ' '{print $14 $15 $16 $17}'`
	tmp_nand_2=`echo $tmp_3 | awk -F' ' '{print $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13}'`

	host_little=$tmp_host_1$tmp_host_2
	nand_little=$tmp_nand_1$tmp_nand_2
	i=${#host_little}
	
#echo "convert big endian"
	while [ $i -gt 0 ]
	do
    i=$[$i-2]
    host_big+=`echo -n ${host_little:$i:2}`
		nand_big+=`echo -n ${nand_little:$i:2}`
	done

#	echo "convert decimal"
	host_val="${host_big^^}"
	nand_val="${nand_big^^}"

	host_written=`printf "obase=%d; ibase=%d; %s\n" 10 16 $host_val | bc`
	nand_written=`printf "obase=%d; ibase=%d; %s\n" 10 16 $nand_val | bc`
	echo  $host_written >> host_written.txt
	echo  $nand_written >> nand_written.txt

done 3<xx 4<yy 5<zz
rm xx
rm yy
rm zz

First_HOST=$(head -n 1 host_written.txt)
First_NAND=$(head -n 1 nand_written.txt)

echo "First_HOST and NAND"
echo $First_HOST
echo $First_NAND

bef_host=$First_HOST
bef_nand=$First_NAND 
count=1

while true
do
	read -r host <&3 || break
	read -r nand <&4 || break

  if [ $(($host-$First_HOST)) -ne 0 ] 
  then
    echo -n "$((($count-1)*300)) ">> cum_waf
#    echo "scale=3; (($host-$First_HOST + $nand-$First_NAND) / ($host-$First_HOST))" | bc >> cum_waf
    echo "scale=3; (($nand-$First_NAND) / ($host-$First_HOST))" | bc >> cum_waf

    echo -n "$((($count-1)*300)) ">> w_$INPUT_FILE
    echo "(($nand-$First_NAND))" | bc >> w_$INPUT_FILE
    echo -n "$((($count-1)*300)) ">> l_$INPUT_FILE
    echo "(($host-$First_HOST))" | bc >> l_$INPUT_FILE
  fi  

  if [ $(($host-$bef_host)) -ne 0 ] 
  then
    if (( (($count%1)) == 0 ))
    then
      echo -n "$((($count-1)*300)) " >> run_waf
#      echo "scale=3; (($nand-$bef_nand + $host-$bef_host) / ($host-$bef_host))" | bc >> run_waf
      echo "scale=3; (($nand-$bef_nand) / ($host-$bef_host))" | bc >> run_waf
      bef_host=$host
      bef_nand=$nand
    fi  
  fi 
	
	count=$(($count+1))
done 3<host_written.txt 4<nand_written.txt 

tail -n 1 run_waf
tail -n 1 cum_waf

rm w_$INPUT_FILE
rm l_$INPUT_FILE
rm host_written.txt
rm nand_written.txt
