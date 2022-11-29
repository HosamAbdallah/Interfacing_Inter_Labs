#include <avr/io.h>
#include <util/delay.h>
#include "MyLCD.h"

#define UPDATE_LCD() \
{\
   PORTB |= 0x01; \
   _delay_ms(1);  \
   PORTB &= 0xFE; \
}
void LCD_wait(void)
{
   unsigned char temp = 1;
   // Make D7 as input
   DDRA = 0x7F;
   PORTA = 0x80;
  
   // Set R/W as Read
   PORTB |= 0x02;
   
   // Set RS -> Command
   PORTB &= 0xFB;
   
   // Check on D7 if Not Free wait
   do
   {
        PORTB |= 0x01; 
        _delay_ms(1); 
		temp = PINA; 
        PORTB &= 0xFE; 
   }
   while((temp&0x80)==0x80);
   
   // Make D7 as Output Pin
   DDRA = 0xFF;
}

void LCD_sendCmd(unsigned char cmd)
{
   // Wait LCD
   LCD_wait();
   
   // Put Cmd
   PORTA = cmd;
   
   // Set RS -> Command
   PORTB &= 0xFB;
   
   // Set R/W -> Write
   PORTB &= 0xFC;
   
   // Update LCD
   UPDATE_LCD();
}

void LCD_sendData(unsigned char data)
{
   // Wait LCD
   LCD_wait();
   
   // Put Data
   PORTA = data;
   
   // Set RS -> Data
   PORTB |= 0x04;
   
   // Set R/W -> Write
   PORTB &= 0xFC;
   
   // Update LCD
   UPDATE_LCD();
}

void LCD_GotoXY(unsigned char x, unsigned char y)
{
   if(x==0)
    LCD_sendCmd(0x80+y);
   else
    LCD_sendCmd(0x80+0x40+y);

}

void LCD_sendStr(char *str)
{
  unsigned char count = 0;
  while(str[count] != '\0')
  {
    LCD_sendData(str[count]);
	count++;
  }
}
