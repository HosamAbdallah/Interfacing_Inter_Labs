#include <avr/io.h>

void UART_Init(void)
{
	// Set BaudRate -> 9600/8MhZ
	UBRRL = 51;
	UBRRH = 0;
	// Set Frame Formta -> 8 data, 1 stop, No Parity
	UCSRC = 0x86;
	// Enable RX and TX
	UCSRB = 0x18;
}

void UART_SendChar(unsigned char data)
{
	// Wait untill transmission Register Empty
	while((UCSRA&0x20) == 0x00);
	UDR = data;
}

unsigned char UART_GetChar(void)
{
	// Wait untill Reception Complete
	while((UCSRA&0x80) == 0x00);
	return UDR;
}

void UART_SendString(unsigned char *str)
{
	while(*str != '\0')
	{
		UART_SendChar(*str);
		str++;
	}
}

void UART_GetString(unsigned char *str)
{
	unsigned char temp = 0;
	do
	{
		temp = UART_GetChar();
		*str = temp;
		str++;
	}while(temp != '#');
	
	str--;
	*str = '\0';
}
