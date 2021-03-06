/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"
#include "xparameters.h"
#include "AD9637_SPI.h"
#include "AD9637_IF.h"
#include "project_utils.h"
#include "dma_intr.h"
#include "sys_intr.h"
#include "timer_intr.h"
#include "operations.h"

#include "netif/xadapter.h"
#include "platform_config.h"
#include "lwipopts.h"
#include "lwip/priv/tcp_priv.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "oled.h"


#if LWIP_IPV6==1
#include "lwip/ip6_addr.h"
#include "lwip/ip6.h"
#else

#if LWIP_DHCP==1
#include "lwip/dhcp.h"
extern volatile int dhcp_timoutcntr;
#endif
#define DEFAULT_IP_ADDRESS	"192.168.1.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.1.1"
#endif /* LWIP_IPV6 */

#define TIMER_LOAD_VALUE    XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / (8*MULT_SPEED)//XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ / 8 //0.25S
#define PAKET_LENGTH (10)
#define SEND_SIZE (10)


//************* TCP ***************
void TCP_print_app_header(void);
void TCP_start_application(void);
extern char TCPrecvBuffer;
extern char TCPsendBuffer;
char TCP_User_Recv_Buf[2000];
char TCP_User_Send_Buf[2000];
void TCP_print_received_data(void);
void TCP_Send_data(const char a[]);


//************** UDP ****************
void UDP_print_app_header(void);
void UDP_start_application(void);
extern char UDPrecvBuffer;
extern char UDPsendBuffer;
char UDP_User_Recv_Buf[2000];
char UPD_User_Send_Buf[2000];
void UDP_Send_data(const char a[]);
void UDP_print_received_data(void);



//************* 共有 ***************
extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;

extern volatile int Auto_run_Flag;
extern volatile int Oled_Show_Flag;
extern volatile int auto_transmission_on;
extern volatile int auto_transmission_Flag;

extern volatile int auto_Sampling_on;
extern volatile int Sampling_Flag;

extern volatile int auto_run_on;

u32 	*RxBufferPtr[2];  /* ping pong buffers*/

volatile u32 RX_success;
volatile u32 TX_success;

volatile u32 RX_ready=1;
volatile u32 TX_ready=1;

u8 tcp_udp_server_flag;
//TCP Server 测试全局状态标记变量
//bit7,		0,TCP没有数据要发送;					1,有数据要发送
//bit6,		0,TCP没有收到数据;					1,收到数据了.
//bit5,		0,TCP没有客户端连接上;				1,有客户端连接上了.
//bit4,		0,UDP没有数据要发送;					1,有数据要发送
//bit3,		0,UDP没有收到数据;					1,收到数据了.
//bit2,		0,UDP没有客户端连接上;				1,有客户端连接上了.
//bit1:
//bit0:

struct netif server_netif;
struct netif *netif;

static  XScuGic Intc; //GIC
static  XScuTimer Timer;//timer
XAxiDma AxiDma;
unsigned first_trans_start;
volatile u32 packet_index;
void platform_enable_interrupts(void);


#if LWIP_IPV6==1
static void print_ipv6(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf(" %s\n\r", inet6_ntoa(*ip));
}
#else
static void print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\r\n", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}
#endif /* LWIP_IPV6 */


static void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP:       ", ip);
	print_ip("Netmask :       ", mask);
	print_ip("Gateway :       ", gw);
}

static void assign_default_ip(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	int err;

	xil_printf("Configuring default IP %s \r\n", DEFAULT_IP_ADDRESS);

	err = inet_aton(DEFAULT_IP_ADDRESS, ip);
	if (!err)
		xil_printf("Invalid default IP address: %d\r\n", err);

	err = inet_aton(DEFAULT_IP_MASK, mask);
	if (!err)
		xil_printf("Invalid default IP MASK: %d\r\n", err);

	err = inet_aton(DEFAULT_GW_ADDRESS, gw);
	if (!err)
		xil_printf("Invalid default gateway address: %d\r\n", err);
}


// get calculated results from dma
// 从dma中获取经计算的值
int Get_Result(u32 *result){
	int count = 0;
	int Status;
	*result = 0;
	while(count < 1){
		if(!first_trans_start){
			Status = XAxiDma_SimpleTransfer(&AxiDma, (u32)RxBufferPtr[0],
					(u32)(PAKET_LENGTH), XAXIDMA_DEVICE_TO_DMA);
			if (Status != XST_SUCCESS)
			{
//				xil_printf("axi dma failed! 0 %d\r\n", Status);
				return 0;
			}
			/*set the flag, so this part of code will not excuse again*/
			first_trans_start = 1;
		}

		if(packet_trans_done){
			Xil_DCacheInvalidateRange((u32)RxBufferPtr[packet_index & 1], SEND_SIZE);

			//-------------
//			xil_printf("!!!! data is%x\r\n",*RxBufferPtr[packet_index & 1]);
			*result = *RxBufferPtr[packet_index & 1];
			//-------------


			packet_index++;
			/*clear the axidma done flag*/
			packet_trans_done = 0;
		}

		Status = XAxiDma_SimpleTransfer(&AxiDma, (u32)RxBufferPtr[(packet_index + 1)&1],
					(u32)(PAKET_LENGTH), XAXIDMA_DEVICE_TO_DMA);
		if (Status != XST_SUCCESS)
		{
//			xil_printf("axi dma %d failed! %d \r\n", (packet_index + 1), Status);
			return 0;
		}
		count ++;
	}
	return 1;
}


//只传输一次，将最后一次从数据处理单元传入dma的数据由UDP网络传送
//transfer for just one time via UDP that the latest data from data processing unit to dma
void affiche_dma(){
	int try_cnt = 0;
	int channel_cnt = 0;
	u32	temp_val;
	u32 result[16] = {0};
	int state = 0;
	state = Get_Result(&temp_val);
	while ((state == 1)&&(try_cnt<32)){//while ((channel_cnt<16)&&(try_cnt<32)){

//		xil_printf("state is %d, value is %08x\r\n", state, temp_val);
		if(state == 1){
			switch ((temp_val>>28)&(0xF)){
						case	0x0: result[0]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x1: result[1]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x2: result[2]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x3: result[3]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x4: result[4]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x5: result[5]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x6: result[6]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x7: result[7]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x8: result[8]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0x9: result[9]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xA: result[10]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xB: result[11]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xC: result[12]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xD: result[13]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xE: result[14]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						case	0xF: result[15]	=	temp_val&0x0FFFFFFF; channel_cnt++; break;
						}
		}else{
			try_cnt ++;
		}
		usleep(1000);
		state = Get_Result(&temp_val);
	}

//	xil_printf("cnt times value read :[%d] \r\n",channel_cnt);
	memset(UPD_User_Send_Buf, '\0', sizeof(UPD_User_Send_Buf));
	sprintf(UPD_User_Send_Buf, "[%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx][%08lx]\r ",\
				result[0], result[1], result[2], result[3],\
				 result[4], result[5], result[6], result[7],\
				 result[8], result[9], result[10], result[11],\
				 result[12], result[13], result[14], result[15]);
	UDP_Send_data(UPD_User_Send_Buf);
}


//自动测试整个数据链，测试长度与测试间隔由输入参数给出
//auto test the whole data chain, tested length and interval is given by input character
void auto_test_trans(u32 ctrl){
	u32 value_test = 0;

	u16 totle_times = ctrl&0xFFFF;
	u16 interval = (ctrl>>16) & 0xFFFF;
	while (value_test < totle_times){
		change_adc_test_value(value_test, 0);
		change_adc_test_value(value_test, 1);
		option_trans_result_to_dma();
		affiche_dma();

		value_test++;
		usleep(interval);
	}
}

//自动由UDP传输dma中所有的数据，每次传输只传输一条通路
//auto transfer all available data in DMA by UDP, every time just one channel will be transfered
void auto_transmission(){
	u32	temp_val;
	u32 result = 0;
	int channel = -1;
	int state = 0;
	state = Get_Result(&temp_val);
	if(state == 1){
		switch ((temp_val>>28)&(0xF)){
			case	0x0: result	=	temp_val&0x0FFFFFFF; channel = 0; break;
			case	0x1: result	=	temp_val&0x0FFFFFFF; channel = 1; break;
			case	0x2: result	=	temp_val&0x0FFFFFFF; channel = 2; break;
			case	0x3: result	=	temp_val&0x0FFFFFFF; channel = 3; break;
			case	0x4: result	=	temp_val&0x0FFFFFFF; channel = 4; break;
			case	0x5: result	=	temp_val&0x0FFFFFFF; channel = 5; break;
			case	0x6: result	=	temp_val&0x0FFFFFFF; channel = 6; break;
			case	0x7: result	=	temp_val&0x0FFFFFFF; channel = 7; break;
			case	0x8: result	=	temp_val&0x0FFFFFFF; channel = 8; break;
			case	0x9: result	=	temp_val&0x0FFFFFFF; channel = 9; break;
			case	0xA: result	=	temp_val&0x0FFFFFFF; channel = 10; break;
			case	0xB: result	=	temp_val&0x0FFFFFFF; channel = 11; break;
			case	0xC: result	=	temp_val&0x0FFFFFFF; channel = 12; break;
			case	0xD: result	=	temp_val&0x0FFFFFFF; channel = 13; break;
			case	0xE: result	=	temp_val&0x0FFFFFFF; channel = 14; break;
			case	0xF: result	=	temp_val&0x0FFFFFFF; channel = 15; break;
		}
		sprintf(UPD_User_Send_Buf,"%d: [%08lx]", channel, result);//(unsigned int)
		UDP_Send_data(UPD_User_Send_Buf);
	}
}


//init system interrupt configuration
void init_intr_sys(void)
{
	DMA_Intr_Init(&AxiDma,0);//initial interrupt system
	Timer_init(&Timer,TIMER_LOAD_VALUE,0);
	Init_Intr_System(&Intc); // initial DMA interrupt system
	Setup_Intr_Exception(&Intc);
	DMA_Setup_Intr_System(&Intc,&AxiDma,0,RX_INTR_ID);//setup dma interrpt system
	Timer_Setup_Intr_System(&Intc,&Timer,TIMER_IRPT_INTR);
	DMA_Intr_Enable(&Intc,&AxiDma);
}

//init system network(TCP and UDP) configuration
void init_network_lwip(void){
	//-------------------------------A
	unsigned char mac_ethernet_address[] = {
			0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

		netif = &server_netif;
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(netif, NULL, NULL, NULL, mac_ethernet_address,
				PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return;
	}

#if LWIP_IPV6==1
	netif->ip6_autoconfig_enabled = 1;
	netif_create_ip6_linklocal_address(netif, 1);
	netif_ip6_addr_set_state(netif, 0, IP6_ADDR_VALID);
	print_ipv6("\n\rlink local IPv6 address is:", &netif->ip6_addr[0]);
#endif /* LWIP_IPV6 */

	netif_set_default(netif);

	/* now enable interrupts */
	Timer_start(&Timer);

	/* specify that the network if is up */
	netif_set_up(netif);

	#if (LWIP_IPV6==0)
	#if (LWIP_DHCP==1)
		/* Create a new DHCP client for this interface.
		 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
		 * the predefined regular intervals after starting the client.
		 */
		dhcp_start(netif);
		dhcp_timoutcntr = 24;
		while (((netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
			xemacif_input(netif);

		if (dhcp_timoutcntr <= 0) {
			if ((netif->ip_addr.addr) == 0) {
				xil_printf("ERROR: DHCP request timed out\r\n");
				assign_default_ip(&(netif->ip_addr),
						&(netif->netmask), &(netif->gw));
			}
		}

		/* print IP address, netmask and gateway */
	#else
		assign_default_ip(&(netif->ip_addr), &(netif->netmask), &(netif->gw));
	#endif
		print_ip_settings(&(netif->ip_addr), &(netif->netmask), &(netif->gw));
	#endif /* LWIP_IPV6 */

	/* start the application*/
	TCP_start_application();xil_printf("TCP start\r\n");
	UDP_start_application();xil_printf("UDP start\r\n");

	xil_printf("\r\n");
	//-----------------------------------V
}


int main()
{
//declaration of the MAIN variables
    int Num_Order;
    u32	Order_Addr;
    u32 Order_Data;
    u32 Operation;
    int Order_channel;
    char feedback_udp[200];

    u8 OLED_show_etat;
    //bit7:		0,TCP没有数据要发送;		1,有数据要发送
    //bit6:		0,TCP没有收到数据;		1,收到数据了.
    //bit5:		0,TCP没有客户端连接上;	1,有客户端连接上了.
    //bit4:		0,UDP没有数据要发送;		1,有数据要发送
    //bit3:		0,UDP没有收到数据;		1,收到数据了.
    //bit2:		0,UDP没有客户端连接上;	1,有客户端连接上了.
    //bit1:		0,UDP转发关闭			1,UDP自动转发DMA中所有数据
    //bit0:		0,数据自动采集关闭		1,经计算单元处理后的数据自动地存入DMA中
    char oled_head_string[16];
	char olde_stat_string[16];

	auto_run_on = 0;
	auto_transmission_on = 0;

    packet_index = 0;
    RxBufferPtr[0] = (u32 *)RX_BUFFER0_BASE;
	RxBufferPtr[1] = (u32 *)RX_BUFFER1_BASE;
	first_trans_start = 0;
	packet_trans_done = 0;


    init_platform(); 		//初始化整个平台 //initial the whole platform
    lwip_init(); 			//初始化lwip //init system lwip
    OLED_Init();  			//初始化oled显示屏 // init oled screen driver

	init_spi();		//初始化spi驱动//init spi driver

	init_idelay();		//初始化所有idelay模块//initial all idelay module

	auto_init_serdes();		//初始化所有色弱的是模块，并自动校准，进行位对齐 //initial all serdes modules, auto calibrate to realize bit alignment

	final_check();			//最终检查每路信号是否正确，并生成报告	//final check for every channel and generate a report

	init_intr_sys();		//初始化系统中断	//init system interrupt configuration

	init_network_lwip();	//初始化并配置UDP与TCP //init system network(TCP and UDP) configuration

	default_system_setting(); //对系统功能进行默认配置	//default setting for the system

    // ----fin init----
	memset(oled_head_string, 0, sizeof(oled_head_string));
	memset(olde_stat_string, 0, sizeof(olde_stat_string));

	OLED_Clear();
	sprintf(oled_head_string, "TCP | UDP | T S");
	OLED_ShowString(0,0, oled_head_string);
	OLED_Refresh_Gram();

	tcp_udp_server_flag = 0x00;
    xil_printf("Begining...\r\n");

    while (1) {
		if (TcpFastTmrFlag) {// every 250ms
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) { // every 500ms
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(netif);

		OLED_show_etat = tcp_udp_server_flag; //在每次循环开始，进行刷新oled state 寄存器


		//*********** TCP ****************//负责接收指令，发送反馈
		OLED_show_etat &= ~(1<<1);//清除oled中收到新指令
		if (tcp_udp_server_flag&1<<5) {  //连接成功则如下操作

			if (tcp_udp_server_flag&1<<6){//有新的数据通过TCP收到时，进行如下操作（解析指令，进行操作）

				Num_Order = Read_Order_New(TCP_User_Recv_Buf, &Order_Addr, &Order_Data, &Operation, &Order_channel);
				memset(feedback_udp, '\0', sizeof(feedback_udp));
				Execute_Order_New(Num_Order, Order_Addr,Order_Data,Operation, Order_channel, feedback_udp);
				TCP_Send_data(feedback_udp);
				//-----------------------------------------------------
				OLED_show_etat |= 1<<6; //在oled中标记tcp有新的数据(指令)收到
				tcp_udp_server_flag &= ~(1<<6); //TCP取消标记已收到新信息
				OLED_show_etat |= 1<<1;//在oled中标记已收到新指令
			}
		}

		//**************** UDP ****************//负责发送数据
		if(tcp_udp_server_flag&1<<3){//udp有新的数据收到
			OLED_show_etat |= 1<<3; //指示oled有新的tcp数据收到
			tcp_udp_server_flag &= ~(1<<3); //消除tcp收到新数据flag
		}


		//************* always run ****************
		if(auto_run_on){
			if(Auto_run_Flag){
				option_trans_result_to_dma();
				affiche_dma();
				Auto_run_Flag = 0;
				OLED_show_etat |= 1<<0;
				OLED_show_etat |= 1<<1;
			}
		}else{
			OLED_show_etat &= ~(1<<0);
			OLED_show_etat &= ~(1<<1);
		}

		if(auto_transmission_on&&auto_transmission_Flag){
			auto_transmission();
			auto_transmission_Flag = 0;
		}

		if(auto_Sampling_on&&Sampling_Flag){
			option_trans_result_to_dma();
			Sampling_Flag = 0;
		}

		//OLED 传输与采样显示控制
		if(auto_Sampling_on||auto_run_on){
			OLED_show_etat |= 1<<0;
		}else{
			OLED_show_etat &= ~(1<<0);
		}

		if(auto_transmission_on||auto_run_on){
			OLED_show_etat |= 1<<1;
		}else{
			OLED_show_etat &= ~(1<<1);
		}


		//应该在结尾之前更新oled并显示所有状态，之后清除flag
		if(Oled_Show_Flag){
			//补漏 7，4位
			OLED_show_etat |= (tcp_udp_server_flag & 0x90);

			sprintf(olde_stat_string, "%s%s%s | %s%s%s | %s %s",\
					(OLED_show_etat&(1<<7) ? "A":"_"),
					(OLED_show_etat&(1<<6) ? "V":"_"),
					(OLED_show_etat&(1<<5) ? "&":"X"),
					(OLED_show_etat&(1<<4) ? "A":"_"),
					(OLED_show_etat&(1<<3) ? "V":"_"),
					(OLED_show_etat&(1<<2) ? "&":"X"),
					(OLED_show_etat&(1<<1) ? "*":"_"),
					(OLED_show_etat&(1<<0) ? "*":"_")
					);
			OLED_Refresh_Gram();
			OLED_ShowString(0,16, olde_stat_string);
			OLED_Refresh_Gram();
			Oled_Show_Flag = 0; // 赋值0， 则可以每25ms刷新，否则可以最快速度刷新
		}
		//**************** end of the circle************
		tcp_udp_server_flag &= ~(1<<7); // 在循环结尾清除TCP发送标记
		tcp_udp_server_flag &= ~(1<<4); // 在循环结尾清除UDP发送标记
}

    cleanup_platform();
    return 0;
}

