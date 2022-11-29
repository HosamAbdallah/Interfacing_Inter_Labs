#include "my_lcdlib.h"
#include <util/delay.h>
#include <avr/io.h>

void LCD_Init(void)
{
	// Set PORTB -> Output Port
	DDRB = 0xFF;
	PORTB = 0x00;

	// Set PORTC -> Output Port
	DDRC = 0x07;
	PORTC = 0x01;

	// Data Format Command -> 8 Bit Mode
	LCD_SendCmd(0x38);

	// On LCD
	LCD_SendCmd(0x0C);

	// Clear LCD
	LCD_ClearAll();
}

void LCD_DispChar(unsigned char data)
{
	// Make RS -> Data 1
	PORTC = PORTC | 0x04;
	// Make R/W -> W 0
	PORTC = PORTC & 0xFD;

	// Put data to Data Pins
	PORTB = data;

	// Make E -> Low
	PORTC = PORTC & 0xFE;
	// Delay For Small Time
	_delay_ms(1);
	// Make E -> High
	PORTC = PORTC | 0x01;

	// Give LCD some Delay
	_delay_ms(5);
}

void LCD_SendCmd(unsigned char cmd)
{
	// Make RS -> COMMAND 0
	PORTC = PORTC & 0xFB;
	// Make R/W -> W 0
	PORTC = PORTC & 0xFD;

	// Put cmd to Data Pins
	PORTB = cmd;

	// Make E -> Low
	PORTC = PORTC & 0xFE;
	// Delay For Small Time
	_delay_ms(1);
	// Make E -> High
	PORTC = PORTC | 0x01;

	// Give LCD some Delay
	_delay_ms(5);
}

void LCD_ClearAll(void)
{
	LCD_SendCmd(0x01);
}

void LCD_GotoXY(unsigned char x, unsigned char y)
{
	if(y == 1)
	{
		LCD_SendCmd(0x80 + x);
	}
	else if( y == 2)
	{
		LCD_SendCmd(0xC0 + x);
	}
	else if(y == 3)
	{
		LCD_SendCmd(0x94 + x);
	}
	else if( y == 4)
	{
		LCD_SendCmd(0xD4 + x);
	}

}

void LCD_DispString(char *str)
{
	unsigned char count = 0;
	while(str[count] != '\0')
		LCD_DispChar(str[count++]);
}
