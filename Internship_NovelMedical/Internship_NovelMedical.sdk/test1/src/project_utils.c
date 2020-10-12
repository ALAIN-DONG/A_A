/*
 * project_utils.c
 *
 *  Created on: 2020年9月21日
 *      Author: Alain
 */


#include "project_utils.h"
//#include <stdio.h>
//#include <string.h>

//算指数
u32	exponentiation(u32 base, int index){
	u32 outnum = base;
	if (index == 0){
		outnum = 1;
	}else{
		for(int i = 0; i<(index-1); i++){
			outnum = outnum * base;
		}
	}
	return outnum;
}

//将字符串转成16进制数字，仅 0-f
u32 StringToHex(char str[], int len)
{
	u32 result = 0x0;
	uint8_t i;

	for (i = 0; i < len; i ++)  //循环判断当前字符是数字还是小写字符还是大写字母
	{
		if ((str[i] >= '0') && (str[i] <= '9')){ //当前字符为数字0~9时
			result += (str[i] - '0' +0) * exponentiation(0x10, (len-i-1));
		}

		if ((str[i] >= 'A') && (str[i] <= 'F')){ //当前字符为大写字母A~Z时
			result += (str[i] - 'A' +10) * exponentiation(0x10, (len-i-1));
		}

		if ((str[i] >= 'a') && (str[i] <= 'f')){ //当前字符为小写字母a~z时
			result += (str[i] - 'a' +10) * exponentiation(0x10, (len-i-1));
		}
	}
	return result;
}

// 字符串型二进制转16进制数字
u32 StringBinToHex(char str[], int len)
{
	u32 result = 0x0;
	uint8_t i;

	for (i = 0; i < len; i ++)  //循环判断当前字符是数字还是小写字符还是大写字母
	{
		if (str[i] == '1'){ //当前字符为数字0~9时
			result += (str[i] - '0' +0) * exponentiation(0x2, (len-i-1));
		}
	}

	return result;
}

//字符串型16进制转十进制
int StringHexToInt(char str[], int len){
	int result = 0;
	int i;
	for (i=0; i<len; i++){
		if ((str[i] >= '0') && (str[i] <= '9')){ //当前字符为数字0~9时
			result += (str[i] - '0' +0) * exponentiation(0xA, (len-i-1));
		}
	}
	return result;
}

//字符串型十进制转十进制数字
int StringIntToInt(char str[], int len){
	int result = 0;
	int i;
	int base = 1;
	for(i = 0; i<len; i++){
		result = result + base * (str[len-i-1] - '0');
		base = base * 10;
	}
	return result;
}

//颠倒输入无符号8位数的首尾
u8 re_uc_8(u8 a){
//	xil_printf("original is : %x \r\n", a);
	u8  b=0;
	u8	temp;
	for(int i=0;i<8;i++){
		temp=a&0x01;
		a=a>>1;
		b=b+temp;
		if(i != 7)
			b=b<<1;
	}
    return   b;
}

//颠倒输入无符号16位数的首尾
u16 re_uc_16(u16 a){
//	xil_printf("original is : %x \r\n", a);
	u16  b=0;
	u16	temp;
	for(int i=0;i<16;i++){
		temp=a&0x0001;
		a=a>>1;
		b=b+temp;
		if(i != 15)
			b=b<<1;
	}
    return   b;
}


//颠倒输入无符号32位数的首尾
u32 re_uc_32(u32 a){
//	xil_printf("original is : %x \r\n", a);
	u32  b=0;
	u32	temp;
	for(int i=0;i<32;i++){
		temp=a&0x00000001;
		a=a>>1;
		b=b+temp;
		if(i != 31)
			b=b<<1;
	}
    return   b;
}

//将8bits数据转换成字符串型二进制
void tobin_8(u8 data_in, char *str){
	u8	mask = 0x01;
	for(int i = 0; i < 8; i++){
		str[(7-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[8] = '\0';
}

//转换16位无符号数字为二进制表示的字符串
void tobin_16(u16 data_in, char *str){
	u16	mask = 0x0001;
	for(int i = 0; i < 16; i++){
		str[(15-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[16] = '\0';
}

//转换32位无符号数字为二进制表示的字符串
void tobin_32(u32 data_in, char *str){
	u32	mask = 0x00000001;
	for(int i = 0; i < 32; i++){
		str[(31-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[32] = '\0';
}


//截取给定起始与终止位之间的字符串
char* substring(char* str, int start, int end){
	int i = 0;
	char* sub = NULL;
	char buff[256];
	if(start < 0 || start >= end || strlen(str) < end){
		return str;
	}

	for (i = start; i <= end; i++){
		buff[i - start] = str[i];
	}
	buff[end-start+1] = '\0';
	sub = buff;

	return sub;
}



// 检查输入数字是否是参考数字的移位，如果是，返回输入相对于参考右移的次数
int check_value_shift_12b(u32 value, u32 value_ref){//判断输入的12bits数value 是否是value_ref的循环移位
	int return_val = -1;
	u32 temp_val = value_ref & 0xFFF;
	int	msb = 0;

	for(int i = 0; i < 12; i ++){
		if(value == temp_val){
			return_val = i;
			break;
		}
		msb = (temp_val >> 11) & 0x00000001;

		temp_val = temp_val << 1;
		temp_val = temp_val | (msb & 0x00000001);
		temp_val = temp_val & 0xFFF;
	}

	return return_val;
}
