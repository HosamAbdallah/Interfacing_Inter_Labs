#include<avr/io.h>
#include<stdlib.h>
#include<util/delay.h>
#include "my_LCD.h"

#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
	// Delay needed for the stabilization of the ADC input voltage
	_delay_us(10);
	// Start the AD conversion
	ADCSRA|=0x40;
	// Wait for the AD conversion to complete
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCW;
}

// Declare your global variables here

int main(void)
{
	// Declare your local variables here
	unsigned int value = 200;
	double VinValue = 0;
    char* mycData;
	char temp[10];

	// ADC initialization
	// ADC Clock frequency: 1000.000 kHz
	// ADC Voltage Reference: AVCC pin
	// ADC Auto Trigger Source: Free Running
	ADMUX=ADC_VREF_TYPE & 0xff;
	ADCSRA=0xA3;
	SFIOR&=0x1F;

	LCD_Init();
	
	while (1)
	{
	      	// Place your code here
			LCD_Clear();
            // Read ADC Value
			value = read_adc(0);
			/* Now the Value contain number from 0 to 1023
             * So we Need to get the actual Voltage value
			 * as Vin = (ADC_Value * Vref) / 1024
			 */
            VinValue = ((float)(value * 5)) / 1024;
			// Display ADCW Value
			mycData = convertData(value);
			LCD_SendString_XY(mycData, 0, 0);
            // Display Floating Value
            dtostrf(VinValue, 5, 2, temp);
			LCD_SendString_XY(temp, 0, 1);
			_delay_ms(1000);
	}
	return 0;
}
