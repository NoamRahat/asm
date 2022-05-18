;This program clculates the GCD of an input array rucursevly
.model small
.stack 100h
.data
	result dw ?
	input_arr dw (2000) dup (2000, 1234, 3096, 12440, 2048)
	inputLen EQU 2000
.code

;Input: AX, BX
;Output: swap(AX, BX)
swap proc
	xor ax, bx
	xor bx, ax
	xor ax, bx
swap endp

;Input: AX, BX
;Output: ds:result = GCD(AX, BX)
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
	mov result, ax
	ret
recGCD endp

;Input: an array of words (DW) named arr_input, SI = array index, CX = array length 
;Output: AX = GCD(input_arr)
arrGCD proc uses bx
	mov ax, input_arr[si]
	mov bx, result
	add si, 2	;promote array index
	call recGCD
	;stopping condition: if CX = 0 then finish.
	dec cx
	jz finish
	; Next Call:
	call arrGCD
finish:
	mov ax, result
	ret
arrGCD endp

;Input: AX
;Otput: print AX (decimal) to screen
print proc uses dx ax
    mov dx, ax
    ;add 48 so that it represents the ASCII value of digits
    add dx, 48
    ;interrupt to print a character
    mov ah, 02h
    int 21h
	;Interupt printing DX value: 10d in ASCII code - LF
	mov dl, 10	;Line feeding
	mov ah, 02h
	int 21h
	mov dl, 13	;Carriage return
	mov ah, 02h
	int 21h
ret
print endp

main:
	.startup
	mov si, 0 ;init array index.
	mov cx, inputLen ;init array length.
	call arrGCD
	
	call print
	.exit
end main
