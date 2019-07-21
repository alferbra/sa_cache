// Cache memory

import cache_definition::cache_index_type;
import cache_definition::cache_data_type;

module sa_cache_mem (
    input bit clk,
    input cache_index_type cache_index, //index and write enable
    input cache_data_type data_write,    //write port
    output cache_data_type data_read     //read port
    );

    cache_data_type mem [0:1024]; //1024 entries

    assign data_read = mem [cache_index.index];

    always_ff @(posedge clk) begin
        if (cache_index.we)
            mem [cache_index.index] <= data_write;
    end

endmodule
