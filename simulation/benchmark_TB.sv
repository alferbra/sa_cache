// Test Bench para medir el rendiiento mediante un benchmark realizado a
// partir de los acceosos a memoria de un programa Buble Sort

`timescale 1ns/1ps

`include "../cache_definition.sv"
import cache_definition::*;

module benchmark_TB();

    parameter total_access = 559;

    integer read_cycles = 0;
    integer write_cycles = 0;
    integer reads = 0;
    integer writes = 0;
    integer miss_read = 0;
    integer miss_write = 0;

	bit rst, clk;

    cache_to_cpu_type cache_to_cpu;
	cpu_to_cache_type cpu_to_cache, next_cpu_to_cache;

    bit WE;
    bit [3:0] BE;
    bit [19:0] ram_addr;
    bit [31:0] ram_data_r;
    bit [31:0] ram_data_w;

    bit [9:0] ROM_addr;
    bit [64:0] ROM_data;

    bit [31:0] check_data_r;    //Read port of the asynchronous RAM
    bit [31:0] queue_data;      //Data push out of the queue

    logic [31:0] queue [$];

    assign cpu_to_cache.data = ROM_data[31:0];
    assign cpu_to_cache.addr = ROM_data[51:32];
    assign cpu_to_cache.rw = ROM_data[64];

    initial begin	
	    clk=1'b0;
		forever #5 clk = ~clk;
	end

    initial begin 
        rst = '0;
        ROM_addr = '0;
        #35
        rst = '1;
        cpu_to_cache.valid = '1;

        while (1) begin
            @(posedge clk)
                if (!cache_to_cpu.stopped) begin
                    ROM_addr = ROM_addr + 1'b1;

                    if(ROM_data[64] == 1'b0)
                        reads = reads + 1;
                    else
                        writes = writes + 1;

                    if (ROM_addr == total_access) begin
                        $display("Total accesos: %d", total_access);
                        $display("Total lecturas: %d | Total escrituras: %d", reads, writes);
                        $display("Misses lectura: %d | Misses escritura: %d", miss_read, miss_write);
                        $display("Ciclos espera lectura: %d | Ciclos espera escritura: %d", read_cycles, write_cycles);
                    end
                end
        end
    end

    initial begin
        while (1) @(posedge clk) begin

            if(cache_to_cpu.stopped) begin
                if(!next_cpu_to_cache.rw)
                    read_cycles = read_cycles + 1;
                else
                    write_cycles = write_cycles + 1;
            end
        end
    end

    initial begin
        while (1) @(posedge cache_to_cpu.stopped) begin  

            if(!next_cpu_to_cache.rw) 
                miss_read = miss_read + 1;
            else
                miss_write = miss_write + 1;
        end
    end

    initial begin

        while (1) @(posedge clk) begin
            
            if (!cpu_to_cache.rw && !cache_to_cpu.stopped) begin    //read request from CPU
                queue.push_front(check_data_r);
            end

            if (cache_to_cpu.ready) begin
               queue_data = queue.pop_back();

                assert (queue_data == cache_to_cpu.data) else
                    $error("Lectura erronea. Dato correcto: %h | Dato leido: %h", queue_data, cache_to_cpu.data);

            end
        end
    end

    initial begin

        while (1) @(posedge clk) begin
            if(cache_to_cpu.stopped)
                next_cpu_to_cache <= next_cpu_to_cache;
            else
                next_cpu_to_cache <= cpu_to_cache;
        end
    end

    sa_cache sa_cache_inst (
        .clk (clk),
        .rst (rst),
        .cpu_to_cache (cpu_to_cache),
        .cache_to_cpu (cache_to_cpu),
        .WE (WE),
        .BE (BE),
        .ram_data_r (ram_data_r),
        .ram_data_w (ram_data_w),
        .ram_addr (ram_addr)
    );

    ram32 ram32_inst (
        .WE (WE),
        .clk (clk),
        .addr (ram_addr),
        .din (ram_data_w),
        .BE (BE),
        .dout (ram_data_r)
    );

    RAM_asynch RAM_asynch_inst (
        .WE (ROM_data[64]),
        .addr (ROM_data[51:32]),
        .din (ROM_data[31:0]),
        .BE (4'b1111),
        .dout (check_data_r)
    );

    ROM_asynch #(.INIT_FILE("../memory_access.txt")) ROM_asynch_inst (
        .address (ROM_addr),
        .dout (ROM_data)
    );

endmodule
