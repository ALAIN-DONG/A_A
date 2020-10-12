vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_vip_v1_1_5
vlib modelsim_lib/msim/processing_system7_vip_v1_0_7
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_19
vlib modelsim_lib/msim/fifo_generator_v13_2_4
vlib modelsim_lib/msim/axi_data_fifo_v2_1_18
vlib modelsim_lib/msim/axi_crossbar_v2_1_20
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/util_vector_logic_v2_0_1
vlib modelsim_lib/msim/axis_infrastructure_v1_1_0
vlib modelsim_lib/msim/axis_data_fifo_v2_0_1
vlib modelsim_lib/msim/lib_pkg_v1_0_2
vlib modelsim_lib/msim/lib_fifo_v1_0_13
vlib modelsim_lib/msim/lib_srl_fifo_v1_0_2
vlib modelsim_lib/msim/axi_datamover_v5_1_21
vlib modelsim_lib/msim/axi_sg_v4_1_12
vlib modelsim_lib/msim/axi_dma_v7_1_20
vlib modelsim_lib/msim/axi_protocol_converter_v2_1_19
vlib modelsim_lib/msim/axi_clock_converter_v2_1_18
vlib modelsim_lib/msim/blk_mem_gen_v8_4_3
vlib modelsim_lib/msim/axi_dwidth_converter_v2_1_19

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_5 modelsim_lib/msim/axi_vip_v1_1_5
vmap processing_system7_vip_v1_0_7 modelsim_lib/msim/processing_system7_vip_v1_0_7
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_19 modelsim_lib/msim/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 modelsim_lib/msim/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 modelsim_lib/msim/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 modelsim_lib/msim/axi_crossbar_v2_1_20
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap util_vector_logic_v2_0_1 modelsim_lib/msim/util_vector_logic_v2_0_1
vmap axis_infrastructure_v1_1_0 modelsim_lib/msim/axis_infrastructure_v1_1_0
vmap axis_data_fifo_v2_0_1 modelsim_lib/msim/axis_data_fifo_v2_0_1
vmap lib_pkg_v1_0_2 modelsim_lib/msim/lib_pkg_v1_0_2
vmap lib_fifo_v1_0_13 modelsim_lib/msim/lib_fifo_v1_0_13
vmap lib_srl_fifo_v1_0_2 modelsim_lib/msim/lib_srl_fifo_v1_0_2
vmap axi_datamover_v5_1_21 modelsim_lib/msim/axi_datamover_v5_1_21
vmap axi_sg_v4_1_12 modelsim_lib/msim/axi_sg_v4_1_12
vmap axi_dma_v7_1_20 modelsim_lib/msim/axi_dma_v7_1_20
vmap axi_protocol_converter_v2_1_19 modelsim_lib/msim/axi_protocol_converter_v2_1_19
vmap axi_clock_converter_v2_1_18 modelsim_lib/msim/axi_clock_converter_v2_1_18
vmap blk_mem_gen_v8_4_3 modelsim_lib/msim/blk_mem_gen_v8_4_3
vmap axi_dwidth_converter_v2_1_19 modelsim_lib/msim/axi_dwidth_converter_v2_1_19

vlog -work xilinx_vip -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_5 -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/d4a8/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_7 -64 -incr -sv -L axi_vip_v1_1_5 -L processing_system7_vip_v1_0_7 -L xilinx_vip "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_processing_system7_0_0/sim/system_processing_system7_0_0.v" \
"../../../bd/system/ipshared/45d6/hdl/AD_9637_SPI_LOGIC.v" \
"../../../bd/system/ipshared/45d6/hdl/AD_9637_SPI_v1_0_AD_9637_SPI.v" \
"../../../bd/system/ipshared/45d6/hdl/AD_9637_SPI_v1_0.v" \
"../../../bd/system/ip/system_AD_9637_SPI_0_0/sim/system_AD_9637_SPI_0_0.v" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_xbar_0/sim/system_xbar_0.v" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/system/ip/system_rst_ps7_0_200M_0/sim/system_rst_ps7_0_200M_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ipshared/064a/hdl/AD_9637_DeSerializer.v" \
"../../../bd/system/ipshared/064a/hdl/AD_9637_IF_v1_0_S00_AXI.v" \
"../../../bd/system/ipshared/064a/hdl/AD_9637_IF_v_1_0_M_AXIS.v" \
"../../../bd/system/ipshared/064a/hdl/Data_processing.v" \
"../../../bd/system/ipshared/064a/hdl/Grar_Box_6b_2_12b.v" \
"../../../bd/system/ipshared/064a/hdl/add_operation.v" \
"../../../bd/system/ipshared/064a/hdl/utile_To_Pulse.v" \
"../../../bd/system/ipshared/064a/hdl/AD_9637_IF_v1_0.v" \
"../../../bd/system/ip/system_AD_9637_IF_0_0/sim/system_AD_9637_IF_0_0.v" \

vlog -work util_vector_logic_v2_0_1 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/2137/hdl/util_vector_logic_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_util_vector_logic_0_0/sim/system_util_vector_logic_0_0.v" \

vlog -work axis_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_data_fifo_v2_0_1 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/e1b1/hdl/axis_data_fifo_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_axis_data_fifo_0_0/sim/system_axis_data_fifo_0_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/system/ip/system_proc_sys_reset_0_0/sim/system_proc_sys_reset_0_0.vhd" \

vcom -work lib_pkg_v1_0_2 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_fifo_v1_0_13 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/4dac/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_datamover_v5_1_21 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/e644/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_12 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/91f3/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_20 -64 -93 \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/260a/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/system/ip/system_axi_dma_0_0/sim/system_axi_dma_0_0.vhd" \
"../../../bd/system/ip/system_rst_ps7_0_5M_0/sim/system_rst_ps7_0_5M_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ipshared/6eba/hdl/Axi_Oled_v1_0_Axi_OLED.v" \
"../../../bd/system/ipshared/6eba/hdl/Axi_Oled_v1_0.v" \
"../../../bd/system/ip/system_Axi_Oled_0_0/sim/system_Axi_Oled_0_0.v" \

vlog -work axi_protocol_converter_v2_1_19 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/c83a/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_auto_pc_0/sim/system_auto_pc_0.v" \

vlog -work axi_clock_converter_v2_1_18 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ac9d/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_auto_cc_0/sim/system_auto_cc_0.v" \
"../../../bd/system/ip/system_auto_pc_1/sim/system_auto_pc_1.v" \

vlog -work blk_mem_gen_v8_4_3 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \

vlog -work axi_dwidth_converter_v2_1_19 -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/e578/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/ec67/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8c62/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ipshared/8713/hdl" "+incdir+../../../../Internship_NovelMedical.srcs/sources_1/bd/system/ip/system_processing_system7_0_0" "+incdir+D:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/system/ip/system_auto_us_0/sim/system_auto_us_0.v" \
"../../../bd/system/sim/system.v" \

vlog -work xil_defaultlib \
"glbl.v"

