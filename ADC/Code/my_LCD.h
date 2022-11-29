char* convertData(unsigned int var);
void LCD_Init(void);
void LCD_SendData(unsigned char data);
void LCD_Send_Command(unsigned char cmd);
void LCD_Clear(void);
void LCD_GotoXY(unsigned char x, unsigned char y);
void LCD_SendString(char *str);
void LCD_SendString_XY(char *str, unsigned char x, unsigned char y);
