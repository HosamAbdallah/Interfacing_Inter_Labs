#include "my_LCD.h"
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
	unsigned char x = 0;
	unsigned char state = 0;
	unsigned char mydata = 102;
	char* mycData;
	 
	LCD_Init();
	mycData = convertData(mydata);
	LCD_SendString_XY(mycData, 0, 1);
	_delay_ms(2000);
	while(1)
	{
		
		LCD_SendString_XY("Welcome Board", x, 0);
		_delay_ms(500);
		LCD_Clear();
		if(state == 0)
		{
			x++;
		}
		else
		{
			x--;
		}
		
		if((x==3) || (x==0))
		{
			state = !state;
		}

	}
	return 0;
}
