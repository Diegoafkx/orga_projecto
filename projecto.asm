.data 
#las variables con los mensajes a escribir
wlcom: .asciiz "Bienvenido a la calculadora de numeros grandres \n"
msg1: .asciiz "\nPorfavor ingrese el primer numero, con un signo de suma o resta en la primera posicion: \n"
msg2: .asciiz "\nEl numero ingresado es:\n"
msg3: .asciiz "Las operaciones disponibles son:\n '-' para resta\n '+' para suma\n '*' para multiplicacion\nEscriba el signo de la operacion que desea hacer:\n" 
msg4: .asciiz "\nPorfavor ingrese el segundo numero, con un signo de suma o resta en la primera posicion: \n"
error1: .asciiz "\nSe ingreso un caracter invalido\n"
error2: .asciiz "Solo se permiten 25 digitos como máximo.\n"
resultado: .asciiz "El resultado de la operacion es:\n"
 

salto: .asciiz "\n"
aux1: .word '0'
aux: .space 51
num1 : .space 51
num2: .space 51
ope: .space 2
result: .space 52
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
	beq $t5, $s1, hacer_suma
	beq $t5, $s2, hacer_resta
	beq $t5, $s3, hacer_multiplicacion
	j end_main

	hacer_suma:
    jal suma
    j end_main
	hacer_resta:
    jal resta
    j end_main
	hacer_multiplicacion:
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
	li $v0, 8
	la $a0, aux
	li $a1, 51
	syscall
	jr $ra
	
#metodo para duplicar el contenido del auxiliador a las variables necesarias
copiar:
	lb $t5, 0($t0)
	sb $t5, 0($t1)
	beq $t5, $zero, endcop
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

	pedirdenuevo: # si hayrror
	jal ingresar_numeros
	li $t0, 0
	lb $t1, aux($t0)
	beq $t1, $s1, revisar_digitos
	beq $t1, $s2, revisar_digitos
	j error_caracter

	revisar_digitos:
	addi $t0, $t0, 1
	li $t2, 0

	bucle_validacion:
	lb $t1, aux($t0)
	beq $t1, $zero, validar_longitud
	beq $t1, 10, fin_linea
	blt $t1, '0', error_caracter
	bgt $t1, '9', error_caracter
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j bucle_validacion

	fin_linea:
	sb $zero, aux($t0)
	j validar_longitud

	validar_longitud:
	beq $s0, $zero, fin_validacion
	li $t3, 25
	ble $t2, $t3, fin_validacion
	j error_longitud

	error_caracter:
	li $v0, 4
	la $a0, error1
	syscall
	bne $s6, $zero, pedir_msg2
	li $v0, 4
	la $a0, msg1
	syscall
	j pedirdenuevo

	pedir_msg2:
	li $v0, 4
	la $a0, msg4
	syscall
	j pedirdenuevo

	error_longitud:
	li $v0, 4
	la $a0, error2
	syscall
	bne $s6, $zero, pedir_msg4
	li $v0, 4
	la $a0, msg1
	syscall
	j pedirdenuevo

	pedir_msg4:
	li $v0, 4
	la $a0, msg4
	syscall
	j pedirdenuevo

	fin_validacion:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
		
suma:
	lb $t6, num1
	lb $t7, num2
	bne $t6, $t7, arreglar_signos
	li $t9,0
	li $t8, 2 #para indicar si se le suma uno al numero
	li $t0, 1
	lb $t1, num1($t0)
	lb $t2, num2($t0)
	li $t4, 48
	bne $t1, $t4, es_cero_n2_suma
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $t0, num2
	la $t1, result
	beq $t2, $t4, ambos_son_ccsuma
	jal copiar 
	li $s4, 0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	ambos_son_ccsuma:
		li $t0, 0
		li $t2, 1
		sb $s1, result($t0)
		li $t0, 48
		sb $t0, result($t2)
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	es_cero_n2_suma:
		bne $t2, $t4, cambiar_de_posicion
		addi $sp, $sp, -4
		la $t0, num1
		la $t1, result
		sw $ra, 0($sp)
		jal copiar
		li $s4, 0
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	cambiar_de_posicion:
		bge $s4, $s5, seguir_suma
	seguir_cambio_de_posicion:
	li $t9, 1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $t3, $s4 
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
	seguir_suma:
		move $t6, $s4 #t6 es para aux el metodo mayor a 10
		li $t0, 0
		lb $t1, num1($t0)
		lb $t2, num2($t0)
		li $t0, -1 
		loop_suma:
			blez $s4, end_loop_suma #condicion para terminar la suma
			lb $t3, num1($s4)
			beq $t3, $zero, end_loop_suma #condicion para terminar la suma
			addi $t3, $t3, -48
			li $t4, 0
			blez $s5, seguir_loop_suma #por si el numero de abajo ya se acabo
			lb $t4, num2($s5)
			addi $t4, $t4, -48
			seguir_loop_suma:
			beq $t8, 2, suma_num #caso para saber si hay que sumar
			addi $t3, $t3, 1 
			li $t8, 2	
			suma_num:
				add $t5, $t3, $t4
				bge $t5, 10, mayor_a_dies #para saber si es mayor a 10
				j acoplar_en_resultado
			mayor_a_dies:
				li $t8, 0
				add $t7, $s4, $t6
				beqz $t7, acoplar_en_resultado
				addi $t5, $t5, -10
				acoplar_en_resultado:
					addi $t5, $t5, 48
					sb $t5, result($s4)
					addi $s4, $s4, -1
					addi $s5, $s5, -1
					j loop_suma
		end_loop_suma:
			bnez $t8, salir_suma
			move $s4, $t6
			addi $t6, $t6, 1
			loop_copiar_suma:
				beq $t6, 1, salir_Loop_suma_copia
				lb $t2, result($s4)
				addi $s4, $s4, -1
				sb $t2, result($t6)
				addi $t6, $t6, -1
				j loop_copiar_suma
				salir_Loop_suma_copia:
					li $t5, 49
					li $s4, 1
					sb $t5, result($s4)
					j salir_suma
			salir_suma:
				li $s4, 0
				sb $t1, result($s4)
				beqz $t9, salida_suma
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				salida_suma:
				jr $ra
				
arreglar_signos:
	lb $t0, num2
	beq $t0, $s2, era_menos
	li $t0, '-'
	sb $t0, num2
	j resta
	era_menos:
	li $t0, '+'
	sb $t0, num2
	j resta		
				

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
	comparar_digitos:  #paa ver cual numero es mayor
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
	beq $s6, 0, sumar_magnitudes #si los signos eran distintos se suma
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
	li $s4, 0
	jr $ra
	
multiplicar:
    	li $t0, 0
	
	limpiar_todo:
    	sb $zero, result($t0)
    	sb $zero, aux2($t0)
    	sb $zero, temp($t0)
    	addi $t0, $t0, 1
    	blt $t0, 52, limpiar_todo
    	lb $t0, num1
    	lb $t1, num2
    	beq $t0, $t1, signo_positivo
    	li $t2, '-'
    	j guardar_signo
	
	signo_positivo:
    	li $t2, '+'
	
	guardar_signo:
    	li $t0, 1
	revisar_cero_num1:
    	bgt $t0, $s4, resultado_cero
    	lb $t3, num1($t0)
    	bne $t3, '0', revisar_num2
    	addi $t0, $t0, 1
    	j revisar_cero_num1

	revisar_num2:
    	li $t0, 1
	revisar_cero_num2:
    	bgt $t0, $s5, resultado_cero
    	lb $t3, num2($t0)
    	bne $t3, '0', hacer_multiplicacion2
    	addi $t0, $t0, 1
    	j revisar_cero_num2

	resultado_cero:
    	sb $t2, result
    	li $t3, '0'
    	sb $t3, result+1
    	sb $zero, result+2
    	li $s4, 1
    	jr $ra

	hacer_multiplicacion2:
    	move $t8, $s4

	bucle_num1:
    	blez $t8, construir_resultado
    	lb $t0, num1($t8)
    	addi $t0, $t0, -48
    	move $t9, $s5

	bucle_num2:
    	blez $t9, siguiente_digito_num1
    	lb $t1, num2($t9)
    	addi $t1, $t1, -48
    	sub $t4, $s4, $t8
    	sub $t5, $s5, $t9
    	add $t6, $t4, $t5
    	li $t7, 50
    	sub $t7, $t7, $t6
    	mul $t3, $t0, $t1
    	lb $t4, aux2($t7)
    	beqz $t4, aux2_vacio
    	addi $t4, $t4, -48
    	j aux2_tiene_valor

	aux2_vacio:
    	li $t4, 0

	aux2_tiene_valor:
    	add $t3, $t3, $t4
    	li $t4, 10
    	div $t3, $t4
    	mfhi $t5
    	mflo $t3
    	addi $t5, $t5, 48
    	sb $t5, aux2($t7)
    	beqz $t3, sin_llevado
    	addi $t7, $t7, -1
    	lb $t4, aux2($t7)
    	beqz $t4, llevado_vacio
    	addi $t4, $t4, -48
    	j llevado_tiene_valor
	
	llevado_vacio:
    	li $t4, 0
    		
	llevado_tiene_valor:
    	add $t3, $t3, $t4
    	addi $t3, $t3, 48
    	sb $t3, aux2($t7)
    	
	sin_llevado:
    	addi $t9, $t9, -1
    	j bucle_num2

	siguiente_digito_num1:
    	addi $t8, $t8, -1
    	j bucle_num1

	construir_resultado:
    	li $t0, 1
    	
	buscar_primer_digito:
    	bgt $t0, 50, resultado_cero
    	lb $t1, aux2($t0)
    	bnez $t1, copiar_resultado
    	addi $t0, $t0, 1
    	j buscar_primer_digito

	copiar_resultado:
    	sb $t2, result
    	li $t3, 1

	copiar_bucle:
    	lb $t1, aux2($t0)
    	sb $t1, result($t3)
    	beqz $t1, fin_multiplicar
    	addi $t0, $t0, 1
    	addi $t3, $t3, 1
    	j copiar_bucle

	fin_multiplicar:
    	move $s4, $t3
    	jr $ra

	
