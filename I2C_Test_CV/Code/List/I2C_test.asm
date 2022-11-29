
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
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
;#include <delay.h>
;
;#define MAX_TRIES 50
;
;#define I2C_START 0
;#define I2C_DATA 1
;#define I2C_STOP 2
;
;#define TW_MT_ARB_LOST   0x38
;#define TW_MR_ARB_LOST   0x38
;#define TW_START         0x08
;#define TW_REP_START     0x10
;#define TW_MT_SLA_ACK    0x18
;#define TW_MT_DATA_ACK   0x28
;#define TW_MR_DATA_NACK  0x58
;#define TW_MR_SLA_NACK   0x48
;#define TW_MT_SLA_NACK   0x20
;#define TW_MT_DATA_NACK  0x30
;#define TW_MR_DATA_ACK   0x50
;#define TW_MR_SLA_ACK    0x40
;
;#define TW_WRITE         0
;#define TW_READ          1
;
;// Init MCU Registers
;void MCU_Init(void)
; 0000 001C {

	.CSEG
_MCU_Init:
; 0000 001D     // Input/Output Ports initialization
; 0000 001E     // Port A initialization
; 0000 001F     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0020     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0021     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0022     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0023 
; 0000 0024     // Port B initialization
; 0000 0025     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0026     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0027     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0028     DDRB=0x00;
	OUT  0x17,R30
; 0000 0029 
; 0000 002A     // Port C initialization
; 0000 002B     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 002C     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 002D     PORTC=0x00;
	OUT  0x15,R30
; 0000 002E     DDRC=0x00;
	OUT  0x14,R30
; 0000 002F 
; 0000 0030     // Port D initialization
; 0000 0031     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0032     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0033     PORTD=0x00;
	OUT  0x12,R30
; 0000 0034     DDRD=0x00;
	OUT  0x11,R30
; 0000 0035 
; 0000 0036     // Timer/Counter 0 initialization
; 0000 0037     // Clock source: System Clock
; 0000 0038     // Clock value: Timer 0 Stopped
; 0000 0039     // Mode: Normal top=0xFF
; 0000 003A     // OC0 output: Disconnected
; 0000 003B     TCCR0=0x00;
	OUT  0x33,R30
; 0000 003C     TCNT0=0x00;
	OUT  0x32,R30
; 0000 003D     OCR0=0x00;
	OUT  0x3C,R30
; 0000 003E 
; 0000 003F     // Timer/Counter 1 initialization
; 0000 0040     // Clock source: System Clock
; 0000 0041     // Clock value: Timer1 Stopped
; 0000 0042     // Mode: Normal top=0xFFFF
; 0000 0043     // OC1A output: Discon.
; 0000 0044     // OC1B output: Discon.
; 0000 0045     // Noise Canceler: Off
; 0000 0046     // Input Capture on Falling Edge
; 0000 0047     // Timer1 Overflow Interrupt: Off
; 0000 0048     // Input Capture Interrupt: Off
; 0000 0049     // Compare A Match Interrupt: Off
; 0000 004A     // Compare B Match Interrupt: Off
; 0000 004B     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 004C     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 004D     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 004E     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 004F     ICR1H=0x00;
	OUT  0x27,R30
; 0000 0050     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0051     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0052     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0053     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0054     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0055 
; 0000 0056     // Timer/Counter 2 initialization
; 0000 0057     // Clock source: System Clock
; 0000 0058     // Clock value: Timer2 Stopped
; 0000 0059     // Mode: Normal top=0xFF
; 0000 005A     // OC2 output: Disconnected
; 0000 005B     ASSR=0x00;
	OUT  0x22,R30
; 0000 005C     TCCR2=0x00;
	OUT  0x25,R30
; 0000 005D     TCNT2=0x00;
	OUT  0x24,R30
; 0000 005E     OCR2=0x00;
	OUT  0x23,R30
; 0000 005F 
; 0000 0060     // External Interrupt(s) initialization
; 0000 0061     // INT0: Off
; 0000 0062     // INT1: Off
; 0000 0063     // INT2: Off
; 0000 0064     MCUCR=0x00;
	OUT  0x35,R30
; 0000 0065     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0066 
; 0000 0067     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0068     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0069 
; 0000 006A     // USART initialization
; 0000 006B     // USART disabled
; 0000 006C     UCSRB=0x00;
	OUT  0xA,R30
; 0000 006D 
; 0000 006E     // Analog Comparator initialization
; 0000 006F     // Analog Comparator: Off
; 0000 0070     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0071     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0072     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0073 
; 0000 0074     // ADC initialization
; 0000 0075     // ADC disabled
; 0000 0076     ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0077 
; 0000 0078     // SPI initialization
; 0000 0079     // SPI disabled
; 0000 007A     SPCR=0x00;
	OUT  0xD,R30
; 0000 007B 
; 0000 007C     // TWI initialization
; 0000 007D     // TWI disabled
; 0000 007E     TWCR=0x00;
	RJMP _0x2000003
; 0000 007F }
;
;void I2C_Init(void)
; 0000 0082 {
_I2C_Init:
; 0000 0083     // TWI initialization
; 0000 0084     // Bit Rate: 400.000 kHz
; 0000 0085     TWBR=0x02;
	LDI  R30,LOW(2)
	OUT  0x0,R30
; 0000 0086     // Two Wire Bus Slave Address: 0x1
; 0000 0087     // General Call Recognition: Off
; 0000 0088     TWAR=0x02;
	OUT  0x2,R30
; 0000 0089     // Generate Acknowledge Pulse: On
; 0000 008A     // TWI Interrupt: Off
; 0000 008B     TWCR=0x44;
	LDI  R30,LOW(68)
	OUT  0x36,R30
; 0000 008C     TWSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 008D }
	RET
;
;void TWIStart(void)
; 0000 0090 {
_TWIStart:
; 0000 0091     // Send Start Condition
; 0000 0092     TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0000 0093 
; 0000 0094     // Wait for TWINT flag set in TWCR Register
; 0000 0095     while (!(TWCR & (1 << TWINT)));
_0x3:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x3
; 0000 0096 }
	RET
;
;void TWIStop(void)
; 0000 0099 {
_TWIStop:
; 0000 009A     // Send Stop Condition
; 0000 009B     TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO);
	LDI  R30,LOW(148)
_0x2000003:
	OUT  0x36,R30
; 0000 009C }
	RET
;
;void TWIWrite(unsigned char data)
; 0000 009F {
_TWIWrite:
; 0000 00A0     // Put data On TWI Register
; 0000 00A1     TWDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
; 0000 00A2     // Send Data
; 0000 00A3     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 00A4     // Wait for TWINT flag set in TWCR Register
; 0000 00A5     while (!(TWCR & (1 << TWINT)));
_0x6:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x6
; 0000 00A6 }
	ADIW R28,1
	RET
;
;
;unsigned char TWIReadACK(void)
; 0000 00AA {
; 0000 00AB     TWCR = (1 << TWINT) | (1 << TWEN) | (1<<TWEA);
; 0000 00AC     // Wait for TWINT flag set in TWCR Register
; 0000 00AD     while (!(TWCR & (1 << TWINT)));
; 0000 00AE     // Read Data
; 0000 00AF     return TWDR;
; 0000 00B0 }
;
;unsigned char TWIReadNACK(void)
; 0000 00B3 {
_TWIReadNACK:
; 0000 00B4     TWCR = (1 << TWINT) | (1 << TWEN);
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0000 00B5     // Wait for TWINT flag set in TWCR Register
; 0000 00B6     while (!(TWCR & (1 << TWINT)));
_0xC:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0xC
; 0000 00B7     // Read Data
; 0000 00B8     return TWDR;
	IN   R30,0x3
	RET
; 0000 00B9 }
;
;unsigned char TWIGetStatus(void)
; 0000 00BC {
_TWIGetStatus:
; 0000 00BD     unsigned char status;
; 0000 00BE     status = TWSR & 0xF8;
	ST   -Y,R17
;	status -> R17
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0000 00BF     return status;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00C0 }
;
;unsigned char EEPROM_WriteByte(unsigned int addr, unsigned char data)
; 0000 00C3 {
_EEPROM_WriteByte:
; 0000 00C4     unsigned char state = 0;
; 0000 00C5     unsigned char _3MSBAddr = 0;
; 0000 00C6 
; 0000 00C7     // Start TWI
; 0000 00C8     TWIStart();
	RCALL SUBOPT_0x0
;	addr -> Y+3
;	data -> Y+2
;	state -> R17
;	_3MSBAddr -> R16
; 0000 00C9     // Get State
; 0000 00CA     state = TWIGetStatus();
; 0000 00CB     // Check if TWI Start
; 0000 00CC     if(state != TW_START)
	BREQ _0xF
; 0000 00CD         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 00CE 
; 0000 00CF     // Send Slave Address -> For EEPROM 24cXX
; 0000 00D0     // The Slave Address of Chip is 0b1010, so have Three bits free
; 0000 00D1     // We can take a part from 11 bit address and send it with Device Add
; 0000 00D2     // Send 3 MSBs From Address "As Device Address"
; 0000 00D3     // Set Action To Write -> 0
; 0000 00D4     _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7));
_0xF:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	RCALL SUBOPT_0x1
; 0000 00D5     TWIWrite(0xA0|_3MSBAddr);
; 0000 00D6     // Get Status
; 0000 00D7     state = TWIGetStatus();
; 0000 00D8     // Check if it is TW_MT_SLA_ACK
; 0000 00D9     if(state != TW_MT_SLA_ACK)
	BREQ _0x10
; 0000 00DA         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 00DB 
; 0000 00DC     // Write the Rest of Location Address(8 Bits)
; 0000 00DD     TWIWrite((unsigned char) addr);
_0x10:
	LDD  R30,Y+3
	RCALL SUBOPT_0x2
; 0000 00DE     // Get State
; 0000 00DF     state = TWIGetStatus();
; 0000 00E0     // check if it is TW_MT_DATA_ACK
; 0000 00E1     if(state != TW_MT_DATA_ACK)
	BREQ _0x11
; 0000 00E2         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 00E3 
; 0000 00E4     // Send Data
; 0000 00E5     TWIWrite(data);
_0x11:
	LDD  R30,Y+2
	RCALL SUBOPT_0x2
; 0000 00E6     // Get Status
; 0000 00E7     state = TWIGetStatus();
; 0000 00E8     // Check if it is TW_MT_DATA_ACK
; 0000 00E9     if(state != TW_MT_DATA_ACK)
	BREQ _0x12
; 0000 00EA         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 00EB 
; 0000 00EC     // TWI Stop
; 0000 00ED     TWIStop();
_0x12:
	RCALL _TWIStop
; 0000 00EE     // Return Done
; 0000 00EF     return 1;
	LDI  R30,LOW(1)
_0x2000002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; 0000 00F0 }
;
;
;unsigned char EEPROM_ReadByte(unsigned int addr, unsigned char *data)
; 0000 00F4 {
_EEPROM_ReadByte:
; 0000 00F5     unsigned char state = 0;
; 0000 00F6     unsigned char _3MSBAddr = 0;
; 0000 00F7 
; 0000 00F8     // Start TWI
; 0000 00F9     TWIStart();
	RCALL SUBOPT_0x0
;	addr -> Y+4
;	*data -> Y+2
;	state -> R17
;	_3MSBAddr -> R16
; 0000 00FA     // Get State
; 0000 00FB     state = TWIGetStatus();
; 0000 00FC     // Check if TWI Start
; 0000 00FD     if(state != TW_START)
	BREQ _0x13
; 0000 00FE         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 00FF 
; 0000 0100     // Send Slave Address -> For EEPROM 24cXX
; 0000 0101     // The Slave Address of Chip is 0b1010, so have Three bits free
; 0000 0102     // We can take a part from 11 bit address and send it with Device Add
; 0000 0103     // Send 3 MSBs From Address "As Device Address"
; 0000 0104     // Set Action to write -> 0
; 0000 0105     _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7));
_0x13:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x1
; 0000 0106     TWIWrite(0xA0|_3MSBAddr);
; 0000 0107     // Get Status
; 0000 0108     state = TWIGetStatus();
; 0000 0109     // Check if it is TW_MT_SLA_ACK
; 0000 010A     if(state != TW_MT_SLA_ACK)
	BREQ _0x14
; 0000 010B         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 010C 
; 0000 010D     // Write the Rest of Location Address(8 Bits)
; 0000 010E     TWIWrite((unsigned char) addr);
_0x14:
	LDD  R30,Y+4
	RCALL SUBOPT_0x2
; 0000 010F     // Get State
; 0000 0110     state = TWIGetStatus();
; 0000 0111     // check if it is TW_MT_DATA_ACK
; 0000 0112     if(state != TW_MT_DATA_ACK)
	BREQ _0x15
; 0000 0113         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 0114 
; 0000 0115     // Now The Master Will Be Master Reciever
; 0000 0116 
; 0000 0117     // Now we need to Send Start Bit Again
; 0000 0118     // Start TWI
; 0000 0119     TWIStart();
_0x15:
	RCALL _TWIStart
; 0000 011A     // Get State
; 0000 011B     state = TWIGetStatus();
	RCALL _TWIGetStatus
	MOV  R17,R30
; 0000 011C     // Check if TW_REP_START
; 0000 011D     if(state != TW_REP_START)
	CPI  R17,16
	BREQ _0x16
; 0000 011E         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 011F 
; 0000 0120     // Send Slave Address -> For EEPROM 24cXX
; 0000 0121     // The Slave Address of Chip is 0b1010, so have Three bits free
; 0000 0122     // We can take a part from 11 bit address and send it with Device Add
; 0000 0123     // Send 3 MSBs From Address "As Device Address"
; 0000 0124     // Set Action to Read -> 1
; 0000 0125     _3MSBAddr = ((unsigned char) ((addr&0x0700)>>7));
_0x16:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ANDI R30,LOW(0x700)
	ANDI R31,HIGH(0x700)
	CALL __LSRW3
	CALL __LSRW4
	MOV  R16,R30
; 0000 0126     TWIWrite(0xA0|_3MSBAddr|1);
	MOV  R30,R16
	ORI  R30,LOW(0xA1)
	ST   -Y,R30
	RCALL _TWIWrite
; 0000 0127     // Get Status
; 0000 0128     state = TWIGetStatus();
	RCALL _TWIGetStatus
	MOV  R17,R30
; 0000 0129     // Check if it is TW_MR_SLA_ACK
; 0000 012A     if(state != TW_MR_SLA_ACK)
	CPI  R17,64
	BREQ _0x17
; 0000 012B         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 012C 
; 0000 012D     // Read Data
; 0000 012E     *data =  TWIReadNACK();
_0x17:
	RCALL _TWIReadNACK
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
; 0000 012F     // Get Status
; 0000 0130     state = TWIGetStatus();
	RCALL _TWIGetStatus
	MOV  R17,R30
; 0000 0131     // Check if it is
; 0000 0132     if(state != TW_MR_DATA_NACK)
	CPI  R17,88
	BREQ _0x18
; 0000 0133         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000001
; 0000 0134 
; 0000 0135    // TWI Stop
; 0000 0136    TWIStop();
_0x18:
	RCALL _TWIStop
; 0000 0137    // Return Done
; 0000 0138    return 1;
	LDI  R30,LOW(1)
_0x2000001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 0139 }
;
;void main(void)
; 0000 013C {
_main:
; 0000 013D     // Declare Variables
; 0000 013E     unsigned char content = 0;
; 0000 013F     // Init Functions
; 0000 0140     MCU_Init();
;	content -> R17
	LDI  R17,0
	RCALL _MCU_Init
; 0000 0141     I2C_Init();
	RCALL _I2C_Init
; 0000 0142 
; 0000 0143     EEPROM_WriteByte(0x0002, 0x58);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(88)
	ST   -Y,R30
	RCALL _EEPROM_WriteByte
; 0000 0144     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0145     EEPROM_ReadByte(0x0002, &content);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	RCALL _EEPROM_ReadByte
	POP  R17
; 0000 0146     PORTA = content;
	OUT  0x1B,R17
; 0000 0147 
; 0000 0148     while(1)
_0x19:
; 0000 0149     {
; 0000 014A         // Infinte Loop
; 0000 014B 
; 0000 014C     }
	RJMP _0x19
; 0000 014D }
_0x1C:
	RJMP _0x1C

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R17,0
	LDI  R16,0
	RCALL _TWIStart
	RCALL _TWIGetStatus
	MOV  R17,R30
	CPI  R17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	ANDI R30,LOW(0x700)
	ANDI R31,HIGH(0x700)
	CALL __LSRW3
	CALL __LSRW4
	MOV  R16,R30
	MOV  R30,R16
	ORI  R30,LOW(0xA0)
	ST   -Y,R30
	RCALL _TWIWrite
	RCALL _TWIGetStatus
	MOV  R17,R30
	CPI  R17,24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	RCALL _TWIWrite
	RCALL _TWIGetStatus
	MOV  R17,R30
	CPI  R17,40
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
