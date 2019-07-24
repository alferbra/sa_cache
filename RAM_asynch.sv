// RAM asíncrona de 1M x 32 y escritura tipo byte

module RAM_asynch (
    input WE,
    input [19:0] addr,
    input [31:0] din,
    input [3:0] BE,     //Byte enable
    output bit [31:0] dout
    );

    //Memory
    reg [3:0][7:0] mem [0:2**20-1];

    always @(*) begin
    
        if (WE) begin
            if (BE[0]) mem[addr][0] = din [7:0];
            if (BE[1]) mem[addr][1] = din [15:8];
            if (BE[2]) mem[addr][2] = din [23:16];
            if (BE[3]) mem[addr][3] = din [31:24];
        end
        
        else dout = mem [addr];

    end

endmodule


