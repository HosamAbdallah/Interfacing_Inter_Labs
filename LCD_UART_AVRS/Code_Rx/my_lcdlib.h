#ifndef _LCD_H_
#define _LCD_H_

void LCD_Init(void);
void LCD_DispChar(unsigned char data);
void LCD_SendCmd(unsigned char cmd);
void LCD_ClearAll(void);
void LCD_GotoXY(unsigned char x, unsigned char y);
void LCD_DispString(char *str);

#endif
