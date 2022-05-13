;This program clculates the GCD of an input array rucursevly

.model small
.stack 100h
.data
	result dw ?
	input_arr dw 3024, 1234, 1244, 44, 12414
	inputLen EQU 5
.code
;input: AX, BX
;output: swap(AX, BX)
swap proc
	xor ax, bx
	xor bx, ax
	xor ax, bx
swap endp

;input: AX, BX
;output: ds:result = GCD(AX, BX)
recGCD proc uses dx
	;stopping condition: if BX = 0 then return AX.
	cmp bx, 0
	jbe stop
	;AX = AX % BX
	mov dx, 0
	div bx 		;AX = (DX AX) / operand, DX = remainder (modulus)
	mov ax, dx 	;AX = remainder (modulus)
	;swap(AX, BX)
	call swap
	; Next Call:
	call recGCD
stop:
	mov result[0], ax
	ret
recGCD endp

;input: an array of words (DW) named arr_input, SI = array index, CX = array length 
;output: AX = GCD(input_arr)
arrGCD proc uses bx
	mov ax, input_arr[si]
	mov bx, result[0]
	add si, 2
	call recGCD
	;stopping condition: if CX = 0 then finish.
	dec cx
	jz finish
	; Next Call:
	call arrGCD
finish:
	mov ax, result[0]
	ret
arrGCD endp


main:
	;setting data segment
	mov ax, @data
	mov ds, ax

	;setting extra segment to screen memory
	mov ax, 0B800h
	mov es, ax
	
	mov si, 0 ;init array index.
	mov cx, inputLen
	call arrGCD
	
	
	add al, 30h				;offset from the exepted digit to in ASCII
	mov ah,0Fh				;writing to screen memory					
	mov es:[280h+98h], ax	;printing to the sreen 
	
	.exit
end main