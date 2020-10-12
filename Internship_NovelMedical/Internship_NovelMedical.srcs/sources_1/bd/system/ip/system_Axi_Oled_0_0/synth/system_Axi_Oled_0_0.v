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


// IP VLNV: xilinx.com:user:Axi_Oled:1.0
// IP Revision: 2

(* X_CORE_INFO = "Axi_Oled_v1_0,Vivado 2019.1" *)
(* CHECK_LICENSE_TYPE = "system_Axi_Oled_0_0,Axi_Oled_v1_0,{}" *)
(* CORE_GENERATION_INFO = "system_Axi_Oled_0_0,Axi_Oled_v1_0,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=Axi_Oled,x_ipVersion=1.0,x_ipCoreRevision=2,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_Axi_OLED_DATA_WIDTH=32,C_Axi_OLED_ADDR_WIDTH=4}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_Axi_Oled_0_0 (
  OLED,
  axi_oled_awaddr,
  axi_oled_awprot,
  axi_oled_awvalid,
  axi_oled_awready,
  axi_oled_wdata,
  axi_oled_wstrb,
  axi_oled_wvalid,
  axi_oled_wready,
  axi_oled_bresp,
  axi_oled_bvalid,
  axi_oled_bready,
  axi_oled_araddr,
  axi_oled_arprot,
  axi_oled_arvalid,
  axi_oled_arready,
  axi_oled_rdata,
  axi_oled_rresp,
  axi_oled_rvalid,
  axi_oled_rready,
  axi_oled_aclk,
  axi_oled_aresetn
);

output wire [5 : 0] OLED;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED AWADDR" *)
input wire [3 : 0] axi_oled_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED AWPROT" *)
input wire [2 : 0] axi_oled_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED AWVALID" *)
input wire axi_oled_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED AWREADY" *)
output wire axi_oled_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED WDATA" *)
input wire [31 : 0] axi_oled_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED WSTRB" *)
input wire [3 : 0] axi_oled_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED WVALID" *)
input wire axi_oled_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED WREADY" *)
output wire axi_oled_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED BRESP" *)
output wire [1 : 0] axi_oled_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED BVALID" *)
output wire axi_oled_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED BREADY" *)
input wire axi_oled_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED ARADDR" *)
input wire [3 : 0] axi_oled_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED ARPROT" *)
input wire [2 : 0] axi_oled_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED ARVALID" *)
input wire axi_oled_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED ARREADY" *)
output wire axi_oled_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED RDATA" *)
output wire [31 : 0] axi_oled_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED RRESP" *)
output wire [1 : 0] axi_oled_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED RVALID" *)
output wire axi_oled_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME Axi_OLED, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 200000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN system_processing_syst\
em7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 Axi_OLED RREADY" *)
input wire axi_oled_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME Axi_OLED_CLK, ASSOCIATED_BUSIF Axi_OLED, ASSOCIATED_RESET axi_oled_aresetn, FREQ_HZ 200000000, PHASE 0.000, CLK_DOMAIN system_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 Axi_OLED_CLK CLK" *)
input wire axi_oled_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME Axi_OLED_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 Axi_OLED_RST RST" *)
input wire axi_oled_aresetn;

  Axi_Oled_v1_0 #(
    .C_Axi_OLED_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_Axi_OLED_ADDR_WIDTH(4)  // Width of S_AXI address bus
  ) inst (
    .OLED(OLED),
    .axi_oled_awaddr(axi_oled_awaddr),
    .axi_oled_awprot(axi_oled_awprot),
    .axi_oled_awvalid(axi_oled_awvalid),
    .axi_oled_awready(axi_oled_awready),
    .axi_oled_wdata(axi_oled_wdata),
    .axi_oled_wstrb(axi_oled_wstrb),
    .axi_oled_wvalid(axi_oled_wvalid),
    .axi_oled_wready(axi_oled_wready),
    .axi_oled_bresp(axi_oled_bresp),
    .axi_oled_bvalid(axi_oled_bvalid),
    .axi_oled_bready(axi_oled_bready),
    .axi_oled_araddr(axi_oled_araddr),
    .axi_oled_arprot(axi_oled_arprot),
    .axi_oled_arvalid(axi_oled_arvalid),
    .axi_oled_arready(axi_oled_arready),
    .axi_oled_rdata(axi_oled_rdata),
    .axi_oled_rresp(axi_oled_rresp),
    .axi_oled_rvalid(axi_oled_rvalid),
    .axi_oled_rready(axi_oled_rready),
    .axi_oled_aclk(axi_oled_aclk),
    .axi_oled_aresetn(axi_oled_aresetn)
  );
endmodule
