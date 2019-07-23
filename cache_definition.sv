//---------------------------------------------------------------------------------------------------

// Package definition for a 16KB set-associative cache memory connected to a 1M x 16 secondary memory

//---------------------------------------------------------------------------------------------------

package cache_definition;

	//16-bit cache data
	typedef bit [31:0] cache_data_type;

    //data structure for cache memory
    typedef struct packed {
        bit LRU;        //Least Recently Used bit
        bit valid;
        bit dirty;
        bit [19:12] tag;
        //cache_data_type data;
	} cache_table_type;

    //data structure for cache index
    typedef struct{
		bit [9:0] index;
		bit we;
	} cache_index_type;

    //---------------------------------------------------------------
	//------	data structures for CPU <-> Cache controller	-----    

    //CPU request (CPU -> Cache controller)
    typedef struct {
		bit [19:0] addr;
		cache_data_type data;
		bit rw;					// 0=read / 1=write
		bit valid;				// valid read/write request from the processor		
	} cpu_to_cache_type;

    //Cache result (Cache controller -> CPU)
	typedef struct {
		cache_data_type data;
		bit ready;				//result is ready when the request read/write is a hit
		bit stopped;
	} cache_to_cpu_type;
	
	//----------------------------------------------------------------
	//------	data structures for Cache controller <-> memory	---------
	
	//Memory request (Cache controller -> Memory)
	typedef struct {
		bit [19:0] addr;		//request address
		cache_data_type data;		//16-bit request data (used when write)
		bit rw; 					// 0=read / 1=write
		bit valid;
	} cache_to_mem_type;
	
	//Memory controller response (memory -> Cache controller)
	typedef struct {
		cache_data_type data;	//128-bit read back data
		bit ready;					//Memory read/write is complete
	} mem_to_cache_type;
	
endpackage