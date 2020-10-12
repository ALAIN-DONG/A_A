#include "AD9637_SPI.h"
#include "project_utils.h"

u32	CtrlReg;

void begin_to_go_ready(){
	Set_begin_go;
	while(!((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<0))){};
}

void begin_to_go(){
	Clr_begin_go;
	while(((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<0))){};
}

int get_begin_to_go(){
	return ((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<0)) ? 1:0;
}

void set_ad_pd(){
	Set_ad_pd;
	while(!((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<1))){}; // 等待成功置位
}

void clr_ad_pd(){
	Clr_ad_pd;
	while(((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<1))){}; //等待成功复位
}

int get_ad_pd(){
	return ((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<1)) ? 1:0;
}

void set_ad_sync(){
	Set_ad_sync;
	while(!((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<2))){};
}

void clr_ad_sync(){
	Clr_ad_sync;
	while(((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<2))){};
}

int get_ad_sync(){
	return ((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<2)) ? 1:0;
}

void active_Adc0(){
	Set_ADC0;
	while(!((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<3))){};
}

void desactive_Adc0(){
	Clr_ADC0;
	while(((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<3))){};
}

int get_Adc0_state(){
	return (((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<3)) ? 1:0);
}

void active_Adc1(){
	Set_ADC1;
	while(!((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<4))){};
}

void desactive_Adc1(){
	Clr_ADC1;
	while(((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<4))){};
}


int get_Adc1_state(){
	return ((AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET)) & (1<<4)) ? 1:0;
}


void write_command(u32 commend){
	AD_9637_SPI_mWriteReg(SPI_BASEADDR, CTRLREG_OFFSET, commend);
	while(!(read_cmd_from_ctrlreg() == commend)){}
}


u32	read_data_from_datareg(){
	return	AD_9637_SPI_mReadReg(SPI_BASEADDR, DATAREG_OFFSET);
}

u32	read_cmd_from_ctrlreg(){
	return	AD_9637_SPI_mReadReg(SPI_BASEADDR, CTRLREG_OFFSET);
}

//重置两配置寄存器
void init_regs(){
	AD_9637_SPI_mWriteReg(SPI_BASEADDR, BEGINTOGO_OFFSET, 0x00000000);
	while(!(AD_9637_SPI_mReadReg(SPI_BASEADDR, BEGINTOGO_OFFSET) == 0)){}
	AD_9637_SPI_mWriteReg(SPI_BASEADDR, CTRLREG_OFFSET, 0x00000000);
	while(!(AD_9637_SPI_mReadReg(SPI_BASEADDR, CTRLREG_OFFSET) == 0)){}
}

//读取spi操作是否完成
int read_done(){
	u32 done_read;
	done_read = AD_9637_SPI_mReadReg(SPI_BASEADDR, DONE_OFFSET);
	if (done_read & 0x00000001){
		return 1; // SPI sequence finished
	}else{
		return 0; // Problems occurred while in SPI sequence
	}
}

//读取ADC芯片内指定地址的寄存器的值
u8 Read_reg(u32 addr, u8 *data_out){
	u32 commands_temp 	= 	0x00000000;
	u8	data_temp;
	commands_temp = addr;
	commands_temp = commands_temp << 8;
	commands_temp |= 1 << (24-1);
	commands_temp &= ~(1<<(23-1));
	commands_temp &= ~(1<<(22-1));
	write_command(commands_temp);

	begin_to_go_ready();
	while(read_done()){};

	if (read_cmd_from_ctrlreg() == commands_temp){// commands have been written into axi reg, begin to go
		begin_to_go();
	}else{
		xil_printf("failed to write commands into axi regs while Reading\r\n");
		data_temp = 0;
		*data_out = data_temp;
		return data_temp;
	}

	while(!read_done()){};

	if(read_done()){// operation successfully finished, begin to read the data
		data_temp = read_data_from_datareg() & 0xFF;
		*data_out = data_temp;
		return data_temp;
	}else{// operation hasn't finished, there are certain problems
		xil_printf("problems occurred while reading\r\n");
		data_temp = 0;
		*data_out = data_temp;
		return data_temp;
	}
}


//为ADC芯片内的指定地址的寄存器写入值（8位）
void Write_reg(u32 addr, u8 data_in){
	u32 commands_temp 	= 	0x00000000;
	commands_temp = addr;
	commands_temp = commands_temp << 8;
	commands_temp &= ~(1<<(24-1));
	commands_temp &= ~(1<<(23-1));
	commands_temp &= ~(1<<(22-1));
	commands_temp |= data_in;

	write_command(commands_temp);
	begin_to_go_ready();
	while(read_done()){};

	if (read_cmd_from_ctrlreg() == commands_temp){// commands have been written into axi reg, begin to go
		begin_to_go();
	}else{
		xil_printf("failed to write commands into axi regs while Writing\r\n");
	}

	while(!read_done()){};

	if(!read_done()){// operation not finished successfully
		xil_printf("problems occurred while Writing\r\n");
	}
}


//读取adc芯片内寄存器的值并打印详细信息
void ReadRegShow(u16 Order_addr){
	u8	reg_result	= 0x00;
    char binary_char[40];

	Read_reg(Order_addr, &reg_result);

	tobin_8(reg_result, binary_char);

	xil_printf("Read  : %04x | %02x | %s\r\n", Order_addr, reg_result, binary_char);
}

//写入adc芯片，并打印写入的详细信息
void WriteRegShow( u16 Order_addr, u8 Order_data){
    char binary_char[40];

    Write_reg(Order_addr, Order_data);

	tobin_8(Order_data, binary_char);

	xil_printf("Write : %04x | %02x | %s\r\n", Order_addr, Order_data, binary_char);
}


//读取adc芯片内所有寄存器的值
//read all regs in ADC chip
void Read_All_Regs(){
	u16 Order_addr = 0x0;
	xil_printf("------------------------------------\r\n");
	while(Order_addr < 0x0020){
		ReadRegShow(Order_addr);
		Order_addr += 0x1;
	}
	xil_printf("  \r\n");
}

