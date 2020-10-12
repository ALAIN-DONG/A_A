/*
 * AD9637_if.c
 *
 *  Created on: 2020年9月10日
 *      Author: Alain
 */

#include "AD9637_IF.h"
#include "xil_io.h"

int sw_order[16] = {0};
int	sw_led_show	= 0;

//控制寄存器表
int Ctrl_BassAddr_Tab[16] = {
		ADC0_CTRL_CH0_BASEADDR	 ,
        ADC0_CTRL_CH1_BASEADDR	 ,
        ADC0_CTRL_CH2_BASEADDR	 ,
        ADC0_CTRL_CH3_BASEADDR	 ,
        ADC0_CTRL_CH4_BASEADDR	 ,
        ADC0_CTRL_CH5_BASEADDR	 ,
        ADC0_CTRL_CH6_BASEADDR	 ,
        ADC0_CTRL_CH7_BASEADDR	 ,
        ADC1_CTRL_CH8_BASEADDR	 ,
        ADC1_CTRL_CH9_BASEADDR	 ,
        ADC1_CTRL_CH10_BASEADDR	 ,
        ADC1_CTRL_CH11_BASEADDR	 ,
        ADC1_CTRL_CH12_BASEADDR	 ,
        ADC1_CTRL_CH13_BASEADDR	 ,
        ADC1_CTRL_CH14_BASEADDR	 ,
		ADC1_CTRL_CH15_BASEADDR
};

//数据寄存器表
int Data_BassAddr_Tab[16] = {
		ADC0_Data_CH0_BASEADDR	,
		ADC0_Data_CH1_BASEADDR	,
		ADC0_Data_CH2_BASEADDR	,
		ADC0_Data_CH3_BASEADDR	,
		ADC0_Data_CH4_BASEADDR	,
		ADC0_Data_CH5_BASEADDR	,
		ADC0_Data_CH6_BASEADDR	,
		ADC0_Data_CH7_BASEADDR	,
		ADC1_Data_CH8_BASEADDR	,
		ADC1_Data_CH9_BASEADDR	,
		ADC1_Data_CH10_BASEADDR	,
		ADC1_Data_CH11_BASEADDR	,
		ADC1_Data_CH12_BASEADDR	,
		ADC1_Data_CH13_BASEADDR	,
		ADC1_Data_CH14_BASEADDR	,
		ADC1_Data_CH15_BASEADDR
};


//使能指定通道的指定寄存器
void Set_CTRL_AD9637_IF(int channel_num, int option){
	switch (channel_num){
	case	0	:	Set_Ctrl_Bit_ADC0_CH0(option); break;
	case	1	:	Set_Ctrl_Bit_ADC0_CH1(option); break;
	case	2	:	Set_Ctrl_Bit_ADC0_CH2(option); break;
	case	3	:	Set_Ctrl_Bit_ADC0_CH3(option); break;
	case	4	:	Set_Ctrl_Bit_ADC0_CH4(option); break;
	case	5	:	Set_Ctrl_Bit_ADC0_CH5(option); break;
	case	6	:	Set_Ctrl_Bit_ADC0_CH6(option); break;
	case	7	:	Set_Ctrl_Bit_ADC0_CH7(option); break;
	case	8	:	Set_Ctrl_Bit_ADC1_CH8(option); break;
	case	9	:	Set_Ctrl_Bit_ADC1_CH9(option); break;
	case	10	:	Set_Ctrl_Bit_ADC1_CH10(option); break;
	case	11	:	Set_Ctrl_Bit_ADC1_CH11(option); break;
	case	12	:	Set_Ctrl_Bit_ADC1_CH12(option); break;
	case	13	:	Set_Ctrl_Bit_ADC1_CH13(option); break;
	case	14	:	Set_Ctrl_Bit_ADC1_CH14(option); break;
	case	15	:	Set_Ctrl_Bit_ADC1_CH15(option); break;
	default		:	break;
	}
}

//清除指定通道的指定位寄存器
void Clr_CTRL_AD9637_IF(int channel_num, int option){
	switch (channel_num){
	case	0	:	Clr_Ctrl_Bit_ADC0_CH0(option); break;
	case	1	:	Clr_Ctrl_Bit_ADC0_CH1(option); break;
	case	2	:	Clr_Ctrl_Bit_ADC0_CH2(option); break;
	case	3	:	Clr_Ctrl_Bit_ADC0_CH3(option); break;
	case	4	:	Clr_Ctrl_Bit_ADC0_CH4(option); break;
	case	5	:	Clr_Ctrl_Bit_ADC0_CH5(option); break;
	case	6	:	Clr_Ctrl_Bit_ADC0_CH6(option); break;
	case	7	:	Clr_Ctrl_Bit_ADC0_CH7(option); break;
	case	8	:	Clr_Ctrl_Bit_ADC1_CH8(option); break;
	case	9	:	Clr_Ctrl_Bit_ADC1_CH9(option); break;
	case	10	:	Clr_Ctrl_Bit_ADC1_CH10(option); break;
	case	11	:	Clr_Ctrl_Bit_ADC1_CH11(option); break;
	case	12	:	Clr_Ctrl_Bit_ADC1_CH12(option); break;
	case	13	:	Clr_Ctrl_Bit_ADC1_CH13(option); break;
	case	14	:	Clr_Ctrl_Bit_ADC1_CH14(option); break;
	case	15	:	Clr_Ctrl_Bit_ADC1_CH15(option); break;
	default		:	break;
	}
}


//为指定通道的寄存器的指定位段赋指定值（可一次性改变多个寄存器）
void SetValue_AD9637_IF(int channel_num, u8 value, int len_value, int position){ // value is Hex

	char value_bin[8];
	tobin_8(value, value_bin);
	u32 val_temp = Xil_In32(Ctrl_BassAddr_Tab[channel_num]);

	int k=7;
	for (int i =position; i<(len_value+position); i++){
		if (value_bin[k] == '0'){ //clr
			val_temp = val_temp&(~(1<<i));
		}else if(value_bin[k] == '1'){
			val_temp = val_temp|(1<<i);
		}
		k--;
	}

	Xil_Out32(Ctrl_BassAddr_Tab[channel_num],val_temp);
	val_temp = Xil_In32(Ctrl_BassAddr_Tab[channel_num]);
}


//读取指定通道的指定寄存器
/*
0: idelay_ld
1: idelay_inc
2: idelay_ce
3: idelay_cntvaluein
4: iserdes_bitslip
5: iserdes_ce
6: bit_order
7: idelay_cntvalueout
8: idelayctrl_ready
9: iserdes_rst
10:idelayctrl_rst
11:data_processing_en
12:read_value
13:led show debug
*/
u32 ReadSpecifiedData(int channel_num, int opt_num){
	u32	temp_value;
	u32 return_num;
	switch (opt_num){
	case	0:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<0))) ? 1 : 0; break; //idelay_ld
	case	1:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<1))) ? 1 : 0; break; //idelay_inc
	case	2:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<2))) ? 1 : 0; break; //idelay_ce
	case	3:
		temp_value = Xil_In32(Ctrl_BassAddr_Tab[channel_num]) >> 3;//idelay_cntvaluein
		return_num = (temp_value) & 0x0000001F; break;
	case	4:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<8))) ? 1 : 0; break; //iserdes_bitslip
	case	5:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<9))) ? 1 : 0; break; //iserdes_ce
	case	6:
		return_num = (((Xil_In32(Ctrl_BassAddr_Tab[channel_num])) & (1<<10))) ? 1 : 0; break; //bit_order
	case	7:
		temp_value = Xil_In32(Data_BassAddr_Tab[channel_num]) >> 16;//idelay_cntvalueout
		return_num = (temp_value) & 0x0000001F; break;
	case	8:
		return_num = (Xil_In32(ADC_ALL_State_BASEADDR) & (1<<0)) ? 1:0; break;//idelayctrl_ready
	case	9:
		return_num = (Xil_In32(ADC_ALL_Ctrl_BASEADDR) & (1<<0)) ? 1:0; break;//iserdes_rst
	case	10:
		return_num = (Xil_In32(ADC_ALL_Ctrl_BASEADDR) & (1<<1)) ? 1:0; break; //idelayctrl_rst
	case	11:
		return_num = (Xil_In32(ADC_ALL_Ctrl_BASEADDR) & (1<<(channel_num + 16))) ? 1 : 0; break;
	case	12:
		temp_value = Xil_In32(Data_BassAddr_Tab[channel_num]) & (0x00000FFF);
		return_num = temp_value;	break;
	case	13:
		return_num = (Xil_In32(ADC_ALL_Ctrl_BASEADDR) & (1<<3)) ? 1:0; break;//led show sw
	case	14:
			return_num = (Xil_In32(ADC_ALL_Ctrl_BASEADDR) & (1<<4)) ? 1:0; break;//led show sw
	default	: return_num = 0; break;
	}
	return return_num;
}

//在指定通道上执行一次加载预编程值操作
void option_idelay_ld(int channel_num){
	Set_CTRL_AD9637_IF(channel_num, 0);
	Clr_CTRL_AD9637_IF(channel_num, 0);
	while(ReadSpecifiedData(channel_num, 0)){};
}

//在指定通道上执行一次idelay的tap递操作
void option_idelay_inc_ce(int channel_num){
	SetValue_AD9637_IF(channel_num, 0x03, 2, 1);
	SetValue_AD9637_IF(channel_num, 0x00, 2, 1);
	while(ReadSpecifiedData(channel_num, 1) || ReadSpecifiedData(channel_num, 2)){};
}

//在指定通道上执行一次idelay的tap的增减操作
void option_idelay_ce(int channel_num){
	Set_CTRL_AD9637_IF(channel_num, 2);
	Clr_CTRL_AD9637_IF(channel_num, 2);
	while(ReadSpecifiedData(channel_num, 2)){};
}

//在指定通道上设置其idelay的预加载tap值
void option_idelay_cntvaluein(int channel_num, u8 value){
	SetValue_AD9637_IF(channel_num, value, 5, 3);
	while((ReadSpecifiedData(channel_num, 3)&0xFF) != value){};
}

//在指定通道上执行一次位对齐
void option_serdes_bitslip(int channel_num){
	Set_CTRL_AD9637_IF(channel_num, 8);
	Clr_CTRL_AD9637_IF(channel_num, 8);
	while(ReadSpecifiedData(channel_num, 4)){};
}

//使能或禁用指定通道的serdes解串模块
void option_serdes_ce(int channel_num, int sw){
	if (sw==1){
		Set_CTRL_AD9637_IF(channel_num, 9);
		while(!ReadSpecifiedData(channel_num, 5)){};
	}
	else if(sw==0){
		Clr_CTRL_AD9637_IF(channel_num, 9);
		while(ReadSpecifiedData(channel_num, 5)){};
	}
}


//重置所有serdes解串模块（bitslip信息会丢失）
void option_serdes_rst(){
	Set_Led_Show_ctrl;
	usleep(1000);
	Clr_Serdes_rst;
}

//重置idelayctrl模块
void option_idelayctrl_rst(){

	Set_IdelayCtrl_rst;
	while(!ReadSpecifiedData(0, 10)){};
	usleep(1000);
	Clr_IdelayCtrl_rst;
	while(ReadSpecifiedData(0, 10)){};
}

//重置interface控制器内的所有寄存器
void option_all_regs_rst(){
	Set_All_regs_rst;
	Clr_All_regs_rst;
}

//使用默认的12位并行数据的前后六位顺序
void clr_bit_order(int channel_num){
	Clr_CTRL_AD9637_IF(channel_num,10);
	while(ReadSpecifiedData(channel_num, 6)){};
	sw_order[channel_num] = 0;
}

//设置反转12位并行数据的前后六位顺序
void set_bit_order(int channel_num){
	Set_CTRL_AD9637_IF(channel_num,10);
	while(!ReadSpecifiedData(channel_num, 6)){};
	sw_order[channel_num] = 1;
}

//调换12位并行数据的前后六位
void option_bit_order_flip(int channel_num){
	if(!sw_order[channel_num]){
		Set_CTRL_AD9637_IF(channel_num,10);
		while(!ReadSpecifiedData(channel_num, 6)){};
		sw_order[channel_num] = 1;
	}else{
		Clr_CTRL_AD9637_IF(channel_num,10);
		while(ReadSpecifiedData(channel_num, 6)){};
		sw_order[channel_num] = 0;
	}
}

//将计算单元所得的计算结果存入adc一次
void option_trans_result_to_dma(){
	Set_trans_dma;
	Clr_trans_dma;
	while(ReadSpecifiedData(0,14)){};
}

//指定所有计算模块的加法次数
void SetValue_add_times(u16 value){ // value MAX 2047
	u32 temp_val =  Xil_In32(ADC_ALL_Ctrl_BASEADDR);
	u32 mask     =  value & 0x7FF;  //(11bits valide)
	mask = (mask << 5) & (0xFFE0);
	temp_val = temp_val & (~0xFFE0);
	temp_val = temp_val | mask;
	Xil_Out32(ADC_ALL_Ctrl_BASEADDR,temp_val);
}

//打开与关闭指定同都的计算模块
void option_active_calcu(int channel_num){
	Set_active_cal(channel_num);
}
void option_deactive_calcu(int channel_num){
	Clr_active_cal(channel_num);
}

//由LED输出ADC0的CH0的并行数据
void led_show_adc0(){
	Clr_Led_Show_ctrl;
	while(ReadSpecifiedData(0, 13)){};
	sw_led_show = 0;
}

//由led输出ADC1的CH8的并行数据
void led_show_adc1(){
	Set_Led_Show_ctrl;
	while(!ReadSpecifiedData(0, 13)){};
	sw_led_show = 1;
}

//调换led输出的通道
void led_show_choise_flip(){
	if(!sw_led_show){
		Set_Led_Show_ctrl;
		while(!ReadSpecifiedData(0, 13)){};
		sw_led_show = 1;
	}else{
		Clr_Led_Show_ctrl;
		while(ReadSpecifiedData(0, 13)){};
		sw_led_show = 0;
	}

}

