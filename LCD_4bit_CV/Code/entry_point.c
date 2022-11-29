#include <mega32.h>
#include <delay.h>

// RS -> PORTB.0    RS-> 0 Command, RS-> 1 Data
// R/W -> PORTB.1   R/w-> 0 Write, R/W-> 1 Read
// E -> PORTB.2     E -> 1 then E-> 0

  
void Init_MCU(void)
{
    // Input/Output Ports initialization
    // Port A initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T  
    PORTA=0x00;
    DDRA=0x00;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTB=0x00;
    DDRB=0x00;

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTC=0x00;
    DDRC=0x00;

    // Port D initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTD=0x00;
    DDRD=0x00;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    TCCR0=0x00;
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer1 Stopped
    // Mode: Normal top=0xFFFF
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0x00;
    TCCR1B=0x00;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    ASSR=0x00;
    TCCR2=0x00;
    TCNT2=0x00;
    OCR2=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    MCUCR=0x00;
    MCUCSR=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;

    // USART initialization
    // USART disabled
    UCSRB=0x00;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;

    // ADC initialization
    // ADC disabled
    ADCSRA=0x00;

    // SPI initialization
    // SPI disabled
    SPCR=0x00;

    // TWI initialization
    // TWI disabled
    TWCR=0x00;
}

// Wait LCD
void wait_LCD(void)
{
   // Make Pin7 As Input
   PORTB.7 = 1;
   DDRB.7 = 0;
           
   // Make R/w as Read
   PORTB.1 = 1;
   // make RS as CMD
   PORTB.0 = 0;
   
   // Wait untill PINA.7 be 0
   //do
   //{
        PORTB.2 = 1; 
        delay_ms(1); 
        PORTB.2 = 0;     
  // }while(PINB.7 == 1);
   
   // Make Pin7 As OutPut
   DDRB.7 = 1;
}

// Send CMD to LCD
void Send_CMD(unsigned char cmd)
{
  //wait_LCD();
            
  // Make RS as Command
  PORTB.0 = 0;
  // Make It Write
  PORTB.1 = 0;
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= (cmd&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB.2 = 1;
  delay_ms(1);
  PORTB.2 = 0;
  
  //wait_LCD();
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= ((cmd<<4)&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB.2 = 1;
  delay_ms(1);
  PORTB.2 = 0;
}

// Send Data to LCD
void Send_Data(unsigned char data)
{
  // Wait LCD to be Free
  //wait_LCD();
            
  
  // Make RS as Data
  PORTB.0 = 1;
  // Make It Write
  PORTB.1 = 0;
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= (data&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB.2 = 1;
  delay_ms(1);
  PORTB.2 = 0;
  
  //wait_LCD();
  
  // Put CMD on PORT
  PORTB &= 0x0F;  // Make Data Nibble as 0000
  PORTB |= ((data<<4)&0xF0);
  
  // Update LCD
  // Make transition from High to Low
  PORTB.2 = 1;
  delay_ms(1);
  PORTB.2 = 0;
}


// Init LCD
void Init_LCD(void)
{
    delay_ms(20);
    // Init HW Ports
    // Data Port
    // Port A initialization
    // Make it all OutPut -> 0  
    PORTB=0x00;
    DDRB=0xFF;     
      
    ///////// Special Sequence /////// 
    // Set LCD as 4 Bits
    // Set RS -> 0 Command
    PORTB &= 0xFE;
    // Set R/W ->0 Write
    PORTB &= 0xFD;
    
    // Write Command to be 4 Bits Mode
    PORTB &= 0x0F;
    PORTB |= 0x30; 
    
    // Update LCD
    // Update LCD
    // Make transition from High to Low
    PORTB.2 = 1;
    delay_ms(1);
    PORTB.2 = 0;
    
    delay_ms(5);
    
    // Update LCD
    // Update LCD
    // Make transition from High to Low
    PORTB.2 = 1;
    delay_ms(1);
    PORTB.2 = 0;
    
    delay_ms(100);
    
    // Update LCD
    // Update LCD
    // Make transition from High to Low
    PORTB.2 = 1;
    delay_ms(1);
    PORTB.2 = 0;
    
    delay_ms(5);
    /////////////////////////////////
    
    // Set LCD as 4 Bits
    // Set RS -> 0 Command
    PORTB &= 0xFE;
    // Set R/W ->0 Write
    PORTB &= 0xFD;
    
    // Write Command to be 4 Bits Mode
    PORTB &= 0x0F;
    PORTB |= 0x20; 
    
    // Update LCD
    // Update LCD
    // Make transition from High to Low
    PORTB.2 = 1;
    delay_ms(1);
    PORTB.2 = 0;           
    
    // 2 Lines
    Send_CMD(0x28);
    // LCD On
    Send_CMD(0x0C);
}

void LCD_GotoXY(unsigned char X, unsigned char Y)
{
    if(Y==0)
    {
       Send_CMD(0x80+X);
    }
    else
    {
        Send_CMD(0x80 + X + 0x40);
    }
}

void main(void)
{
    // Init MCU
    Init_MCU();
    
    // Init LCD
    Init_LCD();
     
    LCD_GotoXY(0,0);
    // Disp Char M
    Send_Data('M');
    LCD_GotoXY(10,0);
    // Disp Char M
    Send_Data('M');
    LCD_GotoXY(0,1);
    // Disp Char M
    Send_Data('M');
    LCD_GotoXY(10,1);
    // Disp Char M
    Send_Data('M');
    
    while(1)
    {
        //Send_Data('M');
    }
 }