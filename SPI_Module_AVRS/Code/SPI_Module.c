#include <avr/io.h>
#include <util/delay.h>
#include "my_spi.h"

int main(void)
{
	unsigned char count = 0x00;
	DDRA = 0x00;
	PORTA = 0xFF;

	SPI_MasterInit();

	while(1)
	{
		if((PINA&0x01) == 0x00)
		{
			count++;
			if(count>9)
			{
				count = 0;
			}
			SPI_SendChar(count);
			while((PINA&0x01) == 0x00);
		}
	}
	return 0;
}
