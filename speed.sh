#!/bin/bash
cd $(dirname $0)  
#测速结果输出文件
out_file=./response.csv
#测速地址
speed_url=https://cdnspeed.rongqsvps.top/test_200m.txt

./CloudflareST -n 400 -t 1 -dn 5 -tll 20 -tl 100 -sl 50 -url $speed_url -o $out_file -f ./ip.txt

# 如果结果文件不存在退出
if [ ! -f "$out_file" ];then
  echo "out_file not found"
  exit;
fi

#读取测速结果的第一行结果ip
res_ip=`cat $out_file | head -n 2 |tail -n 1 |awk -v FS="," '{print $1}'`

#判断是否赋值成功
if [ ! -n "$res_ip" ]; then
  echo "res_ip is null"
  exit;
fi

uci set passwall.f16709abb2204e74905b048bc3520b4a.address=$res_ip
uci commit passwall
/etc/init.d/haproxy restart
/etc/init.d/passwall restart

