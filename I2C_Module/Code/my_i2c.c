#include <avr/io.h>
#include <util/delay.h>
#include "my_eeprom.h"


int main(void)
{
	unsigned char val = 0;
	DDRA = 0xFF;
	PORTA = 0x00;

	// Init EEPROM
	EEPROM_Init();

	EEPROM_WriteByte(0x0311, 0x55);
	_delay_ms(1000);
	EEPROM_ReadByte(0x0311, &val);
	while(1)
	{
		PORTA = val;
	}
	return 0;
}

