data segment
    A DW 0F25AH, 0C5C6H, 0E230H,09FFH,0EDDDH,0F25AH,0FFF7H,0536H,0A521H,0010H,9D11H,0E212H,6513H,0AA14H,1115H,0216H,0AA17H,0018H,3519H,2620H,1221H,4922H,0323H,0024H,0DD25H,0F226H,0F227H,0F227H,0369H,0D030H,0991H,0CC32H,7733H,1134H,0035H,0036H,9F37H,0E538H,0A039H,0040H,0041H,5642H,0B043H,0B904H,0045H,0046H,0A347H,0048H,0049H,0DD50H
         ;0001H, 0002H, 0003H,0004H,0005H,0006H,0007H,0008H,0009H,0010H,0011H,0012H,0013H,0014H,0015H,0016H,0017H,0018H,0019H,0020H,0021H,0022H,0023H,0024H,0025H,0026H,0027H,0028H,0029H,0030H,0031H,0032H,0033H,0034H,0035H,0036H,0037H,0038H,0039H,0040H,0041H,0042H,0043H,0044H,0045H,0046H,0047H,0048H,0049H,0050H
         ;0FF01H, 0FE02H, 0FD03H,0FC04H,0FB05H,0FA06H,0F007H,0EF08H,0EE09H,0ED10H,0EC11H,0EB12H,0EA13H,0E914H,0E815H,0E716H,0E617H,0E518H,0E419H,0E320H,0E221H,0E122H,0E023H,0DF24H,0DE25H,0DD26H,0DC27H,0DB28H,0DA29H,0D930H,0D831H,9932H,9833H,9734H,9635H,9536H,9437H,9338H,9239H,9140H,9041H,8942H,8843H,8744H,8645H,8546H,8447H,8348H,8249H,3350H
    key DW 0H            ;每次选最后一个元素作为key
ends

stack segment
    dw  800 dup(0)
    TOP EQU 800
ends

code segment
start:
    MOV AX, data
    MOV DS, AX
    MOV AX, stack
    MOV SS, AX
    MOV SP, TOP
       
    MOV AX, 0            ;a[0]到a[49]快速排序
    MOV BX, 98           
    CALL QSORT
     
    MOV key,0    
    mov ax, 4c00h
    int 21h  
     
        
QSORT PROC NEAR          ;快排子程序
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    CMP AX, BX           ;AX<BX才进行排序
    JNC ENDL
    
    CALL PART            ;调用PART子程序，DX储存key的位置
     
    MOV CX, BX           ;AX到DX-2排序
    MOV BX, DX
    SUB BX, 2
    
    CMP DX, AX           ;AX=DX时，只快排后半段
    JZ QSB
    CALL QSORT
    
  QSB:MOV AX, BX         ;DX+2到BX排序
      MOV BX, CX
      ADD AX, 4
      
      CMP BX, DX
      JZ ENDL            ;DX=BX时，只排前半段 
      
      CALL QSORT 
    
ENDL:POP DX
     POP CX
     POP BX
     POP AX
     RET
QSORT ENDP    
 
   
PART PROC NEAR           ;PART子程序
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI
        
    MOV SI, BX
    MOV CX,[SI]
    MOV key,CX           ;选最后一个元素为key
    MOV DX, AX           ;AX之前的元素<=key,AX到DX之间的元素>key
    SUB AX, 2
    
LOOPA:MOV SI, DX
      MOV CX, [SI]
      CMP key, CX    
      JNC NTH
      JC  JOG
      NTH:ADD AX, 2
          MOV SI,AX
          MOV CX,[SI]    ;CX=A[i]
          MOV DI, DX     ;DI=j
          MOV DX,[DI]    ;DX=A[j]
          MOV [SI],DX    ;交换
          MOV [DI],CX
          MOV DX, DI
             
      JOG:ADD DX, 2
          MOV SI, BX
          SUB SI,2
          CMP SI,DX
          JNC LOOPA
    
    ADD AX, 2
    MOV SI,AX
    MOV CX,[SI]    ;CX=A[i]
    MOV DX,[BX]    ;DX=A[r]
    MOV [SI],DX    ;交换
    MOV [BX],CX
    MOV DX, AX      
                    
    POP DI
    POP SI
    POP CX
    POP BX
    POP AX
    RET
PART ENDP
    
ends
end start
