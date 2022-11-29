#include <avr/io.h>
#include "my_uart.h"
#include <util/delay.h>

int main(void)
{
	unsigned char str[4][16] = {"F18 Group#", "Embedded Fab#", "UART Test#", "End#"};
	unsigned char count = 0;

    // init uart
	UART_Init();

	// Delay for Let Rx Be stablized
	_delay_ms(2000);

	while(1)
	{
		for(count=0; count<4; count++)
		{
			UART_SendString(str[count]);
			_delay_ms(5000);
		}
	}
	return 0;
}
