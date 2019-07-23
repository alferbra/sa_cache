//Controlador para RAM síncrona con escritura tipo byte

module ram32_controller (
    input clk, rst,
    input [31:0] data_r,
    input cache_to_mem_type cache_to_mem,
    output mem_to_cache_type mem_to_cache,
    output bit [19:0] addr,
    output bit [31:0] data_w,
    output bit [3:0] BE,
    output bit WE
    );

    //posible states
    typedef enum { idle, write, read } ram_state_type;

    //state registers
    ram_state_type current_state, next_state;

    //temporary variable for SRAM memory results (SRAM -> cache)
    mem_to_cache_type next_mem_to_cache;

    always_comb begin
        
        next_state = current_state;

        next_mem_to_cache.ready = '0;
        next_mem_to_cache.data = data_r;

        addr = cache_to_mem.addr;
        data_w = cache_to_mem.data;
        BE = '0;
        WE = '0;

        case (current_state) 

            idle: begin

                if (cache_to_mem.valid) begin
                    
                    if (cache_to_mem.rw) begin
                        WE = '1;
                        BE = '1;
                        next_state = write;
                    end

                    else if (!cache_to_mem.rw) begin
                        WE = '0;
                        next_state = read;
                    end
                end
            end

            read: begin
                next_mem_to_cache.ready = '1;
                next_state = idle;
            end

            write: begin
                WE = '1;
                BE = '1;
                next_mem_to_cache.ready = '1;
                next_state = idle;
            end

        endcase
    end

    always_ff @(posedge clk) begin
        if (!rst) 
            current_state <= idle;
        else
            current_state <= next_state;

        mem_to_cache <= next_mem_to_cache;
    end

endmodule
