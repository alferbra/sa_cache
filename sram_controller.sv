//--------------------------------------------------------------------------------------------

// CONTROLLER FOR 1M x 16 SRAM IS61WV102416ALL IS61WV102416BLL IS64WV102416BLL

//--------------------------------------------------------------------------------------------

import cache_definition::*;

module sram_controller (
    input bit clk,
    input bit rst,
    input cache_to_mem_type cache_to_mem,
    output mem_to_cache_type mem_to_cache,
    output bit CE_N,
    output bit OE_N,
    output bit WE_N,
    output bit LB_N,
    output bit UB_N,
    output bit [19:0] addr,
	inout [15:0] data
	);

    parameter rw_cycles;  //Number of cycles the sram will need (Its frequency is 50 MHz)

    //posible states
    typedef enum { idle, write, read } sram_state_type;

    //state registers
    sram_state_type current_state, next_state;

    //signal to write on RAM
	reg [15:0] data_write;

    integer count = rw_cycles - 1;

    //temporary variable for SRAM memory results (SRAM -> cache)
    mem_to_cache_type next_mem_to_cache;

    //temporary variable to hold the cache request (cache -> sram controller)
    cache_to_mem_type hold_cache_to_mem;

    //connect to output port
    assign mem_to_cache = next_mem_to_cache;
    assign addr = (cache_to_mem.valid) ? cache_to_mem.addr : hold_cache_to_mem.addr;
    assign data_write = (cache_to_mem.rw) ? cache_to_mem.data : hold_cache_to_mem.data;
    assign data = (!WE_N) ? data_write : 'z;

    //--------------------------------------------------------------------------
    //------------------------------- SRAM FSM ---------------------------------
	 always_comb begin    

        next_state = current_state;

        next_mem_to_cache.ready = '0;
        next_mem_to_cache.data = data;
        CE_N = '0;
        OE_N = '0;
        WE_N = '1;
        LB_N = '0;
        UB_N = '0;
        
        // if (cache_to_mem.valid)
        //     addr = cache_to_mem.addr;

        // if (cache_to_mem.rw)
        //     data_write = cache_to_mem.data;

        case (current_state)

            idle: begin

                if (cache_to_mem.valid) begin
                    if (cache_to_mem.rw == '1) begin
                        WE_N = '0;
                    
                        next_state = write;
                    end

                    else if (cache_to_mem.rw == '0) begin
                        WE_N = '1;
                        
                        next_state = read;
                    end
                end
            end

            read: begin
                if (count == 0) begin
                    next_mem_to_cache.ready = '1;

                    next_state = idle;
                end
            end

            write: begin
                WE_N = '0;
                if (count == 0) begin
                    next_mem_to_cache.ready = '1;
                    WE_N = '1;

                    next_state = idle;
                end
            end

        endcase
    end
	 
	always_ff @(posedge clk) begin
		if(!rst) 
			current_state <= idle;
        else
            current_state <= next_state;

        if (current_state == idle)
            count <= rw_cycles - 1;
        else
            count <= count - 1;

        hold_cache_to_mem <= cache_to_mem;
    end

endmodule