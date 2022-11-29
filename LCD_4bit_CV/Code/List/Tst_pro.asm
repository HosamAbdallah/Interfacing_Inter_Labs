
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
;// RS -> PORTB.0    RS-> 0 Command, RS-> 1 Data
;// R/W -> PORTB.1   R/w-> 0 Write, R/W-> 1 Read
;// E -> PORTB.2     E -> 1 then E-> 0
;
;
;void Init_MCU(void)
; 0000 000A {

	.CSEG
_Init_MCU:
; 0000 000B     // Input/Output Ports initialization
; 0000 000C     // Port A initialization
; 0000 000D     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 000E     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 000F     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0010     DDRA=0x00;
	OUT  0x1A,R30
; 0000 0011 
; 0000 0012     // Port B initialization
; 0000 0013     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0014     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0015     PORTB=0x00;
	OUT  0x18,R30
; 0000 0016     DDRB=0x00;
	OUT  0x17,R30
; 0000 0017 
; 0000 0018     // Port C initialization
; 0000 0019     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 001A     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 001B     PORTC=0x00;
	OUT  0x15,R30
; 0000 001C     DDRC=0x00;
	OUT  0x14,R30
; 0000 001D 
; 0000 001E     // Port D initialization
; 0000 001F     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0020     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0021     PORTD=0x00;
	OUT  0x12,R30
; 0000 0022     DDRD=0x00;
	OUT  0x11,R30
; 0000 0023 
; 0000 0024     // Timer/Counter 0 initialization
; 0000 0025     // Clock source: System Clock
; 0000 0026     // Clock value: Timer 0 Stopped
; 0000 0027     // Mode: Normal top=0xFF
; 0000 0028     // OC0 output: Disconnected
; 0000 0029     TCCR0=0x00;
	OUT  0x33,R30
; 0000 002A     TCNT0=0x00;
	OUT  0x32,R30
; 0000 002B     OCR0=0x00;
	OUT  0x3C,R30
; 0000 002C 
; 0000 002D     // Timer/Counter 1 initialization
; 0000 002E     // Clock source: System Clock
; 0000 002F     // Clock value: Timer1 Stopped
; 0000 0030     // Mode: Normal top=0xFFFF
; 0000 0031     // OC1A output: Discon.
; 0000 0032     // OC1B output: Discon.
; 0000 0033     // Noise Canceler: Off
; 0000 0034     // Input Capture on Falling Edge
; 0000 0035     // Timer1 Overflow Interrupt: Off
; 0000 0036     // Input Capture Interrupt: Off
; 0000 0037     // Compare A Match Interrupt: Off
; 0000 0038     // Compare B Match Interrupt: Off
; 0000 0039     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 003A     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 003B     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 003C     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 003D     ICR1H=0x00;
	OUT  0x27,R30
; 0000 003E     ICR1L=0x00;
	OUT  0x26,R30
; 0000 003F     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0040     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0041     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0042     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0043 
; 0000 0044     // Timer/Counter 2 initialization
; 0000 0045     // Clock source: System Clock
; 0000 0046     // Clock value: Timer2 Stopped
; 0000 0047     // Mode: Normal top=0xFF
; 0000 0048     // OC2 output: Disconnected
; 0000 0049     ASSR=0x00;
	OUT  0x22,R30
; 0000 004A     TCCR2=0x00;
	OUT  0x25,R30
; 0000 004B     TCNT2=0x00;
	OUT  0x24,R30
; 0000 004C     OCR2=0x00;
	OUT  0x23,R30
; 0000 004D 
; 0000 004E     // External Interrupt(s) initialization
; 0000 004F     // INT0: Off
; 0000 0050     // INT1: Off
; 0000 0051     // INT2: Off
; 0000 0052     MCUCR=0x00;
	OUT  0x35,R30
; 0000 0053     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0054 
; 0000 0055     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0056     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0057 
; 0000 0058     // USART initialization
; 0000 0059     // USART disabled
; 0000 005A     UCSRB=0x00;
	OUT  0xA,R30
; 0000 005B 
; 0000 005C     // Analog Comparator initialization
; 0000 005D     // Analog Comparator: Off
; 0000 005E     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 005F     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0060     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0061 
; 0000 0062     // ADC initialization
; 0000 0063     // ADC disabled
; 0000 0064     ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0065 
; 0000 0066     // SPI initialization
; 0000 0067     // SPI disabled
; 0000 0068     SPCR=0x00;
	OUT  0xD,R30
; 0000 0069 
; 0000 006A     // TWI initialization
; 0000 006B     // TWI disabled
; 0000 006C     TWCR=0x00;
	OUT  0x36,R30
; 0000 006D }
	RET
;
;// Wait LCD
;void wait_LCD(void)
; 0000 0071 {
; 0000 0072    // Make Pin7 As Input
; 0000 0073    PORTB.7 = 1;
; 0000 0074    DDRB.7 = 0;
; 0000 0075 
; 0000 0076    // Make R/w as Read
; 0000 0077    PORTB.1 = 1;
; 0000 0078    // make RS as CMD
; 0000 0079    PORTB.0 = 0;
; 0000 007A 
; 0000 007B    // Wait untill PINA.7 be 0
; 0000 007C    //do
; 0000 007D    //{
; 0000 007E         PORTB.2 = 1;
; 0000 007F         delay_ms(1);
; 0000 0080         PORTB.2 = 0;
; 0000 0081   // }while(PINB.7 == 1);
; 0000 0082 
; 0000 0083    // Make Pin7 As OutPut
; 0000 0084    DDRB.7 = 1;
; 0000 0085 }
;
;// Send CMD to LCD
;void Send_CMD(unsigned char cmd)
; 0000 0089 {
_Send_CMD:
; 0000 008A   //wait_LCD();
; 0000 008B 
; 0000 008C   // Make RS as Command
; 0000 008D   PORTB.0 = 0;
;	cmd -> Y+0
	CBI  0x18,0
; 0000 008E   // Make It Write
; 0000 008F   PORTB.1 = 0;
	RJMP _0x2000001
; 0000 0090 
; 0000 0091   // Put CMD on PORT
; 0000 0092   PORTB &= 0x0F;  // Make Data Nibble as 0000
; 0000 0093   PORTB |= (cmd&0xF0);
; 0000 0094 
; 0000 0095   // Update LCD
; 0000 0096   // Make transition from High to Low
; 0000 0097   PORTB.2 = 1;
; 0000 0098   delay_ms(1);
; 0000 0099   PORTB.2 = 0;
; 0000 009A 
; 0000 009B   //wait_LCD();
; 0000 009C 
; 0000 009D   // Put CMD on PORT
; 0000 009E   PORTB &= 0x0F;  // Make Data Nibble as 0000
; 0000 009F   PORTB |= ((cmd<<4)&0xF0);
; 0000 00A0 
; 0000 00A1   // Update LCD
; 0000 00A2   // Make transition from High to Low
; 0000 00A3   PORTB.2 = 1;
; 0000 00A4   delay_ms(1);
; 0000 00A5   PORTB.2 = 0;
; 0000 00A6 }
;
;// Send Data to LCD
;void Send_Data(unsigned char data)
; 0000 00AA {
_Send_Data:
; 0000 00AB   // Wait LCD to be Free
; 0000 00AC   //wait_LCD();
; 0000 00AD 
; 0000 00AE 
; 0000 00AF   // Make RS as Data
; 0000 00B0   PORTB.0 = 1;
;	data -> Y+0
	SBI  0x18,0
; 0000 00B1   // Make It Write
; 0000 00B2   PORTB.1 = 0;
_0x2000001:
	CBI  0x18,1
; 0000 00B3 
; 0000 00B4   // Put CMD on PORT
; 0000 00B5   PORTB &= 0x0F;  // Make Data Nibble as 0000
	RCALL SUBOPT_0x0
; 0000 00B6   PORTB |= (data&0xF0);
	RCALL SUBOPT_0x1
; 0000 00B7 
; 0000 00B8   // Update LCD
; 0000 00B9   // Make transition from High to Low
; 0000 00BA   PORTB.2 = 1;
; 0000 00BB   delay_ms(1);
; 0000 00BC   PORTB.2 = 0;
; 0000 00BD 
; 0000 00BE   //wait_LCD();
; 0000 00BF 
; 0000 00C0   // Put CMD on PORT
; 0000 00C1   PORTB &= 0x0F;  // Make Data Nibble as 0000
	RCALL SUBOPT_0x0
; 0000 00C2   PORTB |= ((data<<4)&0xF0);
	SWAP R30
	RCALL SUBOPT_0x1
; 0000 00C3 
; 0000 00C4   // Update LCD
; 0000 00C5   // Make transition from High to Low
; 0000 00C6   PORTB.2 = 1;
; 0000 00C7   delay_ms(1);
; 0000 00C8   PORTB.2 = 0;
; 0000 00C9 }
	ADIW R28,1
	RET
;
;
;// Init LCD
;void Init_LCD(void)
; 0000 00CE {
_Init_LCD:
; 0000 00CF     delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x2
; 0000 00D0     // Init HW Ports
; 0000 00D1     // Data Port
; 0000 00D2     // Port A initialization
; 0000 00D3     // Make it all OutPut -> 0
; 0000 00D4     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D5     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00D6 
; 0000 00D7     ///////// Special Sequence ///////
; 0000 00D8     // Set LCD as 4 Bits
; 0000 00D9     // Set RS -> 0 Command
; 0000 00DA     PORTB &= 0xFE;
	CBI  0x18,0
; 0000 00DB     // Set R/W ->0 Write
; 0000 00DC     PORTB &= 0xFD;
	CBI  0x18,1
; 0000 00DD 
; 0000 00DE     // Write Command to be 4 Bits Mode
; 0000 00DF     PORTB &= 0x0F;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 00E0     PORTB |= 0x30;
	IN   R30,0x18
	ORI  R30,LOW(0x30)
	OUT  0x18,R30
; 0000 00E1 
; 0000 00E2     // Update LCD
; 0000 00E3     // Update LCD
; 0000 00E4     // Make transition from High to Low
; 0000 00E5     PORTB.2 = 1;
	RCALL SUBOPT_0x3
; 0000 00E6     delay_ms(1);
; 0000 00E7     PORTB.2 = 0;
	CBI  0x18,2
; 0000 00E8 
; 0000 00E9     delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x2
; 0000 00EA 
; 0000 00EB     // Update LCD
; 0000 00EC     // Update LCD
; 0000 00ED     // Make transition from High to Low
; 0000 00EE     PORTB.2 = 1;
	RCALL SUBOPT_0x3
; 0000 00EF     delay_ms(1);
; 0000 00F0     PORTB.2 = 0;
	CBI  0x18,2
; 0000 00F1 
; 0000 00F2     delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x2
; 0000 00F3 
; 0000 00F4     // Update LCD
; 0000 00F5     // Update LCD
; 0000 00F6     // Make transition from High to Low
; 0000 00F7     PORTB.2 = 1;
	RCALL SUBOPT_0x3
; 0000 00F8     delay_ms(1);
; 0000 00F9     PORTB.2 = 0;
	CBI  0x18,2
; 0000 00FA 
; 0000 00FB     delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x2
; 0000 00FC     /////////////////////////////////
; 0000 00FD 
; 0000 00FE     // Set LCD as 4 Bits
; 0000 00FF     // Set RS -> 0 Command
; 0000 0100     PORTB &= 0xFE;
	CBI  0x18,0
; 0000 0101     // Set R/W ->0 Write
; 0000 0102     PORTB &= 0xFD;
	CBI  0x18,1
; 0000 0103 
; 0000 0104     // Write Command to be 4 Bits Mode
; 0000 0105     PORTB &= 0x0F;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
; 0000 0106     PORTB |= 0x20;
	SBI  0x18,5
; 0000 0107 
; 0000 0108     // Update LCD
; 0000 0109     // Update LCD
; 0000 010A     // Make transition from High to Low
; 0000 010B     PORTB.2 = 1;
	RCALL SUBOPT_0x3
; 0000 010C     delay_ms(1);
; 0000 010D     PORTB.2 = 0;
	CBI  0x18,2
; 0000 010E 
; 0000 010F     // 2 Lines
; 0000 0110     Send_CMD(0x28);
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _Send_CMD
; 0000 0111     // LCD On
; 0000 0112     Send_CMD(0x0C);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _Send_CMD
; 0000 0113 }
	RET
;
;void LCD_GotoXY(unsigned char X, unsigned char Y)
; 0000 0116 {
_LCD_GotoXY:
; 0000 0117     if(Y==0)
;	X -> Y+1
;	Y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x39
; 0000 0118     {
; 0000 0119        Send_CMD(0x80+X);
	LDD  R30,Y+1
	SUBI R30,-LOW(128)
	RJMP _0x3F
; 0000 011A     }
; 0000 011B     else
_0x39:
; 0000 011C     {
; 0000 011D         Send_CMD(0x80 + X + 0x40);
	LDD  R30,Y+1
	SUBI R30,-LOW(192)
_0x3F:
	ST   -Y,R30
	RCALL _Send_CMD
; 0000 011E     }
; 0000 011F }
	ADIW R28,2
	RET
;
;void main(void)
; 0000 0122 {
_main:
; 0000 0123     // Init MCU
; 0000 0124     Init_MCU();
	RCALL _Init_MCU
; 0000 0125 
; 0000 0126     // Init LCD
; 0000 0127     Init_LCD();
	RCALL _Init_LCD
; 0000 0128 
; 0000 0129     LCD_GotoXY(0,0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 012A     // Disp Char M
; 0000 012B     Send_Data('M');
; 0000 012C     LCD_GotoXY(10,0);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x4
; 0000 012D     // Disp Char M
; 0000 012E     Send_Data('M');
; 0000 012F     LCD_GotoXY(0,1);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x5
; 0000 0130     // Disp Char M
; 0000 0131     Send_Data('M');
; 0000 0132     LCD_GotoXY(10,1);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x5
; 0000 0133     // Disp Char M
; 0000 0134     Send_Data('M');
; 0000 0135 
; 0000 0136     while(1)
_0x3B:
; 0000 0137     {
; 0000 0138         //Send_Data('M');
; 0000 0139     }
	RJMP _0x3B
; 0000 013A  }
_0x3E:
	RJMP _0x3E

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OUT  0x18,R30
	IN   R30,0x18
	MOV  R26,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	SBI  0x18,2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	SBI  0x18,2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCD_GotoXY
	LDI  R30,LOW(77)
	ST   -Y,R30
	RJMP _Send_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LCD_GotoXY
	LDI  R30,LOW(77)
	ST   -Y,R30
	RJMP _Send_Data


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

;END OF CODE MARKER
__END_OF_CODE:
