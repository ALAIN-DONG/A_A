/*
 * dma_intr.h
 *
 *  Created on: 2020Äê9ÔÂ27ÈÕ
 *      Author: Alain
 */

#ifndef SRC_DMA_INTR_H_
#define SRC_DMA_INTR_H_
//#include "xil_types.h"
#include "xaxidma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xdebug.h"
#include "xscugic.h"

#define DMA_DEV_ID		XPAR_AXIDMA_0_DEVICE_ID

#define MEM_BASE_ADDR		0x10000000


#define RX_INTR_ID		XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR

#define MEM_BASE_ADDR		0x10000000
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#define RX_BUFFER0_BASE     RX_BUFFER_BASE
#define RX_BUFFER1_BASE     (RX_BUFFER_BASE + 0x00020000)



/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER	10000
/* test start value
 */
#define TEST_START_VALUE	0xC
/*
 * Buffer and Buffer Descriptor related constant definition
 */
#define MAX_PKT_LEN		2048//1k
/*
 * transfer times
 */
#define NUMBER_OF_TRANSFERS	100000

volatile int TxDone;
volatile int packet_trans_done;
volatile int Error;

int  DMA_CheckData(int Length, u8 StartValue);
int  DMA_Setup_Intr_System(XScuGic * IntcInstancePtr,XAxiDma * AxiDmaPtr, u16 TxIntrId, u16 RxIntrId);
int  DMA_Intr_Enable(XScuGic * IntcInstancePtr,XAxiDma *DMAPtr);
int  DMA_Intr_Init(XAxiDma *DMAPtr,u32 DeviceId);


#endif /* SRC_DMA_INTR_H_ */
