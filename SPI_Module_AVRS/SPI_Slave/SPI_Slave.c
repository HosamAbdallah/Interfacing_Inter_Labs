#include <avr/io.h>
#include "../Code/my_spi.h"

int main(void)
{
	unsigned int rdata = 0;
	DDRC = 0xFF;
	PORTC = 0x00;
	
	SPI_SlaveInit();
	
	while(1)
	{
		rdata = SPI_GetChar();
		PORTC = rdata;
	}
	return 0;
}
