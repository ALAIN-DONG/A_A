/*
 * operations.h
 *
 *  Created on: 2020��10��9��
 *      Author: Alain
 */

#ifndef SRC_OPERATIONS_H_
#define SRC_OPERATIONS_H_

#include <stdio.h>
#include "platform.h"//???
#include "xil_printf.h"//
#include "xil_io.h"
#include "sleep.h"
#include "xparameters.h"//
#include "AD9637_SPI.h"
#include "AD9637_IF.h"
#include "project_utils.h"


void Execute_Order_New(int order_num, u32 New_Order_Addr, u32 New_Order_Data, u32 New_Operation, int channel, char *feedback);
int Read_Order_New(char Order_Input[], u32 *Order_Addr, u32 *Order_Data, u32 *Operation, int *Order_Channel);
void auto_init_serdes();
void init_idelay();
void init_spi(void);
int final_check(void);
void change_adc_test_value(u32 value, int num_adc);
void default_system_setting();



#endif /* SRC_OPERATIONS_H_ */
