.data 
#las variables con los mensajes a escribir
wlcom: .asciiz "Bienvenido a la calculadora de numeros grandres \n"
msg1: .asciiz "\nPorfavor ingrese el primer numero, con un signo de suma o resta en la primera posicion: \n"
msg2: .asciiz "\nEl numero ingresado es:\n"
msg3: .asciiz "Las operaciones disponibles son:\n '-' para resta\n '+' para suma\n '*' para multiplicacion\nEscriba el signo de la operacion que desea hacer:\n" 
msg4: .asciiz "Porfavor ingrese el segundo numero, con un signo de suma o resta en la primera posicion: \n"
error1: .asciiz "Se ingreso un caracter invalido\n"
resultado: .asciiz "El resultado de la operacion es:\n"
 

salto: .asciiz "\n"
aux1: .word '0'
aux: .space 51
num1 : .space 51
num2: .space 51
ope: .space 2
result: .space 52

error2: .asciiz "Solo se permiten 25 digitos como máximo.\n"
temp: .space 52
aux2: .space 52

.text
 
	
.globl main
main:	
	li $s0, 0
	li $s1, '+'
	li $s2, '-'
	li $s3, '*'
	li $s4, 0
	li $s5, 0
	li $s6, 0
	#aqui se imprime el wlcom
	li $v0, 4
	la $a0, wlcom
	syscall
	
	jal ingresar_operador
	#aqui se imprime el msg1
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $s6, 0
	jal validar_digitos
	la $t0, aux
	la $t1, num1
	li $t3, 0
	jal copiar
	move $s4, $t3
	#aqui se imprime el msg2
	li $v0, 4
	la $a0, msg2
	syscall
	#aqui se imprime el num1 escrito
	li $v0, 4
	la $a0, num1
	syscall
	#aqui se imprime el msg4
	li $v0, 4
	la $a0, msg4
	syscall
	
	#aqui se recibe el segundo numero
	li $s6, 1
	jal validar_digitos
	la $t0, aux
	la $t1, num2
	li $t3, 0
	jal copiar
	move $s5, $t3
	#aqui se imprime el msg2
	li $v0, 4
	la $a0, msg2
	syscall
	#aqui se imprime el num1 escrito
	li $v0, 4
	la $a0, num2
	syscall
	li $v0, 4
	la $a0, salto
	syscall
	lb $t5, ope
	bne $s1, $t5, restar
	jal suma
	
	j end_main
	restar:
		bne $s2, $t5, multiplicacion
		jal resta
		j end_main
	multiplicacion:
		jal multiplicar
		j end_main
	end_main:
		li $v0, 4
		la $a0, resultado
		syscall
		li $v0, 4
		la $a0, result
		syscall
		li $v0, 10
		syscall
	
	
#metodo para insertar el signo de la operacion
ingresar_operador:
	li $t0, 0
	li $t1, 1
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
			bne $s1, $t5, elseifop
			j endop
		elseifop:
			bne $s2, $t5, elseifop2
			j endop
		elseifop2:
			bne $s3, $t5, elseop
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
		li $a1, 27
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
	addi $t3, $t3, 1
	j copiar
	endcop:
		addi $t3, $t3, -1
		jr $ra	
		

validar_digitos:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	pedirdenuevo:
	jal ingresar_numeros
	li $t0, 0
	lb $t1, aux($t0)
	beq $t1, $s1, loopval
	beq $t1, $s2, loopval
	j invalido
	loopval:
		addi $t0, $t0, 1
		lb $t1, aux($t0)
		beq $t1, $zero, validar_longitud
		beq $t1, 10, limpiar_salto
		blt $t1, '0', invalido
		bgt $t1, '9', invalido
		j loopval 
	limpiar_salto:
		sb $zero, aux($t0)
		j valido
	validar_longitud:
		beq $s0, $zero, valido
		addi $t2, $t0, -1
		li $t3, 25
		ble $t2, $t3, valido
		li $v0, 4
		la $a0, error2
		syscall
		j invalido

	invalido: 
		li $v0, 4
		la $a0, error1
		syscall
		bne $s6, $zero, pedir_num2
		li $v0, 4
		la $a0, msg1
		syscall
		j pedirdenuevo
		pedir_num2:
			li $v0, 4
			la $a0, msg4
			syscall
			j pedirdenuevo
	valido: 
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
suma:
	li $t9,0
	li $t8, 2 #para indicar si se resta o se le suma uno al numero
	bge $s4, $s5, seguir_suma
	li $t0, 1
	lb $t1, num1($t0)
	lb $t2, num2($t0)
	bge $t1, $t2, seguir_suma
	li $t9, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $t3, $a0
	move $s4, $s5
	move $s5, $t3
	la $t0, num1
	la $t1, aux
	li $t3, 0
	jal copiar
	la $t0, num2
	la $t1, num1
	li $t3, 0
	jal copiar
	la $t0, aux
	la $t1, num2
	li $t3, 0
	jal copiar
	move $t6, $s4 #t6 es para aux el metodo mayor a 10
	seguir_suma:
		li $t0, 0
		lb $t1, num1($t0)
		lb $t2, num2($t0)
		li $t0, -1 
		loop_suma:
			addi $s4, $s4, -1
			blez $s4, end_loop_suma #condicion para terminar la suma
			lb $t3, num1($s4)
			beq $t3, $zero, end_loop_suma #condicion para terminar la suma
			addi $t3, $t3, -48
			addi $s5, $s5, -1
			li $t4, 0
			bltz $s5, aux_loop_suma #por si el numero de abajo ya se acabo
			lb $t4, num2($s5)
			addi $t4, $t4, -48
			aux_loop_suma:
				li $t5, 0 
			beq $t8, 2, revisionnum1 #caso para saber si hay que sumar
			bnez $t8, restar_dies #caso para saber si hay que restar
			addi $t3, $t3, 1
			li $t8, 2	
			j revisionnum1
			restar_dies: #caso para saber si hay que restar
				beq $t8, 2, revisionnum1
				addi $t3, $t3, -1
				li $t8, 2
			revisionnum1: #para saber si es negativo el numero
				bgt $t3, $t4, arreglarsignonum1
				bne $s2, $t2, arreglarsignonum1
				addi $t3, $t3 ,10 
				li $t8, 1
				arreglarsignonum1:
					bne $s2, $t1, revisionnum2
					mul $t3, $t3, -1
			revisionnum2: #para saber si es negativo el numero
				bne $s2, $t2, suma_num
				mul $t4, $t4, -1
			bgt $t4, $t3, suma_num
			suma_num:
				add $t5, $t3, $t4
				bge $t5, 10, mayor_a_dies #para saber si es mayor a 10
				ble $t5, -1, menor_a_cero #si es negativo
				j acoplar_en_resultado
			menor_a_cero:
				bge $t5, -10, aux_menor_a_cero
				add $t5, $t5, 10
				aux_menor_a_cero:
					mul $t5, $t5, -1
					bge $t5, $t3, revision_signo #para saber si mayoral primer numero, en casos de restas
					j acoplar_en_resultado
			mayor_a_dies:
				li $t8, 0
				add $t7, $s4, $t6
				beqz $t7, acoplar_en_resultado
				addi $t5, $t5, -10
			revision_signo:
				bne $s2, $t1, acoplar_en_resultado
				li $t8, 1
				acoplar_en_resultado:
					addi $t5, $t5, 48
					sb $t5, result($s4)
					j loop_suma
		end_loop_suma:
			bnez $t8, salir_suma
			li $t5, 49
			addi $s4, $s4, -1
			sb $t5, result($s4)
			salir_suma:
				sb $t1, result($s4)
				beqz $t9, salida_suma
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				salida_suma:
				jr $ra
				

resta:
	li $t0, 0
	limpiar_result:
	sb $zero, result($t0)
	addi $t0, $t0, 1
	blt $t0, 52, limpiar_result
	lb $t6, num1
	lb $t7, num2
	beq $t6, $t7, signos_iguales
	li $s6, 0
	j ver_mayor
	signos_iguales:
	li $s6, 1
	ver_mayor:
	bgt $s4, $s5, num1_mayor 
	blt $s4, $s5, num2_mayor 
	li $t0, 1 
	comparar_digitos:
	bgt $t0, $s4, son_iguales
	lb $t1, num1($t0)
	lb $t2, num2($t0) 
	bgt $t1, $t2, num1_mayor 
	blt $t1, $t2, num2_mayor 
	addi $t0, $t0, 1
	j comparar_digitos 
	num1_mayor:
	li $s7, 1          
	j fin_comparar
	num2_mayor:
	li $s7, 2
	j fin_comparar
	son_iguales:
	li $s7, 0          
	fin_comparar:
	beq $s6, 0, sumar_magnitudes
	beq $s7, 2, restar_num2
	la $t8, num1
	la $t9, num2
	move $t0, $s4
	move $t7, $s5
	j preparar_resta
	restar_num2:
	la $t8, num2
	la $t9, num1
	move $t0, $s5
	move $t7, $s4
	preparar_resta:
	li $t3, 0
	li $t4, 51
	loop_resta:
	blez $t0, fin_resta 
	add $t1, $t8, $t0
	lb $t1, 0($t1)
	addi $t1, $t1, -48
	li $t2, 0
	blez $t7, salto_abajo
	add $t2, $t9, $t7
	lb $t2, 0($t2)
	addi $t2, $t2, -48
		salto_abajo:
		sub $t5, $t1, $t2
		sub $t5, $t5, $t3
		li $t3, 0
		bgez $t5, sin_prestamo
		addi $t5, $t5, 10
		li $t3, 1
		sin_prestamo:
		addi $t5, $t5, 48
		sb $t5, result($t4)
		addi $t4, $t4, -1
		addi $t0, $t0, -1
		addi $t7, $t7, -1
		j loop_resta
	fin_resta:
	j poner_signo
	sumar_magnitudes:
	move $t0, $s4
	move $t7, $s5
	li $t3, 0
	li $t4, 51
	loopsuma:
	blez $t0, finsuma
	li $t1, 0
	lb $t1, num1($t0)
	addi $t1, $t1, -48
	revisarnum2:
	li $t2, 0
	blez $t7, sumar_digitos
	lb $t2, num2($t7)
	addi $t2, $t2, -48
	sumar_digitos:
	add $t5, $t1, $t2
	add $t5, $t5, $t3
	li $t3, 0
	blt $t5, 10, sin_acarreo
	addi $t5, $t5, -10
	li $t3, 1
	sin_acarreo:
	addi $t5, $t5, 48
	sb $t5, result($t4)
	addi $t4, $t4, -1
	addi $t0, $t0, -1
	addi $t7, $t7, -1
	j loopsuma
	finsuma:
	blez $t7, revisar_acarreo
	li $t1, 0
	j revisarextra
	revisarextra:
	li $t2, 0
	lb $t2, num2($t7)
	addi $t2, $t2, -48
	add $t5, $t2, $t3
	li $t3, 0
	blt $t5, 10, sinacarreoextra
	addi $t5, $t5, -10
	li $t3, 1
	sinacarreoextra:
	addi $t5, $t5, 48
	sb $t5, result($t4)
	addi $t4, $t4, -1
	addi $t7, $t7, -1
	j finsuma
	revisar_acarreo:
	beqz $t3, poner_signo
	li $t5, 49
	sb $t5, result($t4)
	addi $t4, $t4, -1
	poner_signo:
	beq $s6, 0, signo_suma
	beq $s7, 0, signo_mas
	beq $s7, 2, signo_contrario
	lb $t6, num1
	j escribir_signo
	signo_contrario:
	lb $t6, num1
	beq $t6, $s2, signo_mas
	li $t6, '-'
	j escribir_signo
	signo_suma:
	lb $t6, num1
	j escribir_signo
	signo_mas:
	li $t6, '+'
	escribir_signo:
	sb $t6, result($t4)
	move $t0, $t4
	lb $t6, result($t0)
	addi $t0, $t0, 1
	saltarceros:
	bge $t0, 51, ponersigno
	lb $t2, result($t0)
	bne $t2, 48, ponersigno
	addi $t0, $t0, 1
	j saltarceros
	ponersigno:
	li $t1, 0
	sb $t6, result($t1)
	addi $t1, $t1, 1
	mover:
	bgt $t0, 51, fin_mover
	lb $t2, result($t0)
	sb $t2, result($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j mover
	fin_mover:
	li $t2, 0
	sb $t2, result($t1)
	jr $ra
	
multiplicar:
	jr $ra

	
