/*
 * project_utils.h
 *
 *  Created on: 2020Äê9ÔÂ21ÈÕ
 *      Author: Alain
 */

#ifndef SRC_PROJECT_UTILS_H_
#define SRC_PROJECT_UTILS_H_

#include "platform.h"
#include "xil_printf.h"

u32	exponentiation(u32 base, int index);
u32 StringToHex(char str[], int len);
u32 StringBinToHex(char str[], int len);
int StringHexToInt(char str[], int len);
int StringIntToInt(char str[], int len);

u8 re_uc_8(u8 a);
u16 re_uc_16(u16 a);
u32 re_uc_32(u32 a);
void tobin_8(u8 data_in, char *str);
void tobin_32(u32 data_in, char *str);
void tobin_16(u16 data_in, char *str);
char* substring(char* str, int start, int end);
int check_value_shift_12b(u32 value, u32 value_ref);


#endif /* SRC_PROJECT_UTILS_H_ */
