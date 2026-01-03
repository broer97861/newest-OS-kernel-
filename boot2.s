BITS 16





global _start


_start:
	MOV ax,0B800h
        MOV es,ax
        MOV ah,0x00
        MOV al,0x03
        INT 10h
	MOV ah,0x02
	MOV bh,0x00
	MOV dh,0x0
	MOV dl,0x0
	INT 10h

	MOV ah,0x0e
        MOV al,72
        INT 10h
        MOV al,69
        INT 10h





gdt_start:
	
	
	XOR bp,bp
	MOV bp,0x800
	MOV ax,0
	MOV byte [bp],0x00
	INC bp
 	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	MOV byte [bp],0x00
        INC bp
	code_segment:

	MOV byte [bp],0xFF
	INC bp
	MOV byte [bp],0xFF
	INC bp
	

	MOV byte[bp] , 0x00
	INC bp
	MOV byte [bp],0x00	
	INC bp
	MOV byte[bp] , 0x00


	;access byte
	INC bp
	MOV byte [bp],0x9A
	INC bp
	MOV byte[bp],0xCF
	INC bp

	MOV byte[bp],0x00
	INC bp
	datasegment:

	;3rd entry
	MOV byte[bp],0xFF
	INC bp
	MOV byte [bp],0xFF
	
	MOV byte[bp],0x00
	INC bp
	MOV byte [bp],0x00
	INC bp


	MOV byte[bp] ,0x00
	INC bp

	MOV byte [bp],0x92
	INC bp

	MOV byte [bp],0xCF
	INC bp

	MOV byte [bp],0x00
	INC bp
	gdtend:
	MOV ax,ds
	MOV es,ax
	MOV bx,0x7E00
	

	

;for now .read 2 sectors as the kernel size grows increase the number of sectors you read and load 
	MOV ah,0x02
	MOV al,0x01
	MOV ch,0x00
	MOV cl,0x04
	MOV dh,0x00
	MOV dl,0x80
	INT 13h

	MOV ax,0x2401
	INT 15h
	JC now
	CMP ah,0x00
	JE address


	MOV ax,0x00
	MOV ds,ax
	MOV si,0x7e00
	
	MOV ax,0xFFFF
	MOV es,ax
	MOV di,0x0010
	MOV cx,512
	REP MOVSB







;0x100000 to 0x10FFEF for beyond 1mb
;Offset = Target Physical Address - 0xFFFF0


now:
	MOV ah,0x0e
	MOV al,69
	INT 10h

address:
	dw gdt_start - gdtend - 1
	dd gdt_start
	

loading:
	CLI 
	lgdt[address]

	MOV eax,cr0
	OR eax,1
	MOV cr0,eax
	JMP 0x08:dword protected_mode











BITS 32
protected_mode:
	
	times 1024 - ($-$$) db 0
	

	incbin "kernel.bin"
	JMP 0x0000:0x7e00

















