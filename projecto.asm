.data 
#las variables con los mensajes a escribir
wlcom: .asciiz "Bienvenido a la calculadora de numeros grandres \n"
msg1: .asciiz "Porfavor ingrese el primer numero, con un signo de suma o resta en la primera posicion: \n"
msg2: .asciiz "El numero ingresado es:\n"
msg3: .asciiz "Las operaciones disponibles son:\n '-' para resta\n '+' para suma\n '*' para multiplicacion\nEscriba el signo de la operacion que desea hacer:" 
msg4: .asciiz "Porfavor ingrese el segundo numero, con un signo de suma o resta en la primera posicion: \n"
error1: .asciiz "Se ingreso un caracter invalido\n"

#vyckhy


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
	jal validar_digitos
	
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
	jal validar_digitos2
	
	#aqui crear un loop que evite que se ingrese alguna cadena que rompa el codigo (una funcion para repetir despues del segundo numero)
	li $v0, 10
	syscall
#metodo para insertar el signo de la operacion
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

#metodo para obtencion de los numeros
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
	
#metodo para duplicar el contenido del auxiliador a las variables necesarias
copiar:
	lb $t2, 0($t0)
	sb $t2, 0($t1)
	
	beq $t2, $zero, endcop
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j copiar
	endcop:
		jr $ra
		
		
#vyckhy
		
validar_digitos:#num1
	li $t0, 0 #entro y pingo el indice en 0
	
	validar_signo:
	#el +
	lb $t1, num1($t0)
	li $t2, '+'
	beq $t1, $t2, signo_ok
	#el -
	lb $t1, num1($t0)
	li $t3, '-'
	beq $t1, $t3, signo_ok
	#si no es ni + ni -
	j invalido
	
	signo_ok:
	li $t0, 1
	
	loopval:  #el loop de digitos
	lb $t1, num1($t0)
	beqz $t1, valido
	li $t4, 10
	beq $t1, $t4, valido
	blt $t1, '0', invalido
	bgt $t1, '9', invalido
	addi $t0, $t0, 1
	j loopval 
				
invalido: 
	li $v0, 4
	la $a0, error1
	syscall
	jr $ra
valido: 
	jr $ra	
	
validar_digitos2:#num2
	li $t0, 0 
	
	validar_signo2:
	#el +
	lb $t1, num2($t0)
	li $t2, '+'
	beq $t1, $t2, signo_ok2
	#el -
	lb $t1, num2($t0)
	li $t3, '-'
	beq $t1, $t3, signo_ok2
	#si no es ni + ni -
	j invalido2
	
	signo_ok2:
	li $t0, 1
	
	loopval2:
	lb $t1, num2($t0)
	beqz $t1, valido2
	li $t4, 10
        beq $t1, $t4, valido2
	blt $t1, '0', invalido2
	bgt $t1, '9', invalido2
	addi $t0, $t0, 1
	j loopval2 
				
invalido2: 
	li $v0, 4
	la $a0, error1
	syscall
	jr $ra
valido2: 
	jr $ra	
		
