;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
   
      .686p                       ; create 32 bit code
      .mmx                        ; enable MMX instructions
      .xmm                        ; enable SSE instructions
      .model flat, stdcall      ; 32 bit memory model
      option casemap :none      ; case sensitive

      include \masm32\include\dialogs.inc
      include main.inc
      include \masm32\macros\macros.asm
      
      dlgproc       PROTO :DWORD,:DWORD,:DWORD,:DWORD
      GetText       PROTO :DWORD,:DWORD,:DWORD
      GetTextProc   PROTO :DWORD,:DWORD,:DWORD,:DWORD

    .code

;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

start:

      mov hInstance, FUNC(GetModuleHandle,NULL)
      mov hIcon,     FUNC(LoadIcon,hInstance,500)

      call main

      invoke ExitProcess,eax

;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
main proc

    LOCAL lpArgs:DWORD

    invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT, 32
    mov lpArgs, eax

    push hIcon
    pop [eax]

    Dialog "lab_10","MS Sans Serif",10, \         ; caption,font,pointsize
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \     ; style
            5, \                                            ; control count
            50,50,150,80, \                                 ; x y co-ordinates
            1024                                            ; memory buffer size

    DlgEdit   WS_TABSTOP or WS_BORDER,35,45,75,10,50
    DlgButton "Calculate",WS_TABSTOP,110,4,35,10,IDOK
    DlgButton "Cancel",WS_TABSTOP,110,15,35,10,IDCANCEL
    DlgStatic "2 * sin(x * x - 5)",SS_CENTER,40,15,50,9,99
    DlgStatic "Enter x:",SS_CENTER,4,35,140,9,100
    DlgIcon   500,10,10,101

    CallModalDialog hInstance,0,dlgproc,ADDR lpArgs

    invoke GlobalFree, lpArgs

    ret

main endp

;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

dlgproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

    LOCAL buffer:DWORD
    LOCAL hEdit :DWORD
    LOCAL tl    :DWORD
    LOCAL x     :REAL4
    LOCAL two   :REAL4
    LOCAL five  :REAL4
    LOCAL k     :DWORD
    LOCAL ten   :DWORD

    .if uMsg == WM_INITDIALOG
      invoke SetWindowLong,hWin,GWL_USERDATA,lParam
      mov eax, lParam
      mov eax, [eax]
      invoke SendMessage,hWin,WM_SETICON,1,[eax]

    .elseif uMsg == WM_COMMAND
      .if wParam == IDOK
        invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT, 16
        mov buffer, eax

        invoke GetDlgItem,hWin,50
        mov hEdit, eax
        invoke GetWindowTextLength,hEdit
        mov tl, eax
        inc tl
        cmp eax, 0
        je @F

        invoke SendMessage,hEdit,WM_GETTEXT,tl,buffer  ; write edit text to buffer

        xor ebx, ebx
        xor eax, eax
        mov ecx, buffer
        mov esi, 0
        cmp byte ptr [ecx + esi], '-'
        jne str_to_num
        inc esi             ; f(x*x), ïîýòîìó çíàê íå âàæåí
        
        str_to_num:
        imul eax, 10
        mov bl, byte ptr [ecx + esi]
        sub bl, '0'
        add eax, ebx
        inc esi
        cmp  byte ptr [ecx + esi], 0
        jne str_to_num

        
        mov dword ptr x, eax
        fild x
        fild x
        fmulp st(1), st(0)
        mov k, 5
        fild k
        fsubp st(1), st(0)
        fsin
        mov k, 2
        fild k
        fmulp st(1), st(0)
        mov k, 1000000000;  9 çíàêîâ ïîñëå çàïÿòîé
        fild k
        fmulp st(1), st(0)
        fistp x
        
        mov ten, 10
        xor edx, edx
        mov ecx, buffer
        mov esi, 0
        mov eax, dword ptr x
        
        cmp eax, 0
        jge positive
        mov byte ptr [ecx + esi], '-'
        inc esi
        neg eax
        
        positive:
        div k
        mov ebx, edx
        add al, '0'
        mov byte ptr [ecx + esi], al
        inc esi
        mov byte ptr [ecx + esi], '.'
        inc esi

        xor edx, edx
        mov eax, k
        div ten
        mov k, eax
;jmp zeroing
        float:
        xor edx, edx
        mov eax, ebx
        div k
        mov ebx, edx
        add al, '0'
        mov byte ptr [ecx + esi], al
        inc esi
        xor edx, edx
        mov eax, k
        div ten
        mov k, eax
        cmp eax, 0
        jne float
        
        zeroing:
        mov byte ptr [ecx + esi], 0
        inc esi
        cmp esi, 15
        jb zeroing

        invoke MessageBox,hWin,buffer,SADD("Result"),MB_OK
        jmp nxt
      @@:
        invoke MessageBox,hWin,SADD("You did not enter any number"),
                               SADD("No text to display"),MB_OK
      nxt:
        invoke GlobalFree,buffer

      .elseif wParam == IDCANCEL
        jmp quit_dialog
      .endif

    .elseif uMsg == WM_CLOSE
      quit_dialog:
      invoke EndDialog,hWin,0

    .endif

    xor eax, eax
    ret

dlgproc endp

;¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

end start