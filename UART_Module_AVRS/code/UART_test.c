#include <avr/io.h>
#include "my_uart.h"

int main(void)
{
	unsigned char x[20];
	UART_Init();
	while(1)
	{
		UART_GetString(x);
		UART_SendString(x);
	}
	return 0;
}
