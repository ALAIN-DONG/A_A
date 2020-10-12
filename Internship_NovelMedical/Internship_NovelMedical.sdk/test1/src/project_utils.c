/*
 * project_utils.c
 *
 *  Created on: 2020��9��21��
 *      Author: Alain
 */


#include "project_utils.h"
//#include <stdio.h>
//#include <string.h>

//��ָ��
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

//���ַ���ת��16�������֣��� 0-f
u32 StringToHex(char str[], int len)
{
	u32 result = 0x0;
	uint8_t i;

	for (i = 0; i < len; i ++)  //ѭ���жϵ�ǰ�ַ������ֻ���Сд�ַ����Ǵ�д��ĸ
	{
		if ((str[i] >= '0') && (str[i] <= '9')){ //��ǰ�ַ�Ϊ����0~9ʱ
			result += (str[i] - '0' +0) * exponentiation(0x10, (len-i-1));
		}

		if ((str[i] >= 'A') && (str[i] <= 'F')){ //��ǰ�ַ�Ϊ��д��ĸA~Zʱ
			result += (str[i] - 'A' +10) * exponentiation(0x10, (len-i-1));
		}

		if ((str[i] >= 'a') && (str[i] <= 'f')){ //��ǰ�ַ�ΪСд��ĸa~zʱ
			result += (str[i] - 'a' +10) * exponentiation(0x10, (len-i-1));
		}
	}
	return result;
}

// �ַ����Ͷ�����ת16��������
u32 StringBinToHex(char str[], int len)
{
	u32 result = 0x0;
	uint8_t i;

	for (i = 0; i < len; i ++)  //ѭ���жϵ�ǰ�ַ������ֻ���Сд�ַ����Ǵ�д��ĸ
	{
		if (str[i] == '1'){ //��ǰ�ַ�Ϊ����0~9ʱ
			result += (str[i] - '0' +0) * exponentiation(0x2, (len-i-1));
		}
	}

	return result;
}

//�ַ�����16����תʮ����
int StringHexToInt(char str[], int len){
	int result = 0;
	int i;
	for (i=0; i<len; i++){
		if ((str[i] >= '0') && (str[i] <= '9')){ //��ǰ�ַ�Ϊ����0~9ʱ
			result += (str[i] - '0' +0) * exponentiation(0xA, (len-i-1));
		}
	}
	return result;
}

//�ַ�����ʮ����תʮ��������
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

//�ߵ������޷���8λ������β
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

//�ߵ������޷���16λ������β
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


//�ߵ������޷���32λ������β
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

//��8bits����ת�����ַ����Ͷ�����
void tobin_8(u8 data_in, char *str){
	u8	mask = 0x01;
	for(int i = 0; i < 8; i++){
		str[(7-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[8] = '\0';
}

//ת��16λ�޷�������Ϊ�����Ʊ�ʾ���ַ���
void tobin_16(u16 data_in, char *str){
	u16	mask = 0x0001;
	for(int i = 0; i < 16; i++){
		str[(15-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[16] = '\0';
}

//ת��32λ�޷�������Ϊ�����Ʊ�ʾ���ַ���
void tobin_32(u32 data_in, char *str){
	u32	mask = 0x00000001;
	for(int i = 0; i < 32; i++){
		str[(31-i)] = (data_in&(mask<<i))? '1' : '0';
	}
	str[32] = '\0';
}


//��ȡ������ʼ����ֹλ֮����ַ���
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



// ������������Ƿ��ǲο����ֵ���λ������ǣ�������������ڲο����ƵĴ���
int check_value_shift_12b(u32 value, u32 value_ref){//�ж������12bits��value �Ƿ���value_ref��ѭ����λ
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