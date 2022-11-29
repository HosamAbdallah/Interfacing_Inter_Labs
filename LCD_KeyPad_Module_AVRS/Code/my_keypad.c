#include "my_keypad.h"
#include <avr/io.h>
#include <util/delay.h>

void KeyPad_Init(void)
{
	// Init Input Port
	// Init Output Port
	DDRC = 0xF0;
	PORTC = 0xFF;
}

unsigned char KeyPad_getKey(void)
{
	unsigned char count = 0;
	unsigned char rows_value = 0;
	unsigned char key = NO_PRESSED_KEY;
	for(count=4; count<8; count++)
	{
		PORTC = PORTC | 0xF0;
		// Make Col = 0
		PORTC = PORTC & (~(1<<count));
		// To let Col = 0 for small time
		_delay_ms(1);
		rows_value = PINC & 0x0F;
		if(rows_value != 0x0F)
		{
			while((PINC & 0x0F) != 0x0F);
			break;
		}
	}
	if(count == 8)
	{
		return NO_PRESSED_KEY;
	}
	count = count - 4;

	switch(count)
	{
		// Col0
		case 0:
			switch(rows_value)
			{
				case 0x0E:
					key = 7;
					break;
				case 0x0D:
					key = 4;
					break;
				case 0x0B:
					key = 1;
					break;
				case 0x07:
					key = ON_KEY;
					break;
				default:
					break;
			}
			break;
		// Col1
		case 1:
			switch(rows_value)
			{
				case 0x0E:
					key = 8;
					break;
				case 0x0D:
					key = 5;
					break;
				case 0x0B:
					key = 2;
					break;
				case 0x07:
					key = 0;
					break;
				default:
					break;
			}
			break;
		// Col2
		case 2:
			switch(rows_value)
			{
				case 0x0E:
					key = 9;
					break;
				case 0x0D:
					key = 6;
					break;
				case 0x0B:
					key = 3;
					break;
				case 0x07:
					key = EQUAL_KEY;
					break;
				default:
					break;
			}
			break;
		// Col3
		case 3:
			switch(rows_value)
			{
				case 0x0E:
					key = DIV_KEY;
					break;
				case 0x0D:
					key = MUL_KEY;
					break;
				case 0x0B:
					key = SUB_KEY;
					break;
				case 0x07:
					key = SUM_KEY;
					break;
				default:
					break;
			}
			break;

		default:
			break;
	}
	return key;
}
