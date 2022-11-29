#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    // Init Code
	DDRA = 0x01;
	PORTA = 0x00;

    while(1)
	{ 
         PORTA = PORTA ^ 0x01;
		 _delay_ms(1000);
	}
 	return 0;
}
