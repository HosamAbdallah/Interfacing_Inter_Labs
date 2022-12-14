
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADCSR=6;     
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

void Init_MCU(void)
{

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

UCSRB=0x00;

ACSR=0x80;
SFIOR=0x00;

ADCSRA=0x00;

SPCR=0x00;

TWCR=0x00;
}

void wait_LCD(void)
{

PORTB.7 = 1;
DDRB.7 = 0;

PORTB.1 = 1;

PORTB.0 = 0;

PORTB.2 = 1; 
delay_ms(1); 
PORTB.2 = 0;     

DDRB.7 = 1;
}

void Send_CMD(unsigned char cmd)
{

PORTB.0 = 0;

PORTB.1 = 0;

PORTB &= 0x0F;  
PORTB |= (cmd&0xF0);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;

PORTB &= 0x0F;  
PORTB |= ((cmd<<4)&0xF0);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;
}

void Send_Data(unsigned char data)
{

PORTB.0 = 1;

PORTB.1 = 0;

PORTB &= 0x0F;  
PORTB |= (data&0xF0);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;

PORTB &= 0x0F;  
PORTB |= ((data<<4)&0xF0);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;
}

void Init_LCD(void)
{
delay_ms(20);

PORTB=0x00;
DDRB=0xFF;     

PORTB &= 0xFE;

PORTB &= 0xFD;

PORTB &= 0x0F;
PORTB |= 0x30; 

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;

delay_ms(5);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;

delay_ms(100);

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;

delay_ms(5);

PORTB &= 0xFE;

PORTB &= 0xFD;

PORTB &= 0x0F;
PORTB |= 0x20; 

PORTB.2 = 1;
delay_ms(1);
PORTB.2 = 0;           

Send_CMD(0x28);

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

Init_MCU();

Init_LCD();

LCD_GotoXY(0,0);

Send_Data('M');
LCD_GotoXY(10,0);

Send_Data('M');
LCD_GotoXY(0,1);

Send_Data('M');
LCD_GotoXY(10,1);

Send_Data('M');

while(1)
{

}
}
