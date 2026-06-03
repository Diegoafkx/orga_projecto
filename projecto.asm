.data 
#las variables con los mensajes a escribir
wlcom: .asciiz "Bienvenido a la calculadora de numeros grandres \n"
msg1: .asciiz "Porfavor ingrese el primer numero, con un signo de suma o resta en la primera posicion: \n"
msg2: .asciiz "El numero ingresado es:\n"
msg3: .asciiz "Las operaciones disponibles son:\n '-' para resta\n '+' para suma\n '*' para multiplicacion\nEscriba el signo de la operacion que desea hacer:" 
msg4: .asciiz "Porfavor ingrese el segundo numero, con un signo de suma o resta en la primera posicion: \n"
error1: .asciiz "Se ingreso un caracter invalido\n"

aux: .space 51
num1 : .space 51
num2: .space 51
ope: .space 2
result: .space 52
.text

.globl main

main:	
	li $s0, 0
	#aqui se imprime el wlcom
	li $v0, 4
	la $a0, wlcom
	syscall
	
	jal ingresar_operador
	#aqui se imprime el msg1
	li $v0, 4
	la $a0, msg1
	syscall
	
	jal ingresar_numeros
	la $t0, aux
	la $t1, num1
		
	jal copiar
	
	#aqui se imprime el num1 escrito
	li $v0, 4
	la $a0, num1
	syscall
	#aqui se imprime el msg2
	li $v0, 4
	la $a0, msg2
	syscall
	#aqui se imprime el msg4
	li $v0, 4
	la $a0, msg4
	syscall
	#aqui se recibe el primer numero
	jal ingresar_numeros
	la $t0, aux
	la $t1, num2
	jal copiar
	
	#aqui crear un loop que evite que se ingrese alguna cadena que rompa el codigo (una funcion para repetir despues del segundo numero)
	li $v0, 10
	syscall

ingresar_operador:
	li $t0, 0
	li $t1, 1
	li $t2, '+'
	li $t3, '-'
	li $t4, '*'
	loopop:
		#aqui se imprime el msg3
		li $v0, 4
		la $a0, msg3
		syscall
		#aqui se recibe la operacion
		li $v0, 8
		la $a0, ope
		li $a1, 2
		syscall
		lb $t5, ope
		ifop:
			bne $t2, $t5, elseifop
			j endop
		elseifop:
			bne $t3, $t5, elseifop2
			j endop
		elseifop2:
			bne $t4, $t5, elseop
			li $s0, 1
			j endop
		elseop:
			li $v0, 4
			la $a0, error1
			syscall
			j loopop
	endop: 
		jr $ra

ingresar_numeros:
	#aqui se recibe el primer numero
	li $v0, 8
	la $a0, aux
	ifinn: 
	bne $zero, $s0, elseinn
		li $a1, 51
		j endinn
	elseinn:
		li $a1, 26
		j endinn
	endinn:
		syscall
		jr $ra
	
copiar:
	lb $t2, 0($t0)
	sb $t2, 0($t1)
	
	beq $t2, $zero, endcop
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j copiar
	endcop:
		jr $ra