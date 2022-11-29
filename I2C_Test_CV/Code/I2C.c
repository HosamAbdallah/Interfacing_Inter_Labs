#include <mega32.h>
#include <delay.h>

#define TW_MT_ARB_LOST   0x38
#define TW_MR_ARB_LOST   0x38
#define TW_START         0x08
#define TW_REP_START     0x10
#define TW_MT_SLA_ACK    0x18
#define TW_MT_DATA_ACK   0x28
#define TW_MR_DATA_NACK  0x58
#define TW_MR_SLA_NACK   0x48
#define TW_MT_SLA_NACK   0x20
#define TW_MT_DATA_NACK  0x30
#define TW_MR_DATA_ACK   0x50
#define TW_MR_SLA_ACK    0x40

// Init MCU Registers
void MCU_Init(void)
{
    // Input/Output Ports initialization
    // Port A initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTA=0x00;
    DDRA=0xFF;

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

void I2C_Init(void)
{
    // TWI initialization
    // Bit Rate: 400.000 kHz
    TWBR=0x02;
    // Two Wire Bus Slave Address: 0x1
    // General Call Recognition: Off
    TWAR=0x02;
    // Generate Acknowledge Pulse: On
    // TWI Interrupt: Off
    TWCR=0x44;
    TWSR=0x00;
}

void TWIStart(void)
{
    // Send Start Condition
    TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
    
    // Wait for TWINT flag set in TWCR Register 
    while (!(TWCR & (1 << TWINT)));
}

void TWIStop(void)
{
    // Send Stop Condition
    TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
}

void TWIWrite(unsigned char data)
{
    // Put data On TWI Register
    TWDR = data;
    // Send Data 
    TWCR = (1 << TWINT) | (1 << TWEN);
    // Wait for TWINT flag set in TWCR Register 
    while (!(TWCR & (1 << TWINT)));
}


unsigned char TWIReadACK(void)
{
    TWCR = (1 << TWINT) | (1 << TWEN) | (1<<TWEA);
    // Wait for TWINT flag set in TWCR Register 
    while (!(TWCR & (1 << TWINT)));
    // Read Data
    return TWDR;
}

unsigned char TWIReadNACK(void)
{
    TWCR = (1 << TWINT) | (1 << TWEN);
    // Wait for TWINT flag set in TWCR Register 
    while (!(TWCR & (1 << TWINT)));
    // Read Data
    return TWDR;
}

unsigned char TWIGetStatus(void)
{
    unsigned char status;
    status = TWSR & 0xF8;
    return status;
}

unsigned char EEPROM_WriteByte(unsigned int addr, unsigned char data)
{
    unsigned char state = 0;
    unsigned char _3MSBAddr = 0;
    
    // Start TWI
    TWIStart();
    // Get State
    state = TWIGetStatus();
    // Check if TWI Start
    if(state != TW_START)
        return 0;
    
    // Send Slave Address -> For EEPROM 24cXX
    // The Slave Address of Chip is 0b1010, so have Three bits free
    // We can take a part from 11 bit address and send it with Device Add
    // Send 3 MSBs From Address "As Device Address" 
    // Set Action To Write -> 0
    _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7)); 
    TWIWrite(0xA0|_3MSBAddr); 
    // Get Status
    state = TWIGetStatus();
    // Check if it is TW_MT_SLA_ACK
    if(state != TW_MT_SLA_ACK)
        return 0;
    
    // Write the Rest of Location Address(8 Bits)    
    TWIWrite((unsigned char) addr);
    // Get State
    state = TWIGetStatus(); 
    // check if it is TW_MT_DATA_ACK
    if(state != TW_MT_DATA_ACK)
        return 0;
    
    // Send Data
    TWIWrite(data);
    // Get Status
    state = TWIGetStatus();
    // Check if it is TW_MT_DATA_ACK
    if(state != TW_MT_DATA_ACK)
        return 0;
    
    // TWI Stop 
    TWIStop(); 
    // Return Done
    return 1;
}


unsigned char EEPROM_ReadByte(unsigned int addr, unsigned char *data)
{
    unsigned char state = 0;
    unsigned char _3MSBAddr = 0;
    
    // Start TWI
    TWIStart();
    // Get State
    state = TWIGetStatus();
    // Check if TWI Start
    if(state != TW_START)
        return 0;
    
    // Send Slave Address -> For EEPROM 24cXX
    // The Slave Address of Chip is 0b1010, so have Three bits free
    // We can take a part from 11 bit address and send it with Device Add
    // Send 3 MSBs From Address "As Device Address"  
    // Set Action to write -> 0
    _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7)); 
    TWIWrite(0xA0|_3MSBAddr); 
    // Get Status
    state = TWIGetStatus();
    // Check if it is TW_MT_SLA_ACK
    if(state != TW_MT_SLA_ACK)
        return 0;
    
    // Write the Rest of Location Address(8 Bits)    
    TWIWrite((unsigned char) addr);
    // Get State
    state = TWIGetStatus(); 
    // check if it is TW_MT_DATA_ACK
    if(state != TW_MT_DATA_ACK)
        return 0;
    
    // Now The Master Will Be Master Reciever
    
    // Now we need to Send Start Bit Again 
    // Start TWI
    TWIStart();
    // Get State
    state = TWIGetStatus();
    // Check if TW_REP_START
    if(state != TW_REP_START)
        return 0;
    
    // Send Slave Address -> For EEPROM 24cXX
    // The Slave Address of Chip is 0b1010, so have Three bits free
    // We can take a part from 11 bit address and send it with Device Add
    // Send 3 MSBs From Address "As Device Address"  
    // Set Action to Read -> 1
    _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7)); 
    TWIWrite(0xA0|_3MSBAddr|1); 
    // Get Status
    state = TWIGetStatus();
    // Check if it is TW_MR_SLA_ACK
    if(state != TW_MR_SLA_ACK)
        return 0; 
    
    // Read Data
    *data =  TWIReadNACK();
    // Get Status
    state = TWIGetStatus();
    // Check if it is 
    if(state != TW_MR_DATA_NACK)
        return 0;
    
   // TWI Stop 
   TWIStop(); 
   // Return Done
   return 1; 
}

void main(void)
{
    // Declare Variables
    unsigned char content = 0;
    // Init Functions
    MCU_Init();
    I2C_Init();
    
    EEPROM_WriteByte(0x0002, 0x58); 
    delay_ms(1000);
    EEPROM_ReadByte(0x0002, &content);
    PORTA = content;
    
    while(1)
    {
        // Infinte Loop
 
    }
}