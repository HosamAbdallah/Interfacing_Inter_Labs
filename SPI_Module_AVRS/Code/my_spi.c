#include <avr/io.h>
#include "my_spi.h"

void SPI_MasterInit(void)
{
	// Set The MOSI
	DDRB = 0xB0;
	
	// Set SPI as Master
	SPCR = 0x58;
	SPSR = 0x00;
}

void SPI_SlaveInit(void)
{
	// Set The MOSI
	DDRB = 0x40;

	// Set SPI as Slave
	SPCR = 0x48;
	SPSR = 0x00;
}

void SPI_SendChar(unsigned char data)
{
	SPDR = data;
	while((SPSR&0x80)==0);
}

unsigned char SPI_GetChar(void)
{
	while((SPSR&0x80)==0);
	return SPDR;
}

void SPI_SendString(unsigned char *str)
{
	while(*str != '\0')
	{
		SPI_SendChar(*str);
		str++;
	}
}

void SPI_GetString(unsigned char *str)
{
	unsigned char data = 0;
	do
	{
		data = SPI_GetChar();
		*str = data;
		str++;
	}while(data != '#');
	str--;
	*str = '\0';
}
