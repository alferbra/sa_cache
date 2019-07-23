//Cache "look up table"

import cache_definition::cache_table_type;
import cache_definition::cache_index_type;

module sa_cache_table (
	input bit clk,
	input cache_index_type table_index,		//entrie request information: index and we
	input cache_table_type table_write,		//write port
	output cache_table_type table_read);	//read port
	
	cache_table_type mem [0:1024];	//1024 entries (tag+valid+dirty)

	assign table_read = mem [table_index.index];
	
	always_ff @(posedge clk) begin
		if (table_index.we)
			mem [table_index.index] <= table_write;		
	end
			
endmodule