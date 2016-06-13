#### GC.stat
{:count=>53,
 :heap_allocated_pages=>2457,
 :heap_sorted_length=>2458,
 :heap_allocatable_pages=>0,
 :heap_available_slots=>1001477,
 :heap_live_slots=>949137,
 :heap_free_slots=>52340,
 :heap_final_slots=>0,
 :heap_marked_slots=>535335,
 :heap_swept_slots=>413945,
 :heap_eden_pages=>2457,
 :heap_tomb_pages=>0,
 :total_allocated_pages=>2457,
 :total_freed_pages=>0,
 :total_allocated_objects=>5132178,
 :total_freed_objects=>4183041,
 :malloc_increase_bytes=>13038736,
 :malloc_increase_bytes_limit=>32225676,
 :minor_gc_count=>39,
 :major_gc_count=>14,
 :remembered_wb_unprotected_objects=>11388,
 :remembered_wb_unprotected_objects_limit=>22776,
 :old_objects=>504305,
 :old_objects_limit=>1008610,
 :oldmalloc_increase_bytes=>13039120,
 :oldmalloc_increase_bytes_limit=>46281412}

#### count
	the number of times GC run
#### #### heap_used( heap_allocated_pages)
	the number of heap pages allocated
	The larger this number is, the more memory our Ruby process consumes, and the more work GC has to do
	In our example, the memory used for heap is 2457 * 408 * 40 = 40,114,560 bytes, about 40 MB.
	The name of this parameter is misleading. It doesn’t necessarily mean that all of these heap pages are used. They might be allocated, but empty. Also, this number isn’t cumulative. It can be decreased if Ruby shrinks the heap space.
#### heap_increment( heap_allocatable_pages)
	In theory, this should be the number of heap pages that can be allocated before the interpreter needs to run the GC and grow the heap space again.
#### heap_length( heap_sorted_pages)
	The total number of heap pages, including heap_used and heap_increment.
#### heap_live_num( heap_live_slots)
	The current number of live objects in the heap.
	This number includes objects that are still live but will be collected next time GC runs. So we can’t use it to estimate the number of free slots in the heap.
#### heap_free_num( heap_free_slots)
	The current number of free object slots in the heap after the last GC run.
	This number is also misleading and can’t be used to estimate the current number of free slots. The only way to know how much free space you have on the heap is to call GC.start before looking at the heap_free_num.
#### heap_final_num( heap_final_slots)
	The number of objects that weren’t finalized during the last GC and that will be finalized later.
#### heap_marked_slots, heap_swept_slots
	The number of slots marked and swept during the last GC
#### total_allocated_object, total_freed_object
	The number of allocated and freed objects during the process lifetime
#### heap_eden_page_length, heap_tomb_page_length( heap_eden_pages, heap_tomb_pages)
	The number of heap pages in eden and tomb
#### total_allocated_pages, total_freed_pages, total_allocated_objects, total_freed_ objects

A Ruby object can store only a limited amount of data, up to 40 bytes in a 64-bit system. Slightly less than half of that is required for upkeep. All data that does not fit into the object itself is dynamically allocated outside of the Ruby heap. When the object is swept by GC, the memory is freed

For example, a Ruby string stores only 23 bytes in the RSTRING object on a 64- bit system. When the string length becomes larger than 23 bytes, Ruby allocates additional memory for it. We can see how much by calling ObjectSpace#memsize_of

GC.start(full_mark: true, immediate_sweep: true)
GC.stat.select { |k,v| [:count, :heap_used].include?(k) }

Generational GC divides all Ruby objects into two groups: a new generation and the old generation. An object becomes old when it survives at least one GC. Malloc limits for these generations are different: GC_MALLOC_LIMIT_MIN for the new generation and GC_OLDMALLOC_LIMIT_MIN for the old generation. Initial default values are the same, though: 16 MB.
The minimum 16 MB malloc limit is already a nice improvement over older Ruby. But even better is that it is allowed to grow up until GC_MALLOC_LIMIT_MAX (32 MB by default) for the new generation, and GC_OLDMALLOC_LIMIT_MAX (128 MB by default) for the old generation.
It is a good thing that the old generation’s limit is larger because long-lived objects tend to be the ones to use more memory.

In practice, the new generations’ malloc limit grows even faster because it applies not to the previous limit, but to the amount of memory your application has allocated since the last GC. That number is always bigger. So, for example, if our current limit is 16 MB and we’re trying to allocate another 20 MB, then our next limit is 20 * 1.4 = 28 MB


In this book we repeatedly observed that new Ruby versions consistently perform better because the GC is faster. But why is it faster?
The first reason it’s faster is that less GC is needed.
Ruby implements GC using a simple two-phase mark and sweep (M&S) algorithm
In the mark phase it finds all living objects on the Ruby heap and marks them as live. In the sweep phase it collects unmarked objects.
Naturally, GC can’t allow you to allocate new objects while it marks. So your program pauses for the duration of GC.
Ruby 2.1 with RGenGC reduces the number of pauses, and Ruby with RIncGC optimizes the pause time.
