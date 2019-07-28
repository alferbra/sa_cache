vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/simulation/benchmark_TB.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/cache_definition.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/ram32.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/ram32_controller.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_controller.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_mem.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_table.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/ROM_asynch.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/RAM_asynch.sv
vsim -voptargs=+acc=npr work.benchmark_TB
add wave -position end  sim:/benchmark_TB/rst
add wave -position end  sim:/benchmark_TB/clk
add wave -position end  sim:/benchmark_TB/cache_to_cpu
add wave -position end  sim:/benchmark_TB/cpu_to_cache
add wave -position end  sim:/benchmark_TB/WE
add wave -position end  sim:/benchmark_TB/BE
add wave -position end  sim:/benchmark_TB/ram_addr
add wave -position end  sim:/benchmark_TB/ram_data_r
add wave -position end  sim:/benchmark_TB/ram_data_w
add wave -position end  sim:/benchmark_TB/ROM_addr
add wave -position end  sim:/benchmark_TB/ROM_data
add wave -position end  sim:/benchmark_TB/check_data_r
add wave -position end  sim:/benchmark_TB/queue_data
