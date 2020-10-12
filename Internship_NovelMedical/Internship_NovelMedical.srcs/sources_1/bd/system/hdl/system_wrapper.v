//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Fri Oct  9 18:38:29 2020
//Host        : DESKTOP-ALAIN running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (AD_PD_out,
    AD_SYNC_out,
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    OLED_0,
    adc0_data_in_n,
    adc0_data_in_p,
    adc0_dco_in_n,
    adc0_dco_in_p,
    adc0_fco_in_n,
    adc0_fco_in_p,
    adc1_data_in_n,
    adc1_data_in_p,
    adc1_dco_in_n,
    adc1_dco_in_p,
    adc1_fco_in_n,
    adc1_fco_in_p,
    clk_to_adc0_n,
    clk_to_adc0_p,
    clk_to_adc1_n,
    clk_to_adc1_p,
    done,
    led_data_show,
    spi_cs0,
    spi_cs1,
    spi_sclk,
    spi_sdio);
  output AD_PD_out;
  output AD_SYNC_out;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [5:0]OLED_0;
  input [7:0]adc0_data_in_n;
  input [7:0]adc0_data_in_p;
  input adc0_dco_in_n;
  input adc0_dco_in_p;
  input adc0_fco_in_n;
  input adc0_fco_in_p;
  input [7:0]adc1_data_in_n;
  input [7:0]adc1_data_in_p;
  input adc1_dco_in_n;
  input adc1_dco_in_p;
  input adc1_fco_in_n;
  input adc1_fco_in_p;
  output clk_to_adc0_n;
  output clk_to_adc0_p;
  output clk_to_adc1_n;
  output clk_to_adc1_p;
  output [0:0]done;
  output [5:0]led_data_show;
  output spi_cs0;
  output spi_cs1;
  output spi_sclk;
  inout spi_sdio;

  wire AD_PD_out;
  wire AD_SYNC_out;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [5:0]OLED_0;
  wire [7:0]adc0_data_in_n;
  wire [7:0]adc0_data_in_p;
  wire adc0_dco_in_n;
  wire adc0_dco_in_p;
  wire adc0_fco_in_n;
  wire adc0_fco_in_p;
  wire [7:0]adc1_data_in_n;
  wire [7:0]adc1_data_in_p;
  wire adc1_dco_in_n;
  wire adc1_dco_in_p;
  wire adc1_fco_in_n;
  wire adc1_fco_in_p;
  wire clk_to_adc0_n;
  wire clk_to_adc0_p;
  wire clk_to_adc1_n;
  wire clk_to_adc1_p;
  wire [0:0]done;
  wire [5:0]led_data_show;
  wire spi_cs0;
  wire spi_cs1;
  wire spi_sclk;
  wire spi_sdio;

  system system_i
       (.AD_PD_out(AD_PD_out),
        .AD_SYNC_out(AD_SYNC_out),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .OLED_0(OLED_0),
        .adc0_data_in_n(adc0_data_in_n),
        .adc0_data_in_p(adc0_data_in_p),
        .adc0_dco_in_n(adc0_dco_in_n),
        .adc0_dco_in_p(adc0_dco_in_p),
        .adc0_fco_in_n(adc0_fco_in_n),
        .adc0_fco_in_p(adc0_fco_in_p),
        .adc1_data_in_n(adc1_data_in_n),
        .adc1_data_in_p(adc1_data_in_p),
        .adc1_dco_in_n(adc1_dco_in_n),
        .adc1_dco_in_p(adc1_dco_in_p),
        .adc1_fco_in_n(adc1_fco_in_n),
        .adc1_fco_in_p(adc1_fco_in_p),
        .clk_to_adc0_n(clk_to_adc0_n),
        .clk_to_adc0_p(clk_to_adc0_p),
        .clk_to_adc1_n(clk_to_adc1_n),
        .clk_to_adc1_p(clk_to_adc1_p),
        .done(done),
        .led_data_show(led_data_show),
        .spi_cs0(spi_cs0),
        .spi_cs1(spi_cs1),
        .spi_sclk(spi_sclk),
        .spi_sdio(spi_sdio));
endmodule
