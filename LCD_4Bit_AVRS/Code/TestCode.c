#include <avr/io.h>
#include <util/delay.h>

// RS -> PORTB.0    RS-> 0 Command, RS-> 1 Data
// R/W -> PORTB.1   R/w-> 0 Write, R/W-> 1 Read
// E -> PORTB.2     E -> 1 then E-> 0

// Send CMD to LCD
void LCD_Send_Command(unsigned char cmd)
{           
  // Make RS as Command
  PORTB = PORTB & (~(1<<0));
  // Make It Write
  PORTB = PORTB & (~(1<<1));
  
  // Put CMD on PORT
  PORTB &= 0x0F;  		// Make Data Nibble as 0000
  PORTB |= (cmd&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB = PORTB | (1<<2);
  _delay_ms(1);
  PORTB = PORTB & (~(1<<2));
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= ((cmd<<4)&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB = PORTB | (1<<2);
  _delay_ms(1);
  PORTB = PORTB & (~(1<<2));

  // Let LCD Handle
  _delay_ms(100);
}

// Send Data to LCD
void LCD_Send_Data(unsigned char data)
{
  // Make RS as Data
  PORTB = PORTB | (1<<0);
  // Make It Write
  PORTB = PORTB & (~(1<<1));
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= (data&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB = PORTB | (1<<2);
  _delay_ms(1);
  PORTB = PORTB & (~(1<<2));
  
  //wait_LCD();
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= ((data<<4)&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB = PORTB | (1<<2);
  _delay_ms(1);
  PORTB = PORTB & (~(1<<2));

  // Let LCD Handle
  _delay_ms(100);
}


// Init LCD
void Init_LCD(void)
{
    _delay_ms(20);
    // Init HW Ports
    // Data Port
    // Port A initialization
    // Make it all OutPut -> 0  
    PORTB=0x00;
    DDRB=0xFF;     
      
    ///////// Special Sequence /////// 
    // Set LCD as 4 Bits
    // Set RS -> 0 Command
    // Make RS as Command
  	PORTB = PORTB & (~(1<<0));
  	// Make It Write
  	PORTB = PORTB & (~(1<<1));
    
    // Write Command to be 4 Bits Mode
    PORTB &= 0x0F;
    PORTB |= 0x30; 
    
    // Update LCD
    // Make transition from High to Low
  	PORTB = PORTB | (1<<2);
  	_delay_ms(1);
  	PORTB = PORTB & (~(1<<2));

    _delay_ms(5);
    
    // Update LCD
    // Make transition from High to Low
  	PORTB = PORTB | (1<<2);
  	_delay_ms(1);
  	PORTB = PORTB & (~(1<<2));
    
    _delay_ms(100);
    
    // Update LCD
    // Make transition from High to Low
    PORTB = PORTB | (1<<2);
  	_delay_ms(1);
  	PORTB = PORTB & (~(1<<2));
    
    _delay_ms(5);
    /////////////////////////////////
    
    // Set LCD as 4 Bits
    // Set RS -> 0 Command
    // Make RS as Command
  	PORTB = PORTB & (~(1<<0));
  	// Make It Write
  	PORTB = PORTB & (~(1<<1));
    
    // Write Command to be 4 Bits Mode
    PORTB &= 0x0F;
    PORTB |= 0x20; 
    
    // Update LCD
    // Make transition from High to Low
    PORTB = PORTB | (1<<2);
  	_delay_ms(1);
  	PORTB = PORTB & (~(1<<2));          
    
    // 2 Lines
    LCD_Send_Command(0x28);
    // LCD On
    LCD_Send_Command(0x0C);
}

void LCD_GotoXY(unsigned char X, unsigned char Y)
{
    if(Y==0)
    {
       LCD_Send_Command(0x80+X);
    }
    else
    {
        LCD_Send_Command(0x80 + X + 0x40);
    }
}

void LCD_Clear(void)
{
	// Send Clr command to LCD
	LCD_Send_Command(0x01);
}

void LCD_SendString(char *str)
{
	while(*str != '\0')
	{
		LCD_Send_Data(*str);
		str++;
	}
}

void LCD_SendString_XY(char *str, unsigned char x, unsigned char y)
{
	LCD_GotoXY(x, y);
	LCD_SendString(str);
}

int main(void)
{
    // Init LCD
    Init_LCD();
     
    LCD_GotoXY(0,0);
    // Disp Char M
    LCD_Send_Data('M');
    LCD_GotoXY(10,0);
    // Disp Char M
    LCD_Send_Data('M');
    LCD_GotoXY(0,1);
    // Disp Char M
    LCD_Send_Data('M');
    LCD_GotoXY(10,1);
    // Disp Char M
    LCD_Send_Data('M');
    
    while(1)
    {
        //Send_Data('M');
    }
	return 0;
 }
