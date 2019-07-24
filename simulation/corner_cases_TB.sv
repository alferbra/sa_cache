`timescale 1ns/1ps

`include "../cache_definition.sv"
import cache_definition::*;

module corner_cases_TB();

	bit rst, clk;

    cache_to_cpu_type cache_to_cpu;
	cpu_to_cache_type cpu_to_cache;

    bit WE;
    bit [3:0] BE;
    bit [19:0] ram_addr;
    bit [31:0] ram_data_r;
    bit [31:0] ram_data_w;

    initial begin	
	    clk=1'b0;
		forever #5 clk = ~clk;
	end

    initial begin 
        rst = '0;
        #35
        rst = '1;
    end

    // initial begin

    //     always_comb begin

    //         if (cache_to_cpu.ready)
    //             $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);
            
    //     end
    // end

    initial begin

        #35
        //------------------------------------------------------------------------
        //--------------------------- Check write --------------------------------
        @(posedge clk)
        cpu_to_cache.addr = 20'b00000000000000000000;
        cpu_to_cache.data = 32'b00000000000000000000000000000000;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000000100;
        cpu_to_cache.data = 32'b00000000000000000000000000000100;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        #40 @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000001000;
        cpu_to_cache.data = 32'b00000000000000000000000000001000;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        #40 @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000001100;
        cpu_to_cache.data = 32'b00000000000000000000000000001100;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        #40 @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000000000;
        cpu_to_cache.rw = '0;
        cpu_to_cache.valid = '1;

        // #40 @ (posedge clk)
        // cpu_to_cache.addr = 20'b00000000000000000000;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;

        #40 @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000000100;
        cpu_to_cache.rw = '0;
        cpu_to_cache.valid = '1;

        @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000001000;
        cpu_to_cache.rw = '0;
        cpu_to_cache.valid = '1;

        @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000001100;
        cpu_to_cache.rw = '0;
        cpu_to_cache.valid = '1;

        @ (posedge clk)
        cpu_to_cache.addr = 20'b10000000000000001100;
        cpu_to_cache.data = 32'b00000000000010000000000000001100;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        @ (posedge clk)
        cpu_to_cache.addr = 20'b11000000000000001100;
        cpu_to_cache.data = 32'b00000000000011000000000000001100;
        cpu_to_cache.rw = '1;
        cpu_to_cache.valid = '1;
        $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        #40 @ (posedge clk)
        cpu_to_cache.addr = 20'b00000000000000001100;
        cpu_to_cache.rw = '0;
        cpu_to_cache.valid = '1;

        // //------------------------------------------------------------------------
        // //---------------------------- Check read --------------------------------
        // @ (posedge cache_to_cpu.ready)
        // cpu_to_cache.addr = 20'b00000000000000000000;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;

        // @ (posedge cache_to_cpu.ready)
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // #8
        // cpu_to_cache.addr = 20'b00000000000000000001;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;
        // @ (posedge cache_to_cpu.ready)
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // //------------------------------------------------------------------------
        // //-------------------- Check write-back and allocate----------------------
        // cpu_to_cache.addr = 20'b10000000000000000000;
        // cpu_to_cache.rw = '1;
        // cpu_to_cache.valid = '1;
        // cpu_to_cache.data = 16'b0000000000000011;
        // $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        // @ (posedge cache_to_cpu.ready)
        // cpu_to_cache.addr = 20'b10000000000000000001;
        // cpu_to_cache.data = 16'b0000000000000100;
        // cpu_to_cache.rw = '1;
        // cpu_to_cache.valid = '1;
        // $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        // @ (posedge cache_to_cpu.ready)
        // cpu_to_cache.addr = 20'b11000000000000000000;
        // cpu_to_cache.data = 16'b0000000000000101;
        // cpu_to_cache.rw = '1;
        // cpu_to_cache.valid = '1;
        // $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        // @ (posedge cache_to_cpu.ready)
        // cpu_to_cache.addr = 20'b11000000000000000001;
        // cpu_to_cache.data = 16'b0000000000000110;
        // cpu_to_cache.rw = '1;
        // cpu_to_cache.valid = '1;
        // $display("Escribiendo %h en la posicion %h", cpu_to_cache.data, cpu_to_cache.addr);

        // @ (posedge cache_to_cpu.ready)
        // cpu_to_cache.addr = 20'b00000000000000000000;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;

        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // cpu_to_cache.addr = 20'b00000000000000000001;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;

        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // cpu_to_cache.addr = 20'b10000000000000000000;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;
        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // cpu_to_cache.addr = 20'b10000000000000000001;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;
        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // cpu_to_cache.addr = 20'b11000000000000000000;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;
        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);

        // cpu_to_cache.addr = 20'b11000000000000000001;
        // cpu_to_cache.rw = '0;
        // cpu_to_cache.valid = '1;
        // @ (posedge cache_to_cpu.ready)
        // #1
        // $display("Leyendo %h de la posicion %h", cache_to_cpu.data, cpu_to_cache.addr);
        
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

endmodule