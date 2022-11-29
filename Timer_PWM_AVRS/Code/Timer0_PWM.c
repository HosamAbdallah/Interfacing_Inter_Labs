#include <avr/io.h>


int main(void)
{
  unsigned char count = 0;
  DDRB = 0x08;
  PORTB = 0x00;

  // Mode is Phase Correct PWM
  TCCR0 = 0x9D;
  // Duty Cycle 50%
  OCR0 = 128;
  // Reset Timer Counter Register
  TCNT0 = 0x00;
  // Disable Interrupts
  TIMSK = 0x00;

  while(1)
  {
	for(count=0; count<255; count++)
		OCR0 = count;
	for(count=255; count>0; count--)
		OCR0 = count;
  }
  return 0;
}
