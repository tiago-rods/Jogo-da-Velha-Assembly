;   DONE: ENTENDER MELHOR COMO FUNCIONA PROCEDIMENTOS, CALL E RET
;   DONE: MOSTRAR O JOGO DA VELHA NO TERMINAL
;   DONE: CELULAS ESTAO APARECENDO OCUPADAS MESMO NÃO ESTANDO 
;   TODO: NÃO ESTÁ MOSTRANDO O MENSAGEM DE EMPATE, JOGO CONTINUA INFINITAMENTE NO CASO DE VELHA


; CÓDIGO FEITO POR TIAGO ALVES RODRIGUES, INSPIRADO NO CODIGO DE TANVIR AHMED SOJAL
; PRINCIPAIS MUDANÇAS EM RELAÇÃO AO CODIGO DE INSPIRAÇÃO: ORGANIZAÇÃO EM PROCEDIMENTOS (CALL, RET E PROC), LOGICA DE VERIFICAÇÃO DE CELULAS, ALÉM DE MUDANÇAS ESTÉTICAS
.MODEL SMALL
.STACK 500H

.DATA

; "JOGO DA VELHA" EM ASCII
T1 DB  32,32,4,   32,   4,4,4,    32,   4,4,4,    32,   4,4,4,    32, 32, 32,  4,4,32,    32,   32,4,32,  32,32,32,   4,32,4,   32,  4,4,4,    32,  4,32,32,  32,  4,32,4, 32, 32,4,32  ,10,13, "$"
T2 DB  32,32,4,   32,   4,32,4,   32,   4,32,32,  32,   4,32,4,   32, 32, 32,  4,32,4,    32,   4,32,4,   32,32,32,   4,32,4,   32,  4,32,32,  32,  4,32,32,  32,  4,32,4, 32, 4,32,4 ,10,13, "$"
T3 DB  4,32, 4,   32,   4,32,4,   32,   4,4,4,    32,   4,32,4,   32, 32, 32,  4,32,4,    32,   4,4,4,    32,32,32,   4,32,4,   32,  4,4,4,    32,  4,32,32,  32,  4,4,4,  32, 4,4,4  ,10,13, "$"
T4 DB  4, 32, 4,  32,   4,32,4,    32,  4,32,4,   32,   4,32,4,   32, 32, 32,  4,32,4,   32,   4,32,4,   32,32,32,   4,32,4,    32,  4,32,32,  32,  4,32,32,  32,  4,32,4, 32, 4,32,4 ,10,13,"$"
T5 DB  4,4,4,      32,  4,4,4,     32,  4,4,4,    32,   4,4,4,    32,32,32,    4,4,32,    32,  4,32,4,   32,32,32,   32,4,32,    32,  4,4,4,    32,  4,4,4,    32,  4,32,4, 32,  4,32,4 ,10,13, "$"

TAGLINE DB 'Desenvolvido por Tiago Rodrigues ',10,13,'$'

;------------------STRING IMPORTANTES USADAS AO DECORRER DO PROGRAMA----------------------

PQT DB 'Pressione qualquer tecla para continuar...$'

;-----------------REGRAS DO JOGO-----------------------
REGRA0 DB 'Regras do Jogo: $'
REGRA1 DB '1. Jogadores revezarão turnos. $'
REGRA2 DB '2. Jogador 1 (X) irá primeiro, seguido pelo jogador 2 (O). $'
REGRA3 DB '3. A tabela está demarcada com números em cada célula.  $'
REGRA4 DB '4. Insira o número da célula que deseja jogar. $'
REGRA5 DB '5. O jogador que marcar a linha, coluna ou diagonal ganha. $'
REGRA6 DB 'Boa Sorte! $'

;------------------LINHAS DA TABELA-------------------
L1 DB '   |   |   $'
L2 DB '---------$'
N1 DB ' | $'

;------------------NUMERO DAS CELULAS----------------
C1 DB '1$' 
C2 DB '2$'
C3 DB '3$'
C4 DB '4$'
C5 DB '5$'
C6 DB '6$'
C7 DB '7$'
C8 DB '8$'
C9 DB '9$'

;----------------VERIFICA AS FLAGS PARA VER QUEM GANHOU OU SE O JOGO EMPATOU--------------
PLAYER DB 50, '$' 
MOVES DB 0
DONE DB 0
DR DB 0 

;--------------PROMPTS DA SEÇÃO DE INPUT----------------
INP DB 32, ':: Digite o numero da celula:',10,13,' $'
OCUP DB 10,13, 'Esta celula está ocupada! Pressione qualquer tecla...',10, 13, '$'

;-----------------MARCAÇÃO ATUAL-----------------
ATUAL DB 88

;----------------MENSAGENS FINAIS----------------
MSG1 DB 'Jogador $'
MSG2 DB ' ganhou o jogo! $'
EMPT DB 'O jogo empatou! $'

;-------------TENTE NOVAMENTE---------------
TENT DB 'Jogar novamente? (s/n): $'
INER DB 32, 32, 32, 'Input errado! Pressione qualquer tecla... $'

;-----------------ENDL-----------------
ENDL DB 10, 13, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    ; Procedimento principal que organiza o fluxo de execução do jogo
    CALL TITLESCREEN
    CALL REGRAS
    CALL INICIALIZACAO
    CALL GAME_LOOP
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP

TITLESCREEN PROC
    ; Procedimento para exibir a tela inicial do jogo
    CALL CLEAR_SCREEN

            MOV AH, 2 
            MOV BH, 0 
            MOV DH, 6
            MOV DL, 14
            INT 10H

        MOV AH, 9 
        LEA DX, T1
        INT 21H

            MOV AH, 2
            MOV BH, 0
            MOV DH, 7
            MOV DL, 14
            INT 10H
        
        MOV AH, 9
        LEA DX, T2
        INT 21H
                    
            MOV AH, 2
            MOV BH, 0
            MOV DH, 8
            MOV DL, 14
            INT 10H 
                   
        MOV AH, 9
        LEA DX, T3
        INT 21H
                
            MOV AH, 2
            MOV BH, 0
            MOV DH, 9
            MOV DL, 14
            INT 10H  
        
        MOV AH, 9
        LEA DX, T4
        INT 21H 

            MOV AH, 2
            MOV BH, 0
            MOV DH, 10
            MOV DL, 14
            INT 10H 

        MOV AH,9 
        LEA DX, T5
        INT 21H

            MOV AH, 2
            MOV BH, 0
            MOV DH, 12
            MOV DL, 22
            INT 10H 

        MOV AH, 9 
        LEA DX, TAGLINE
        INT 21H

            MOV AH, 2 
            MOV BH, 0
            MOV DH, 14
            MOV DL, 22
            INT 10H

    CALL WAIT_FOR_KEY
    CALL CLEAR_SCREEN

    RET
TITLESCREEN ENDP

REGRAS PROC
    ; Procedimento para exibir as regras do jogo
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 6
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA0
    INT 21H

    MOV AH, 02H
    MOV DH, 7
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA1
    INT 21H

    MOV AH, 02H
    MOV DH, 8
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA2
    INT 21H

    MOV AH, 02H
    MOV DH, 9
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA3
    INT 21H

    MOV AH, 02H
    MOV DH, 10
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA4
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 11
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA5
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 12
    MOV DL, 7
    INT 10H

    MOV AH, 9
    LEA DX, REGRA6
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 13
    MOV DL, 7
    INT 10H

    CALL WAIT_FOR_KEY
    RET
REGRAS ENDP

INICIALIZACAO PROC
    ; Procedimento para inicializar o estado do jogo
    MOV PLAYER, 50
    MOV MOVES, 0    
    MOV DONE, 0
    MOV DR, 0

    MOV C1, 49
    MOV C2, 50
    MOV C3, 51
    MOV C4, 52
    MOV C5, 53
    MOV C6, 54
    MOV C7, 55
    MOV C8, 56
    MOV C9, 57

    RET
INICIALIZACAO ENDP

GAME_LOOP PROC
    ; Loop principal do jogo onde as operações de entrada, verificação e saída ocorrem
    CALL CLEAR_SCREEN
    CALL DISPLAY_BOARD

    GAME: MOV AH, 9
    LEA DX, INP
    INT 21H

    CALL INPUT

    CALL CLEAR_SCREEN
    CALL DISPLAY_BOARD

    CALL WIN_CONDITION

    CMP DONE, 49
    JE END_GAME

    CMP MOVES, 57
    JNE NEXT_MOVE

    MOV DONE, 49

NEXT_MOVE:
    CALL TOGGLE_PLAYER
    JMP GAME

END_GAME:
    CMP DR, 49
    JNE DISPLAY_WINNER

    MOV AH, 9
    LEA DX, EMPT
    INT 21H

    JMP PROMPT_AGAIN

DISPLAY_WINNER:
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    MOV DL, PLAYER
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, MSG2
    INT 21H

PROMPT_AGAIN:
    MOV AH, 9
    LEA DX, TENT
    INT 21H

    CALL GET_KEY_INPUT

    CMP AL, 'n'
    JE EXIT_GAME

    CMP AL, 'N'
    JE EXIT_GAME

    CMP AL, 's'
    JE RESTART_GAME

    CMP AL, 'S'
    JE RESTART_GAME

    MOV AH, 9
    LEA DX, INER
    INT 21H

    JMP PROMPT_AGAIN

RESTART_GAME:
    CALL INICIALIZACAO
    CALL GAME_LOOP

EXIT_GAME:
    RET
GAME_LOOP ENDP

INPUT PROC
    ; Captura a entrada do usuário e valida a jogada
    MOV AH, 1
    INT 21H

    MOV AH, 0
    MOV DH, 32
    CMP AL, '1'
    JB INPUT ; Se a entrada for menor que '1', pede outra entrada
    CMP AL, '9'
    JA INPUT ; Se a entrada for maior que '9', pede outra entrada

    MOV DH, AL
    CALL IS_CELL_EMPTY ; Verifica se a célula está vazia

    ; Se a célula estiver ocupada, mostra a mensagem e volta para o input
    CMP AL, '0' 
    JE INPUT_PROC

    RET

INPUT_PROC:
    MOV AH, 9
    LEA DX, OCUP
    INT 21H

    JMP INPUT
INPUT ENDP

DISPLAY_BOARD PROC
    ; Procedimento para exibir o tabuleiro
    MOV AH, 02H
    MOV BH, 0
    MOV DH, 3
    MOV DL, 5
    INT 10H

    MOV DL, C1
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C2
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C3
    MOV AH, 2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 4
    MOV DL, 5
    INT 10H

    MOV AH, 9
    LEA DX, L2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 5
    MOV DL, 5
    INT 10H

    MOV DL, C4
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C5
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C6
    MOV AH, 2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 6
    MOV DL, 5
    INT 10H

    MOV AH, 9
    LEA DX, L2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 7
    MOV DL, 5
    INT 10H

    MOV DL, C7
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C8
    MOV AH, 2
    INT 21H

    MOV AH, 9
    LEA DX, N1
    INT 21H

    MOV DL, C9
    MOV AH, 2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DH, 8
    MOV DL, 5
    INT 10H

    MOV AH, 9
    LEA DX, ENDL
    INT 21H

    RET
DISPLAY_BOARD ENDP

WIN_CONDITION PROC
    ; Procedimento para verificar a condição de vitória
    MOV DONE, 48
    MOV DR, 48

    MOV AL, C1
    CMP AL, C2
    JNE CHECK_NEXT

    CMP AL, C3
    JE WIN_FOUND

CHECK_NEXT:
    MOV AL, C4
    CMP AL, C5
    JNE CHECK_NEXT2

    CMP AL, C6
    JE WIN_FOUND

CHECK_NEXT2:
    MOV AL, C7
    CMP AL, C8
    JNE CHECK_NEXT3

    CMP AL, C9
    JE WIN_FOUND

CHECK_NEXT3:
    MOV AL, C1
    CMP AL, C4
    JNE CHECK_NEXT4

    CMP AL, C7
    JE WIN_FOUND

CHECK_NEXT4:
    MOV AL, C2
    CMP AL, C5
    JNE CHECK_NEXT5

    CMP AL, C8
    JE WIN_FOUND

CHECK_NEXT5:
    MOV AL, C3
    CMP AL, C6
    JNE CHECK_NEXT6

    CMP AL, C9
    JE WIN_FOUND

CHECK_NEXT6:
    MOV AL, C1
    CMP AL, C5
    JNE CHECK_NEXT7

    CMP AL, C9
    JE WIN_FOUND

CHECK_NEXT7:
    MOV AL, C3
    CMP AL, C5
    JNE NO_WIN

    CMP AL, C7
    JE WIN_FOUND

NO_WIN:
    CMP MOVES, 57
    JNE WIN_PROC_END

    MOV DR, 49

WIN_PROC_END:
    RET

WIN_FOUND:
    MOV DONE, 49
    RET
WIN_CONDITION ENDP

TOGGLE_PLAYER PROC
    ; Procedimento para alternar o jogador
    MOV AL, PLAYER
    CMP AL, 50
    JE SET_X

    MOV PLAYER, 50
    MOV ATUAL, 88
    RET

SET_X:
    MOV PLAYER, 49
    MOV ATUAL, 79
    RET
TOGGLE_PLAYER ENDP

WAIT_FOR_KEY PROC
    ; Espera o usuário pressionar uma tecla
    MOV AH, 1
    INT 21H
    RET
WAIT_FOR_KEY ENDP

GET_KEY_INPUT PROC
    ; Captura a entrada de uma tecla do usuário
    MOV AH, 7
    INT 21H
    RET
GET_KEY_INPUT ENDP

CLEAR_SCREEN PROC
    ; Procedimento para limpar a tela
        MOV AX, 0600H
        MOV BH, 07H
        MOV CX, 0000H
        MOV DX, 184FH
        INT 10H
    RET
CLEAR_SCREEN ENDP

IS_CELL_EMPTY PROC
    ; Verifica se a célula está vazia
    CMP DH, C1
    JE UPDATE_C1

    CMP DH, C2
    JE UPDATE_C2

    CMP DH, C3
    JE UPDATE_C3

    CMP DH, C4
    JE UPDATE_C4

    CMP DH, C5
    JE UPDATE_C5

    CMP DH, C6
    JE UPDATE_C6

    CMP DH, C7
    JE UPDATE_C7

    CMP DH, C8
    JE UPDATE_C8

    CMP DH, C9
    JE UPDATE_C9

    ; Se nenhuma célula corresponde, define AL como '0' para sinalizar célula ocupada
    MOV AL, '0'
    RET

UPDATE_C1:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C1, AL      ; Move o valor de AL para C1
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C2:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C2, AL      ; Move o valor de AL para C2
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C3:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C3, AL      ; Move o valor de AL para C3
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C4:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C4, AL      ; Move o valor de AL para C4
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C5:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C5, AL      ; Move o valor de AL para C5
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C6:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C6, AL      ; Move o valor de AL para C6
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C7:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C7, AL      ; Move o valor de AL para C7
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C8:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C8, AL      ; Move o valor de AL para C8
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET

UPDATE_C9:
    MOV AL, ATUAL   ; Carrega o valor de ATUAL no registrador AL
    MOV C9, AL      ; Move o valor de AL para C9
    INC MOVES       ; Incrementa a contagem de movimentos
    MOV AL, '1'
    RET
IS_CELL_EMPTY ENDP

END MAIN