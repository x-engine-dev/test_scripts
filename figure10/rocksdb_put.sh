test_case=fillrandom
test_dir=
data_dir=$test_dir/data
table_size=10000000
value_size=112
run_time=10
result_dir=pip_fillrandom

cd $test_dir/rocksdb_result/
mkdir $result_dir
cd -

for ((threads=8; threads<=128; threads=threads+8))
do
$test_dir/rocksdb/rocksdb_db_bench  \
--benchmarks=$test_case    \
--db=$data_dir    \
--wal_dir=$data_dir  \
--num=$table_size  \
--threads=$threads  \
--value_size=$value_size  \
--duration=$run_time  \
--sync=1  \
--num_column_families=128  \
--statistics=1  \
--histogram=1    \
--enable_pipelined_write=true \
--disable_wal=0  \
--block_size=16384  \
--compression_type=none    \
--write_buffer_size=268435456  \
--max_write_buffer_number_to_maintain=10000  \
--min_write_buffer_number_to_merge=10000  \
--max_write_buffer_number=10000  \
--max_background_jobs=1  \
--level0_file_num_compaction_trigger=10000  \
--level0_slowdown_writes_trigger=10064  \
--level0_stop_writes_trigger=10128  \
--num_levels=6    \
--transaction_db=0 \
--transaction_lock_timeout=0 \
--min_level_to_compress=6    \
--max_bytes_for_level_base=536870912  \
--use_existing_db=0  \
--allow_concurrent_memtable_write=1  \
--enable_write_thread_adaptive_yield=1  \
--batch_size=1 > some.log

egrep "^fillrandom" some.log > $test_dir/rocksdb_result/$result_dir/$threads.txt
grep "Percentiles: " some.log >> $test_dir/rocksdb_result/$result_dir/$threads.txt

done
