vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/simulation/corner_cases_TB.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/cache_definition.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/ram32.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/ram32_controller.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_controller.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_mem.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache_table.sv
vlog -reportprogress 300 -work work E:/Documents/UNIVERSIDAD/TFG/Cache_Controller/sa_cache/sa_cache.sv
vsim -voptargs=+acc=npr work.corner_cases_TB
add wave -position end  sim:/corner_cases_TB/rst
add wave -position end  sim:/corner_cases_TB/clk
add wave -position end  sim:/corner_cases_TB/cache_to_cpu
add wave -position end  sim:/corner_cases_TB/cpu_to_cache
add wave -position end  sim:/corner_cases_TB/WE
add wave -position end  sim:/corner_cases_TB/BE
add wave -position end  sim:/corner_cases_TB/ram_addr
add wave -position end  sim:/corner_cases_TB/ram_data_r
add wave -position end  sim:/corner_cases_TB/ram_data_w
#add wave -position end sim:/corner_cases_TB/top_memory_hierarchy_inst/sa_cache_controller_inst/*
