ORG 0x7c00
BITS 16

;Welcome:
;	MOV ah,0x0e
;	MOV al,87
;	INT 10h
;	MOV al,69
;	INT 10h
;	MOV al,76
;	INT 10h
;	MOV al,67
;	INT 10h
;	MOV al,79
;	INT 10h
;	MOV al,77
;	INT 10h
;	MOV al,69
;	INT 10h
;space:
;	MOV al,32
;	INT 10h
	
;Kernel:
;	MOV al,84
;	INT 10h
;	MOV al,79
;	INT 10h
;	MOV al,32
;	INT 10h
	
	
;	MOV al,75
;	INT 10h
;	MOV al,69
;	INT 10h
;	MOV al,82
;	INT 10h
;	MOV al,78
;	INT 10h
;	MOV al,69
;	INT 10h
;	
;	MOV al,76
;	INT 10h

;newline:
;	MOV ah,0x0E
;	MOV al,10
;	INT 10h

;	MOV al,13
;	INT 10h


map:
	MOV ax,0x00
	MOV ss,ax
	MOV bp,0x9000
	XOR eax,eax
	XOR ebx,ebx
	XOR ecx,ecx
	XOR edx,edx
	
	
	memory_map:times 200 db 0



	 
        MOV di,memory_map
	MOV ax,ds
        MOV es,ax
      




	MOV eax,0xE820
	MOV ebx,0
	MOV ecx,24
	MOV edx ,0x534D4150
	
	
	INT 15h
	JC exit1

	
	MOV dx,0
hex:

	PUSH ebx
	PUSH eax
	PUSH ecx
	PUSH edx

	CMP dx,7
	JE h
	CMP dx,15
	JE h
	CMP dx,19
	JE h
	JMP retrieve
h:
	MOV ah,0x0e
	MOV al,32
	INT 10h	



	
retrieve:

	INC dx
	CMP dx,24
	JE exit
	ADD di,1
	MOV al,[es:di]

	MOV ch,al

	SHR ch,4

	MOV cl,al
	AND cl,0x0F

hex1:
	CMP ch,9
	JLE ah_lesser
	
	ADD ch,37h
	
hex2:

	CMP cl,9
	JLE  al_lesser
	
	ADD cl,37h
	JMP screening	
		

ah_lesser:
	ADD ch,0x30
	JMP hex2

al_lesser:
	ADD cl,0x30
	JMP screening


screening:
	MOV [bp],ch
	INC bp
	MOV [bp],cl
	INC bp
	MOV ah,0x0e
	MOV al,ch
	INT 10h
	MOV al,cl
	INT 10h
	JMP hex





exit:
	MOV ah,0X0e
	MOV al,10
	INT 10h
	MOV al,13
	INT 10h
	
	POP ecx
	POP edx
	POP eax
	MOV di,memory_map
	MOV ax,ds
	MOV es,ax
	XOR eax,eax
	XOR ecx,ecx
	XOR edx,edx
	XOR ebx,ebx
	POP ebx


	MOV eax,0xE820
	MOV ecx,24
	MOV edx,0x534D4150

	INT 15h
	JC exit1
	CMP ebx,0
	JE ebc
	MOV dx,0
	JMP hex
exit1:
	MOV ah,0x0e
	MOV al,102
	INT 10h
	JMP exit2
	
ebc:
	MOV ah,0x0E
	MOV al,69
	INT 10h
	

       




loading_second:
	MOV ax,0x00
	MOV es,ax
	MOV bx,0x1500
	MOV ah,0x02	
	MOV al,0x01
	MOV ch,0x00
	MOV cl,0x02
	MOV dh,0x0
	MOV dl,0x80
	INT 13h
	JMP far [_start]
times 510 - ($-$$) db 0
dw 0xAA55



exit2:

%include "boot8.s"


