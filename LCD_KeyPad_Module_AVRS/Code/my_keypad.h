#define NO_PRESSED_KEY 0xFF

#define ON_KEY 		15
#define SUB_KEY 	10
#define SUM_KEY		11
#define EQUAL_KEY	12
#define MUL_KEY		13
#define DIV_KEY		14


void KeyPad_Init(void);
unsigned char KeyPad_getKey(void);
