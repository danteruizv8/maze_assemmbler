.data	
	laberinto: .dword 0x2b2d2d2d2d2d2d2b, 0x2b2d2d2d2d2d2d2d ,  0x20202020207c587c ,  0x7c2d20202020207c ,  0x202b2d2d207c207c ,  0x7c20202d2d2b207c ,  0x207c2020207c207c ,  0x7c202020207c207c ,  0x207c202d2d2b207c ,  0x2b2d2d20207c207c ,  0x207c20202020207c ,  0x7c232020207c2020 ,  0x2d2b2d2d2d2d2d2b ,  0x2b2d2d2d2d2b2d2d 
	estado: .dword 0x4e45204f4745554a, 0x21214f5352554320
	estado_p: .dword 0x4554534944524550, 0x202020202020283a
	estado_g: .dword 0x21455453414e4147, 0x2020202020292d42
	_stack_ptr: .dword _stack_end   // Get the stack pointer value from memmap definition
	
	
.text	// Configuracion del Stack Pointer
	ldr     X1, _stack_ptr  
        mov     sp, X1
         

	// Limpiar X0 y X4 siempre de comenzar el programa
	MOV X0, XZR
	MOV X4, XZR


	LDR X0, =laberinto	 //X0 = Dirección base del arreglo "laberinto"
main:
 	//Aquí va el código de su programa

	movz X5,#32 	// largo de "linea"
	MOV X6,X0  	// offset caracteres
	ADD  X6,X6,#17	// ubicacion jugador 
	MOV X7,XZR  	// word cero
	LDR X10, =estado_p // guarda cada tramo de texto en un registro
	LDUR X11,[X10,#0]
	LDUR X12,[X10,#8]
	LDR X10, =estado_g
	LDUR X13,[X10,#0]
	LDUR X14,[X10,#8]
	
	LDURSB  X2,[X6,#0] 	// carga caracter de direccion
	MOVZ X21,0x58		// carga caracter personaje en el inicio
	
	bl abajo   // inicia el recorrido
	bl abajo
	bl abajo
//	bl izquierda // descomentar esta linea para peder
	bl abajo
	bl derecha
	bl derecha
	bl derecha
	bl derecha
	bl arriba
	bl arriba
	bl izquierda
	bl izquierda
	bl arriba
	bl arriba
	bl derecha
	bl derecha
	bl derecha
	bl derecha
	bl abajo
	bl abajo
	bl abajo
	bl abajo
	bl derecha
	bl derecha
	bl arriba
	bl arriba
	bl arriba
	bl arriba
	bl derecha
	bl derecha
	bl derecha
	bl derecha
	bl abajo
	bl abajo
	bl izquierda
	bl izquierda
	bl abajo
	bl abajo
	bl derecha
	bl derecha
	bl derecha

		
        //Instrucción NOP para acomodar la imagen
        ADD XZR, XZR, XZR
        ADD XZR, XZR, XZR
        ADD XZR, XZR, XZR
	b main
	


arriba:
	STURB w20,[X6,#0]	// escribe espacio
	SUB  X6,X6,#16		// desplaza una linea arriba
	LDURSB  X3,[X6,#0] 	// guarda caracter de destino
	STURB w21,[X6,#0]	// escribe jugador
	MOV X29,X30
	BL comprobar
	RET X29
	RET

abajo:
	STURB w20,[X6,#0]	// escribe espacio
	ADD  X6,X6,#16		// desplaza una linea abajo
	LDURSB  X3,[X6,#0] 
	STURB w21,[X6,#0]	// escribe jugador
	MOV X29,X30
	BL comprobar
	RET X29
	RET

derecha:
	STURB w20,[X6,#0]	// escribe espacio
	ADD  X6,X6,#1		// desplaza un caracter a la derecha
	LDURSB  X3,[X6,#0] 
	STURB w21,[X6,#0]	// escribe jugador
	MOV X29,X30
	BL comprobar
	RET X29
	RET

izquierda:
	STURB w20,[X6,#0]	// escribe espacio
	SUB  X6,X6,#1		// desplaza un caracter a la izquierda
	LDURSB  X3,[X6,#0] 
	STURB w21,[X6,#0]	// escribe jugador
	MOV X29,X30
	BL comprobar
	RET X29
	RET

comprobar:
	cmp X3,0x20   	// <--------------- Un solo breakpoint aqui
	b.eq continue
	cmp X3,0x23     // indica que se llego a #
	b.eq ganaste 
	b perdiste	// cualquier otro caracter indica que perdiste
continue:
	RET

ganaste:
	STUR x13,[X0,0X70]  	// carga el texto GANASTE! B-)
	STUR x14,[X0,0X78]
	b ganaste
perdiste:
	STUR x11,[X0,0X70]	// carga el texto PERDISTE :(
	STUR x12,[X0,0X78]
	b perdiste

