port=9906
merge_size1=5000
reuse_size=990000
merge_size2=5000
((merge2_offset=$merge_size1+$reuse_size))
host=xx:xx:xx:xx

./prepare_data --host $host --port $port --user sbtest --password sbtest --database sbtest --parallel=1 --ds $merge_size1 --do 1 --dg 2
./prepare_data --host $host --port $port --user sbtest --password sbtest --database sbtest --parallel=1 --ds $merge_size2 --do 1 --dg 2 --begin $merge2_offset
mysql -u sbtest -h $host -P $port -psbtest -e "set global rocksdb_force_flush_memtable_now=on;"
