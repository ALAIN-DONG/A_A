// (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:AD_9637_SPI:1.0
// IP Revision: 5

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_AD_9637_SPI_0_0 (
  spi_cs0,
  spi_cs1,
  spi_sclk,
  spi_sdio,
  done,
  AD_PD_out,
  AD_SYNC_out,
  ad_9637_spi_awaddr,
  ad_9637_spi_awprot,
  ad_9637_spi_awvalid,
  ad_9637_spi_awready,
  ad_9637_spi_wdata,
  ad_9637_spi_wstrb,
  ad_9637_spi_wvalid,
  ad_9637_spi_wready,
  ad_9637_spi_bresp,
  ad_9637_spi_bvalid,
  ad_9637_spi_bready,
  ad_9637_spi_araddr,
  ad_9637_spi_arprot,
  ad_9637_spi_arvalid,
  ad_9637_spi_arready,
  ad_9637_spi_rdata,
  ad_9637_spi_rresp,
  ad_9637_spi_rvalid,
  ad_9637_spi_rready,
  ad_9637_spi_aclk,
  ad_9637_spi_aresetn
);

output wire spi_cs0;
output wire spi_cs1;
output wire spi_sclk;
inout wire spi_sdio;
output wire done;
output wire AD_PD_out;
output wire AD_SYNC_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI AWADDR" *)
input wire [3 : 0] ad_9637_spi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI AWPROT" *)
input wire [2 : 0] ad_9637_spi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI AWVALID" *)
input wire ad_9637_spi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI AWREADY" *)
output wire ad_9637_spi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI WDATA" *)
input wire [31 : 0] ad_9637_spi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI WSTRB" *)
input wire [3 : 0] ad_9637_spi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI WVALID" *)
input wire ad_9637_spi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI WREADY" *)
output wire ad_9637_spi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI BRESP" *)
output wire [1 : 0] ad_9637_spi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI BVALID" *)
output wire ad_9637_spi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI BREADY" *)
input wire ad_9637_spi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI ARADDR" *)
input wire [3 : 0] ad_9637_spi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI ARPROT" *)
input wire [2 : 0] ad_9637_spi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI ARVALID" *)
input wire ad_9637_spi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI ARREADY" *)
output wire ad_9637_spi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI RDATA" *)
output wire [31 : 0] ad_9637_spi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI RRESP" *)
output wire [1 : 0] ad_9637_spi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI RVALID" *)
output wire ad_9637_spi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AD_9637_SPI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 5000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN system_processing_sys\
tem7_0_0_FCLK_CLK2, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AD_9637_SPI RREADY" *)
input wire ad_9637_spi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AD_9637_SPI_CLK, ASSOCIATED_BUSIF AD_9637_SPI, ASSOCIATED_RESET ad_9637_spi_aresetn, FREQ_HZ 5000000, PHASE 0.000, CLK_DOMAIN system_processing_system7_0_0_FCLK_CLK2, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 AD_9637_SPI_CLK CLK" *)
input wire ad_9637_spi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AD_9637_SPI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 AD_9637_SPI_RST RST" *)
input wire ad_9637_spi_aresetn;

  AD_9637_SPI_v1_0 #(
    .C_AD_9637_SPI_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_AD_9637_SPI_ADDR_WIDTH(4)  // Width of S_AXI address bus
  ) inst (
    .spi_cs0(spi_cs0),
    .spi_cs1(spi_cs1),
    .spi_sclk(spi_sclk),
    .spi_sdio(spi_sdio),
    .done(done),
    .AD_PD_out(AD_PD_out),
    .AD_SYNC_out(AD_SYNC_out),
    .ad_9637_spi_awaddr(ad_9637_spi_awaddr),
    .ad_9637_spi_awprot(ad_9637_spi_awprot),
    .ad_9637_spi_awvalid(ad_9637_spi_awvalid),
    .ad_9637_spi_awready(ad_9637_spi_awready),
    .ad_9637_spi_wdata(ad_9637_spi_wdata),
    .ad_9637_spi_wstrb(ad_9637_spi_wstrb),
    .ad_9637_spi_wvalid(ad_9637_spi_wvalid),
    .ad_9637_spi_wready(ad_9637_spi_wready),
    .ad_9637_spi_bresp(ad_9637_spi_bresp),
    .ad_9637_spi_bvalid(ad_9637_spi_bvalid),
    .ad_9637_spi_bready(ad_9637_spi_bready),
    .ad_9637_spi_araddr(ad_9637_spi_araddr),
    .ad_9637_spi_arprot(ad_9637_spi_arprot),
    .ad_9637_spi_arvalid(ad_9637_spi_arvalid),
    .ad_9637_spi_arready(ad_9637_spi_arready),
    .ad_9637_spi_rdata(ad_9637_spi_rdata),
    .ad_9637_spi_rresp(ad_9637_spi_rresp),
    .ad_9637_spi_rvalid(ad_9637_spi_rvalid),
    .ad_9637_spi_rready(ad_9637_spi_rready),
    .ad_9637_spi_aclk(ad_9637_spi_aclk),
    .ad_9637_spi_aresetn(ad_9637_spi_aresetn)
  );
endmodule
