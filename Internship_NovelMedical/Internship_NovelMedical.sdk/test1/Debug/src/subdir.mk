################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/AD9637_SPI.c \
../src/AD9637_if.c \
../src/Operations.c \
../src/dma_intr.c \
../src/main.c \
../src/oled.c \
../src/platform.c \
../src/platform_zynq.c \
../src/project_utils.c \
../src/sys_intr.c \
../src/tcp_server_func.c \
../src/timer_intr.c \
../src/udp_server_func.c 

OBJS += \
./src/AD9637_SPI.o \
./src/AD9637_if.o \
./src/Operations.o \
./src/dma_intr.o \
./src/main.o \
./src/oled.o \
./src/platform.o \
./src/platform_zynq.o \
./src/project_utils.o \
./src/sys_intr.o \
./src/tcp_server_func.o \
./src/timer_intr.o \
./src/udp_server_func.o 

C_DEPS += \
./src/AD9637_SPI.d \
./src/AD9637_if.d \
./src/Operations.d \
./src/dma_intr.d \
./src/main.d \
./src/oled.d \
./src/platform.d \
./src/platform_zynq.d \
./src/project_utils.d \
./src/sys_intr.d \
./src/tcp_server_func.d \
./src/timer_intr.d \
./src/udp_server_func.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../test1_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


