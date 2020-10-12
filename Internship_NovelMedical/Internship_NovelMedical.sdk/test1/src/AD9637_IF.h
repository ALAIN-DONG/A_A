/*
 * AD9637_IF.h
 *
 *  Created on: 2020��9��2��
 *      Author: Alain
 */

#ifndef SRC_AD9637_IF_H_
#define SRC_AD9637_IF_H_

#include "AD_9637_IF.h"
#include "xparameters.h"

#define	AD9637_IF_BASEADDR			XPAR_AD_9637_IF_0_S00_AXI_BASEADDR

#define	ADC0_CTRL_CH0_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG0_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH1_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG1_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH2_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG2_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH3_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG3_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH4_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG4_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH5_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG5_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH6_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG6_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC0_CTRL_CH7_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG7_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH8_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG8_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH9_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG9_OFFSET  + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH10_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG10_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH11_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG11_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH12_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG12_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH13_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG13_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH14_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG14_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_CTRL_CH15_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG15_OFFSET + AD9637_IF_BASEADDR)

#define	ADC0_Data_CH0_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG16_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH1_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG17_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH2_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG18_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH3_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG19_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH4_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG20_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH5_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG21_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH6_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG22_OFFSET + AD9637_IF_BASEADDR)
#define	ADC0_Data_CH7_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG23_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH8_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG24_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH9_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG25_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH10_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG26_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH11_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG27_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH12_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG28_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH13_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG29_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH14_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG30_OFFSET + AD9637_IF_BASEADDR)
#define	ADC1_Data_CH15_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG31_OFFSET + AD9637_IF_BASEADDR)



#define ADC_ALL_Ctrl_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG32_OFFSET + AD9637_IF_BASEADDR)
#define ADC_ALL_State_BASEADDR		(AD_9637_IF_S00_AXI_SLV_REG33_OFFSET + AD9637_IF_BASEADDR)


#define Idelay_LD				0
#define Idelay_INC				1
#define Idelay_CE				2
#define Idelay_Cntvaluein0		3
#define	Idelay_Cntvaluein1		4
#define Idelay_Cntvaluein2		5
#define	Idelay_Cntvaluein3		6
#define	Idelay_Cntvaluein4		7
#define Iserdes_Bitslip			8


#define Set_Ctrl_Bit_ADC0_CH0(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH0_BASEADDR, Xil_In32(ADC0_CTRL_CH0_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH1(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH1_BASEADDR, Xil_In32(ADC0_CTRL_CH1_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH2(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH2_BASEADDR, Xil_In32(ADC0_CTRL_CH2_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH3(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH3_BASEADDR, Xil_In32(ADC0_CTRL_CH3_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH4(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH4_BASEADDR, Xil_In32(ADC0_CTRL_CH4_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH5(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH5_BASEADDR, Xil_In32(ADC0_CTRL_CH5_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH6(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH6_BASEADDR, Xil_In32(ADC0_CTRL_CH6_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC0_CH7(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH7_BASEADDR, Xil_In32(ADC0_CTRL_CH7_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH8(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH8_BASEADDR, Xil_In32(ADC1_CTRL_CH8_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH9(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH9_BASEADDR, Xil_In32(ADC1_CTRL_CH9_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH10(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH10_BASEADDR, Xil_In32(ADC1_CTRL_CH10_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH11(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH11_BASEADDR, Xil_In32(ADC1_CTRL_CH11_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH12(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH12_BASEADDR, Xil_In32(ADC1_CTRL_CH12_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH13(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH13_BASEADDR, Xil_In32(ADC1_CTRL_CH13_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH14(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH14_BASEADDR, Xil_In32(ADC1_CTRL_CH14_BASEADDR)|(1<<Op_Bit)))
#define Set_Ctrl_Bit_ADC1_CH15(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH15_BASEADDR, Xil_In32(ADC1_CTRL_CH15_BASEADDR)|(1<<Op_Bit)))

#define Clr_Ctrl_Bit_ADC0_CH0(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH0_BASEADDR, Xil_In32(ADC0_CTRL_CH0_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH1(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH1_BASEADDR, Xil_In32(ADC0_CTRL_CH1_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH2(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH2_BASEADDR, Xil_In32(ADC0_CTRL_CH2_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH3(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH3_BASEADDR, Xil_In32(ADC0_CTRL_CH3_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH4(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH4_BASEADDR, Xil_In32(ADC0_CTRL_CH4_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH5(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH5_BASEADDR, Xil_In32(ADC0_CTRL_CH5_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH6(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH6_BASEADDR, Xil_In32(ADC0_CTRL_CH6_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC0_CH7(Op_Bit)		(Xil_Out32(ADC0_CTRL_CH7_BASEADDR, Xil_In32(ADC0_CTRL_CH7_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH8(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH8_BASEADDR, Xil_In32(ADC1_CTRL_CH8_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH9(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH9_BASEADDR, Xil_In32(ADC1_CTRL_CH9_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH10(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH10_BASEADDR, Xil_In32(ADC1_CTRL_CH10_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH11(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH11_BASEADDR, Xil_In32(ADC1_CTRL_CH11_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH12(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH12_BASEADDR, Xil_In32(ADC1_CTRL_CH12_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH13(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH13_BASEADDR, Xil_In32(ADC1_CTRL_CH13_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH14(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH14_BASEADDR, Xil_In32(ADC1_CTRL_CH14_BASEADDR)&(~(1<<Op_Bit))))
#define Clr_Ctrl_Bit_ADC1_CH15(Op_Bit)		(Xil_Out32(ADC1_CTRL_CH15_BASEADDR, Xil_In32(ADC1_CTRL_CH15_BASEADDR)&(~(1<<Op_Bit))))



#define	Set_Serdes_rst						(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<0)))
#define	Set_IdelayCtrl_rst					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<1)))
#define	Set_All_regs_rst					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<2)))
#define	Set_Led_Show_ctrl					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<3)))
#define	Set_trans_dma						(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<4)))
#define	Set_active_cal(ch_num)				(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)|(1<<(ch_num + 16))))


#define	Clr_Serdes_rst						(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<0))))
#define	Clr_IdelayCtrl_rst					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<1))))
#define	Clr_All_regs_rst					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<2))))
#define	Clr_Led_Show_ctrl					(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<3))))
#define	Clr_trans_dma						(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<4))))
#define	Clr_active_cal(ch_num)				(Xil_Out32(ADC_ALL_Ctrl_BASEADDR, Xil_In32(ADC_ALL_Ctrl_BASEADDR)&(~(1<<(ch_num + 16)))))

void Set_CTRL_AD9637_IF(int channel_num, int option);
void Clr_CTRL_AD9637_IF(int channel_num, int option);

void option_idelay_ld(int channel_num);
void option_idelay_inc_ce(int channel_num);
void option_idelay_ce(int channel_num);
void option_idelay_cntvaluein(int channel_num, u8 value);
void option_serdes_bitslip(int channel_num);
void option_serdes_ce(int channel_num, int sw);

void option_serdes_rst();
void option_idelayctrl_rst();
void option_all_regs_rst();

void option_trans_result_to_dma();
void SetValue_add_times(u16 value);
void option_active_calcu(int channel_num);
void option_deactive_calcu(int channel_num);

void clr_bit_order(int channel_num);
void set_bit_order(int channel_num);
void option_bit_order_flip(int channel_num);
u32 ReadSpecifiedData(int channel_num, int opt_num);
void led_show_choise_flip();
void led_show_adc1();
void led_show_adc0();



#endif /* SRC_AD9637_IF_H_ */