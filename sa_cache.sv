import cache_definition::*;

module sa_cache (
    input bit clk,
    input bit rst,
    input bit [31:0] ram_data_r,
    input cpu_to_cache_type cpu_to_cache,
    output cache_to_cpu_type cache_to_cpu,
    output bit WE,
    output bit [3:0] BE,
    output bit [19:0] ram_addr,
    output bit [31:0] ram_data_w
);

    //Cache <-> Memory controller signals
    cache_to_mem_type cache_to_mem;
    mem_to_cache_type mem_to_cache;
    
    ram32_controller ram32_controller_inst(
        .clk (clk),
        .rst (rst),
        .data_r (ram_data_r),
        .cache_to_mem (cache_to_mem),
        .mem_to_cache (mem_to_cache),
        .addr (ram_addr),
        .data_w (ram_data_w),
        .BE (BE),
        .WE (WE)
    );

    sa_cache_controller sa_cache_controller_inst (
        .clk (clk),
        .rst (rst),
        .cpu_to_cache (cpu_to_cache),
        .mem_to_cache (mem_to_cache),
        .cache_to_mem (cache_to_mem),
        .cache_to_cpu (cache_to_cpu)
    );

endmodule