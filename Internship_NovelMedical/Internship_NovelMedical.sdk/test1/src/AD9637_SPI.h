/*
 * AD9637_SPI.h
 *
 *  Created on: 2020��8��30��
 *      Author: Alain
 */

#ifndef SRC_AD9637_SPI_H_
#define SRC_AD9637_SPI_H_

#include "sleep.h"
#include "AD_9637_SPI.h"
#include "xparameters.h"

#define	SPI_BASEADDR		XPAR_AD_9637_SPI_0_AD_9637_SPI_BASEADDR
#define	BEGINTOGO_OFFSET	AD_9637_SPI_AD_9637_SPI_SLV_REG0_OFFSET
#define	DONE_OFFSET			AD_9637_SPI_AD_9637_SPI_SLV_REG1_OFFSET
#define	CTRLREG_OFFSET		AD_9637_SPI_AD_9637_SPI_SLV_REG2_OFFSET
#define	DATAREG_OFFSET		AD_9637_SPI_AD_9637_SPI_SLV_REG3_OFFSET


#define	BEGINTOGO_BASEADDR	SPI_BASEADDR	+	BEGINTOGO_OFFSET//
#define	DONE_BASEADDR		SPI_BASEADDR	+	DONE_OFFSET
#define	CTRLREG_BASEADDR	SPI_BASEADDR	+	CTRLREG_OFFSET//
#define	DATAREG_BASEADDR	SPI_BASEADDR	+	DATAREG_OFFSET

#define	Set_begin_go		(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)|(1<<0)))
#define	Set_ad_pd			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)|(1<<1)))
#define	Set_ad_sync			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)|(1<<2)))
#define	Set_ADC0			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)|(1<<3)))
#define	Set_ADC1			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)|(1<<4)))

#define	Clr_begin_go		(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)&(~(1<<0))))
#define	Clr_ad_pd			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)&(~(1<<1))))
#define	Clr_ad_sync			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)&(~(1<<2))))
#define	Clr_ADC0			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)&(~(1<<3))))
#define	Clr_ADC1			(Xil_Out32(BEGINTOGO_BASEADDR, Xil_In32(BEGINTOGO_BASEADDR)&(~(1<<4))))



#define	DELAY_WAIT_READY		1200		// at least two cycle of SCLK, for sure
#define	DELAY_SPI_OPERATION		1000   	// must more than Tclk*NbCycle = 0.4*30 ns


void begin_to_go_ready();
void begin_to_go();
int get_begin_to_go();

void set_ad_pd();
void clr_ad_pd();
int get_ad_pd();

void set_ad_sync();
void clr_ad_sync();
int get_ad_sync();

void active_Adc0();
void desactive_Adc0();
int get_Adc0_state();

void active_Adc1();
void desactive_Adc1();
int get_Adc1_state();

void write_command(u32 commend);
u32	read_data_from_datareg();
u32	read_cmd_from_ctrlreg();
void init_regs();
u8 re_uc(u8 a);
void tobin(u8 data_in, char *str);
int read_done();
u8 Read_reg(u32 addr, u8 *data_out);
void Write_reg(u32 addr, u8 data_in);

void Read_All_Regs();

#endif /* SRC_AD9637_SPI_H_ */
