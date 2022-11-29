#include <avr/io.h>
#include "my_lcdlib.h"
#include "my_uart.h"
#include <util/delay.h>

int main(void)
{
	unsigned char str[16] = {0};

	// init lcd
	LCD_Init();
    // init uart
	UART_Init();

	while(1)
	{
		UART_GetString(str);
		LCD_ClearAll();
		LCD_DispString((char *)str);
	}
	return 0;
}
