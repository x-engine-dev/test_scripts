port=9910
engine=INNODB
ps_mode=disable
tables=16
test_dir=
host=xx:xx:xx:xx

sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=0  --mysql-port=$port --mysql_table_engine=$engine --num-threads=1 --time=20 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua cleanup
sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=0  --mysql-port=$port --mysql_table_engine=$engine --num-threads=1 --time=20 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua prepare

sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=200000  --mysql-port=$port --mysql_table_engine=$engine --num-threads=1 --time=20 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua run > $test_dir/conn_scale/$engine/insert_1.txt

for ((threads=16; threads<=512; threads=threads+16))
do
sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=0  --mysql-port=$port --mysql_table_engine=$engine --num-threads=1 --time=20 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua cleanup
sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=0  --mysql-port=$port --mysql_table_engine=$engine --num-threads=1 --time=20 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua prepare
sysbench --mysql-host=$host --mysql-db=sbtest --mysql-user=sbtest --mysql-password=sbtest  --oltp-tables-count=$tables --oltp_table-size=200000  --mysql-port=$port --mysql_table_engine=$engine --num-threads=$threads --time=10 --report_interval=1 --db-ps-mode=$ps_mode --db-driver=mysql $test_dir/sysbench/oltp_insert.lua run > $test_dir/conn_scale/$engine/insert_$threads.txt
done

