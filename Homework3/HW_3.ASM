;_ NAME:           Shalaeva Marina Andreevna                  __________________
;_ GROUP NUMBER:   BSE191                                     __________________
;_                                                            __________________
;_ VARIANT: 27                                                __________________
;_                                                            __________________
;_ TASK:    develop a program for numerical integration of    __________________
;__         the function y = a + b * x^3 (given by integers   __________________
;__         a, b) in a certain range of integers (given in    __________________
;__         the same way) by the method of left rectangles    __________________
;__         (= method of riemann sum)(width 1).               __________________


format PE console

include 'win32ax.inc'

entry start

;_______________________________________________________________________________

section '.data' data readable writable

;_______endline \n for strings__________________________________________________
        endl FIX 10, 13
        launchstr db "This program intended for calculating definite integral",\
                  endl,"of polynomial a+b*x^3 on [X1; X2] using the method of",\
                  endl,"left rectangles (= method of riemann sum) (width = 1).",\
                  endl,"This work was made by Shalaeva Marina, BSE191", 0

        debugstr db "debug"

        message db 256 DUP(?)

        commandLine dd ?

        result_integral dd 0
;_______width of the rectangle__________________________________________________
        h dd 1
        XX1 dd ?
        XX2 dd ?
        AA dd ?
        BB dd ?
;_______________________________________________________________________________


macro show_result
{
        mov [result_integral], esi
        invoke sprintf, message, "The calculated integral is %d", [result_integral]
        invoke MessageBox, 0, message, "Your result", MB_OK
        invoke ExitProcess, 0
}

;_______________________________________________________________________________


macro show_instruction
{
      invoke MessageBox, 0, "How to use this program: write in cmd <filename [a] [b] [X1] [X2]>. Requirements: X1 < X2, A != 0, B != 0",\
             "Instruction", MB_OK
      invoke ExitProcess, 0
}

;_______________________________________________________________________________


macro overflow
{
      invoke MessageBox, 0, "Overflow due to big numbers", "Error", MB_OK
      invoke ExitProcess, 0
}

;_______________________________________________________________________________


macro check_correct_input
{
        mov eax, [AA]
        mov ebx, [BB]
        mov ebx, [XX1]

        cmp ebx,[XX2]

        jge end_instruction   ; x1 >= x2

        OR eax, [BB]   ; checking a and b != 0
        cmp eax, 0
        je end_instruction
}

;_______________________________________________________________________________


macro input
{
        cinvoke GetCommandLine
        mov [commandLine], eax
        cinvoke sscanf,[commandLine], '%*s %d %d %d %d', AA, BB, XX1, XX2
        invoke sprintf, message, "Arguments are a = %d; b = %d; X1 = %d; X2 = %d",\
               [AA], [BB], [XX1], [XX2]
        invoke MessageBox, 0, message, "Your input arguments", MB_OK

}

;_______________________________________________________________________________


macro check_overflow
{
        cmp OF, 1b
        je overflow_occured
}

;_______________________________________________________________________________


macro calc_point
{
        mov edi, ebx
        imul edi, ebx
        imul edi, ebx   ; here we have x^3
        imul edi, [BB]  ; * b
        add edi, [AA]   ; = a + b * x^3
}

;_______________________________________________________________________________


section '.code' code readable executable

        start:

;_______________launch the start welcome window_________________________________
                invoke MessageBox, 0, launchstr, "Welcome", MB_OK
;_______________launch input____________________________________________________
                input
;_______________checking values_________________________________________________
                check_correct_input

;_______________MAIN SECTION____________________________________________________

;_______________while X1 < X2___________________________________________________
                ; here is changable variable (I will name it 'SUM'), which
                ; will be our finish value after the last step of the while-loop
                mov esi, 0
                ; start value (I will name it 'X'), which equals X1 in
                ; the first step
                mov ebx, [XX1]

        start_loop:

;_______________check if loop is over___________________________________________
                cmp ebx, [XX2]
                jge loop_exit
;______________ calculate current X_____________________________________________
                calc_point
;_______________increment ebx (change current X to the next one)_____________
                inc ebx

;_______________add current value to SUM____________________________________
                add esi, edi
                jmp start_loop

;_______label for exit__________________________________________________________
        loop_exit:
;_______________show calculated result__________________________________________
                show_result


;_______label for exit because of wrong arguments_______________________________
        end_instruction:
                show_instruction

;_______label for exit because of overflow exception____________________________
        overflow_occured:
                overflow

;_______________________________________________________________________________

section '.idata' import data readable writeable

library kernel32,'KERNEL32.DLL', user32,'USER32.DLL', gdi32,'GDI32.DLL',\
        advapi32,'ADVAPI32.DLL', comctl32,'COMCTL32.DLL',\
        comdlg32,'COMDLG32.DLL', shell32,'SHELL32.DLL', wsock32,'WSOCK32.DLL',\
        msvcrt,'MSVCRT.DLL'

        import_kernel32
        import_user32
        import_gdi32
        import_advapi32
        import_comctl32
        import_comdlg32
        import_shell32
        import_wsock32

        all_api

import msvcrt, sprintf, 'sprintf', sscanf, 'sscanf'
