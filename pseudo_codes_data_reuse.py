# This is the pseudo codes for data reuse in X-Engine. 

def reuse_object(meta, writer, iter):
  if (iter.type() == EXTENT) :
	meta.add(iter.current_extent().range(), iter.current_extent().id())
  elif (iter.type() == DATABLOCK) :
	writer.add_data_block(iter.current_block())
	
def copy_data_stream(meta, writer, iter):
  while iter.has_data() :
	if iter.type() == ROW:
	  writer.add_row(iter.key(), iter.value())
  	else :
	  reuse_object(meta, writer, iter)
    iter.next()

writer = create_new_writer() // new writer for store merge result.
meta = create_new_meta_data() 
# assume we have two data stream to merge.
# iterator.key() return first key of current iterate Object(e.g. Extent, DataBlock)
# iterator.last_key() return last key of current iterate Object
# key() == last_key() while in middle of DataBlock.
l1_iter = level1.create_iterator(compact_range)
l2_iter = level2.create_iterator(compact_range)

while l1_iter.has_data() and l1_iter.has_data():
  min_iter, max_iter, equal = less_or_equal(l1_iter, l2_iter)
  if equal:
	if min_iter.type() != ROW: 
	  // encounter border of Object, open and re-compare.
	  min_iter.open() 
	  continue
	if max_iter.type() != ROW:
	  max_iter.open()
	  continue
	writer.add_row(merge_result_of_equal_rows(min_iter, max_iter))
  elif min_iter.type() != ROW:
	if min_iter.last_key().compare(max_iter.key()) < 0:
	  reuse_object(meta, writer, min_iter)
	else:
	  min_iter.open()
	  continue
  else:
	writer.add_row(min_iter.key(), min_iter.value())
  min_iter.next()

# add remain data in l1 & l2 iterator
copy_data_stream(meta, writer, l1_iter)
copy_data_stream(meta, writer, l2_iter)
