//--------------------------------------------------------------------------------------------

// Set-associative cache controller 

//--------------------------------------------------------------------------------------------


import cache_definition::*;

module sa_cache_controller (
	input bit clk,
	input bit rst,
	input cpu_to_cache_type cpu_to_cache,
	input mem_to_cache_type mem_to_cache,
	output cache_to_mem_type cache_to_mem,
	output cache_to_cpu_type cache_to_cpu
    );

    //posible states
	typedef enum { compare_tag, allocate, write_back } cache_state_type;

    //state register
	cache_state_type current_state, next_state;

    //signals to cache memory
    cache_data_type data_read1;      //Read port for memory 1  
    cache_data_type data_read2;      //Read port for memory 2
    cache_table_type table_read1;   //Read port for table 1
    cache_table_type table_read2;   //Read port for table 2
    cache_data_type data_write1;     //Write port for memory 1
    cache_data_type data_write2;     //Write port for memory 2
    cache_table_type table_write1;  //Write port for table 1
    cache_table_type table_write2;  //Write port for table 2
    cache_index_type data_index;    //Index and we for data memory
    cache_index_type table_index;   //Index and we for table

    //temporary variable for cache result (cache -> cpu)
	cache_to_cpu_type next_cache_to_cpu;

    //temporary variable for memory request (cache -> memory)
	cache_to_mem_type next_cache_to_mem;

    //variables for register (cpu -> cache)
	cpu_to_cache_type next_cpu_to_cache;

    //connect to output ports
	assign cache_to_mem = next_cache_to_mem;
	assign cache_to_cpu.data = next_cache_to_cpu.data;
    assign cache_to_cpu.ready = next_cache_to_cpu.ready;

    always_comb begin
        
        //-------------------------------------------------------------------------------
		//-------------------	default values for all signals	------------------------
		
        //no state change by default
		next_state = current_state;

        //cache results by default
        next_cache_to_cpu = '{0,0,0};

        //cache index by default
        data_index.we = '0;
        data_index.index = next_cpu_to_cache.addr [9:0];

        //table index by default
        table_index.we = '0;
        table_index.index = next_cpu_to_cache.addr [9:0];

        //Modify word
        data_write1 = data_read1;
        data_write2 = data_read2;
        table_write1 = table_read1;
        table_write2 = table_read2;

        //Read word
        if ((next_cpu_to_cache.addr[19:10]==table_read1.tag) && table_read1.valid)
            next_cache_to_cpu.data = data_read1;
        else
            next_cache_to_cpu.data = data_read2;

        //memory request address
        next_cache_to_mem.addr = next_cpu_to_cache.addr;

        //memory request data
        if (table_read1.LRU)
            next_cache_to_mem.data = data_read1;
        else 
            next_cache_to_mem.data = data_read2;
        
        next_cache_to_mem.rw = '0;
		next_cache_to_mem.valid = '0;

        //-------------------------------------------------------------------------------------
		
		//-------------------------------------------------------------------------------------
		//---------------------------------	Cache FSM	---------------------------------------
		
        case (current_state)

            compare_tag: begin
                if (next_cpu_to_cache.valid) begin

                    //Cache hit
                    if (((next_cpu_to_cache.addr[19:10]==table_read1.tag) && table_read1.valid) || ((next_cpu_to_cache.addr[19:10]==table_read2.tag) && table_read2.valid)) begin
                        
                        if (!next_cpu_to_cache.rw)
                            next_cache_to_cpu.ready = '1;
                        
                        table_index.we = '1;
                        
                        if ((next_cpu_to_cache.addr[19:10]==table_read1.tag) && table_read1.valid) begin
                            table_write1.LRU = '0;
                            table_write2.LRU = '1;
                        end
                        else begin 
                            table_write1.LRU = '1;
                            table_write2.LRU = '0;
                        end 

                        //write hit
                        if (next_cpu_to_cache.rw) begin

                            data_index.we = '1;

                            if ((next_cpu_to_cache.addr[19:10]==table_read1.tag) && table_read1.valid) begin
                                data_write1 = next_cpu_to_cache.data;
                                table_write1.dirty = '1;
                                table_write1.valid = '1;
                            end 
                            else begin
                                data_write2 = next_cpu_to_cache.data;
                                table_write2.dirty = '1;
                                table_write2.valid = '1;
                            end
                        end
                    end

                    //cache miss
                    else if (!(((next_cpu_to_cache.addr[19:10]==table_read1.tag) && table_read1.valid) || ((next_cpu_to_cache.addr[19:10]==table_read2.tag) && table_read2.valid))) begin
                        next_cache_to_cpu.stopped = '1;
                        table_index.we = '1;
                        next_cache_to_mem.valid = '1;	//Generate a request to memory
                        
                        if (table_read1.LRU) begin
                            table_write1.valid = '1;
                            table_write1.tag = next_cpu_to_cache.addr [19:10];
                            table_write1.dirty = next_cpu_to_cache.rw;    //Is dirty if it is a write
                        end
                        else begin
                            table_write2.valid = '1;
                            table_write2.tag = next_cpu_to_cache.addr [19:10];
                            table_write2.dirty = next_cpu_to_cache.rw;    //Is dirty if it is a write
                        end

                        if (((table_read1.valid == '0 || table_read1.dirty == '0) && table_read1.LRU) || ((table_read2.valid == '0 || table_read2.dirty == '0) && table_read2.LRU) || (!table_read1.LRU && !table_read2.LRU))
                            next_state = allocate;
                        else begin
                        //Miss with dirty bit  
                            //Write-back address
                            if (table_read1.LRU)
                                next_cache_to_mem.addr = {table_read1.tag, next_cpu_to_cache.addr [9:0]};
                            else
                                next_cache_to_mem.addr = {table_read2.tag, next_cpu_to_cache.addr [9:0]};
                        
                            next_cache_to_mem.rw = '1;

                            next_state = write_back;
                        end
                    end
                end
            end

            allocate: begin
                next_cache_to_cpu.stopped = '1;
                next_cache_to_mem.valid = '1;

                //Memory is ready
                if (mem_to_cache.ready) begin
                    next_state = compare_tag;
                    table_index.we = '1;
                    data_index.we = '1;

                    if (table_read1.LRU)
                        data_write1 = mem_to_cache.data;
                    else 
                        data_write2 = mem_to_cache.data;
                end
            end

            write_back: begin
                next_cache_to_cpu.stopped = '1;
                // next_cache_to_mem.rw = '1;
				// next_cache_to_mem.valid = '1;

                //Write-back is completed
				if(mem_to_cache.ready) begin
                    next_cache_to_mem.valid = '1;
					next_cache_to_mem.rw = '0;
					
					next_state = allocate;
                end
            end

        endcase
    end

    always_ff @(posedge clk) begin
		if(!rst) 
			current_state <= compare_tag;
		
		else
			current_state <= next_state;

		cache_to_cpu.stopped <= next_cache_to_cpu.stopped;
	end

    always_ff @(posedge clk) begin
		if (next_cache_to_cpu.stopped)
			next_cpu_to_cache <= next_cpu_to_cache;
		else
			next_cpu_to_cache <= cpu_to_cache;
	end


    //Instanciate cache memories
    
    sa_cache_mem sa_cache_mem_inst1 (
        .clk (clk),
        .cache_index (data_index),
        .data_write (data_write1),
        .data_read (data_read1)
    );

    sa_cache_mem sa_cache_mem_inst2 (
        .clk (clk),
        .cache_index (data_index),
        .data_write (data_write2),
        .data_read (data_read2)
    );


    //Instanciate cache tables

    sa_cache_table sa_cache_table_inst1 (
        .clk (clk),
        .table_index (table_index),
        .table_write (table_write1),
        .table_read (table_read1)
    );

    sa_cache_table sa_cache_table_inst2 (
        .clk (clk),
        .table_index (table_index),
        .table_write (table_write2),
        .table_read (table_read2)
    );

endmodule
