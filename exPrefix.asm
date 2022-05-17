.model small
.stack 200h
.data
Number dw 2020h
decimalDigStack db (5) dup (?)
.code
;Input: top stack element (n)
;Output: Prints the following lines:
;In the first line the whole number will appear in its decimal value.
;Next line - the number in its decimal value without its unity digit.
;In the next line - the number in its decimal value without the tens and ones digits, and so on.
;Until the last line is printed with the most significant digit of the number in its decimal value.
numPrefix proc uses dx bp si bx
	;Get AX = Number (parameter)
	mov bp, sp
	mov ax, [bp + 10]
	;Stopping condition: AX = 0
	cmp ax, 0
	je finish
	;Initialize counters
	mov si, 0 ;countes number of digits
	mov dx, 0
	;Push digits into decimalDigStack
	push ax
	call lastDigIntoStack
	pop ax
	;Print AX in decimal presentation
	call print
	call newline
	;Next Call
	mov bx, 10 	;initialize BX to 10
	xor dx, dx	;set DX to 0
	div bx		;AX = AX / 10
	push ax		;Pass new value by stack
	call numPrefix
finish:
	ret 2
numPrefix endp

;Input: AX
;Output: Array of AX value in decimal seperated by digits
lastDigIntoStack proc
	;Stopping condition: if AX is zero
	cmp ax, 0
	je DONE
	;Initialize bx to 10
	mov bx, 10       
	;Extract the last digit DX = remainder (modulus)
	div bx                 	 
	;Push it in the memorry
	mov decimalDigStack[si], dl            	 
	;increment the count of digits number
	inc si             	 
	;Set dx to 0
	xor dx, dx
	jmp NextCall
DONE:	;When stoping condition exists
	ret
NextCall:
	call lastDigIntoStack
lastDigIntoStack endp

;Input: decimalDigArr
;Output: print decimalDigArr to screen
print proc uses ax dx
	;Stopping condition: check if number of digits is greater than zero
	cmp si, 0
	je exit
	;Pop the top of stack memmory
	mov dl, decimalDigStack[si-1]
	;Add 48 so that it represents the ASCII value of digits
	add dl, 48
	;Interrupt to print a character
	mov ah, 02h
	int 21h
	;Decrease the count
	dec si
	
	call print ;Repeat
exit:
	ret
print endp

;Interupt printing DX value: 10d in ASCII code - LF
newline proc uses ax dx
	mov dl, 10	;Line feeding
	mov ah, 02h
	int 21h
	mov dl, 13	;Carriage return
	mov ah, 02h
	int 21h
	ret
newline endp

;Main Driver
main:
	.startup
	;Load the value stored in variable Nember into stack
	push ax
		mov ax, Number
		push ax
			call numPrefix
		pop ax
	pop ax
	.exit
end main
