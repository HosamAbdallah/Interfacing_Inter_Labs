#include "my_LCD.h"
#include "my_keypad.h"
#include <util/delay.h>

char* convertData(unsigned int var)
{
	static char data[17];
	char* arr = &data[16];

	*arr = '\0';

	while(var != 0)
	{
		arr--;
		*arr = (var%10) + '0';
		var = var / 10;	
	}
	return arr;
}

int main(void)
{
	unsigned char mykey = NO_PRESSED_KEY;
	LCD_Init();
	KeyPad_Init();
	while(1)
	{
		mykey = KeyPad_getKey();
		if(mykey != NO_PRESSED_KEY)
		{
			switch(mykey)
			{
				case ON_KEY:
					mykey = '@';
					break;
				case SUB_KEY:
					mykey = '-';
					break;
				case SUM_KEY:
					mykey = '+';
					break;
				case EQUAL_KEY:
					mykey = '=';
					break;
				case MUL_KEY:
					mykey = '*';
					break;
				case DIV_KEY:
					mykey = '/';
					break;
				default:
					mykey = mykey + '0';
					break;
			}
			if(mykey == '@')
				LCD_Clear();
			else
				LCD_SendData(mykey);
		}
	}
	return 0;
}
