(*
    Knapsack Algorithm for Clarion Integrated Assembler compiler
    
    Linked Array version
    
    Implemented by Federico Navarro
    
    Based on C implementation provided by Andrej Koselj
    
    Hints on assembler implementations
    Provided by Dave Nichols on his zd_fast.a memory allocator  www.match-it.com,
     which also references:
    Hints from Bruce Johnson from Capesoft www.capesoft.com
    Thanks to Brahn there is more info at http://clarionhub.com/tags/asm
    https://groups.google.com/forum/#!topic/comp.lang.clarion/g0JeqQvVb_A
    
    For a general Assembler introduction refer to
    http://www.cs.virginia.edu/~evans/cs216/guides/x86.html
    (although as mentioned on previous sources this implementation differs 
    on several aspects, like syntax and calling convention)
        
    Description and links for Knapsack
    https://en.wikipedia.org/wiki/Knapsack_problem
    Comparing between different approaches to solve the 0/1 Knapsack problem 
    http://paper.ijcsns.org/07_book/201607/20160701.pdf
    Free download of the book "Knapsack problems: Algorithms and computer implementations", by Silvano Martello and Paolo TothLecture slides on the knapsack problem
    http://www.or.deis.unibo.it/knapsack.html
    Lecture slides on the knapsack problem
    http://cse.unl.edu/~goddard/Courses/CSCE310J/Lectures/Lecture8-DynamicProgramming.pdf    
       
        
    Version History
    2017-08-29 First release
    2017-09-07 Adapted for algorithm selector
               Other experimental variations
    2021-05-26 Moved parameter positions for standarization, ie array size previous to
                its address, exception is targetSum which is half minus one the size
               Change disposition of thisArray non interleaving Sums and Results for 
                up to 40% faster processing
                
    parameters:
    eax: ADDRESS(asmknapsack)   - This function - not used here - it is only for the 
                                  automatic algorithm selector
    ebx: targetSum              - Payment Amount (integer). It is also the elements count less 1
                                  of the first dimension of thisArray, the second 
                                  dimension is always 2. Total elements (targetsum+1)*2.
    ecx: ADDRESS(thisArray)     - Working array for the algorithm preinitialized -1 on each cell
                                  (except the first one which has to arrive with 0) "AmountsMatrix"
    edx: nRows                  - Elements count of invoiceArray
    [(new)ebp]+8: 
         ADDRESS(invoicesArray) - Array of Integers with amount values (with 2 decimals
                                  they need to be multiplyed by 100 and rounded)
    
    local variables:
    ebp+8 ADDRESS(invoicesArray) (being there as 5th parameter on Clarion calling convention)
    ebp-4 i (initialized with 0)
    ebp-8 nRows                  (pushed there to free edx)

    registers: 
    eax: temporal comparations and swappings 
    ebx: targetSum
    ecx: ADDRESS(thisArray)
    edx: j
    esi: nextsum
    edi: precomputed pointer to nextsum cell
    
    Note: Registers where choosen intentionally for the massively used data while 
    stack memory for the less used ones. Also the algorithm was adapted in a 
    logically equivalent way to reduce memory access.
*)

(* Segment Attributes *)

USE16             = 00H
USE32             = 01H

ABS_ALIGN         = 00H
BYTE_ALIGN        = 20H
WORD_ALIGN        = 40H
PARA_ALIGN        = 60H
PAGE_ALIGN        = 80H
DWORD_ALIGN       = 0A0H

DONT_COMBINE      = 00H
MEMORY_COMBINE    = 04H
PUBLIC_COMBINE    = 08H
STACK_COMBINE     = 14H
COMMON_COMBINE    = 18H

(*T _WIN32*)

segment _TEXT(CODE, USE32 + DWORD_ALIGN + PUBLIC_COMBINE)

(* start alignment *)

  align 8
  db 90H; db 90H; db 90H; db 90H; db 90H; db 90H; db 90H; db 90H;

(* Sv Assembler Algorithm *)

public asmknapsack:

  (* prologue *)
  push ebp
  mov ebp, esp

  (* allocate and initialize local vars *)
  push dword 0                   (* reserves space for i=0 *)
  push edx                       (* nRows - register will be used by j index *) 
  
  (* save non volatile registers *)
  push edi
  push esi
  
  (* algorithm body *)
  
invoicesLoopBegin:               (* for *)
  mov eax,[ebp][-4]              (* (i  *)
  cmp eax,[ebp][-8]              (*  i ? nRows *)
  jge invoicesLoopEnd            (*  i < nRows *)

    mov edx, 0                   (* j = 0 *)
    shl eax, 2                   (* i = i * 4  arm invoice i cell address *) 
    add eax, [ebp][ 8]           (* i = i + ADDRESS(invoicesArray) *)

    mov esi, [eax]               (* nextsum = invoicesArray[i]  start value *)
amountsLoopBegin:
      add esi, edx               (* nextsum = nextsum + j  *)

      lea edi, [ecx][esi*4]      (* edi = ADDRESS(thisArray) + nextsum * 4  *)
      mov eax, [ecx][edx*4]      (* eax =         thisArray[0][j]           *)

      cmp esi, ebx               (* nextsum ? targetsum *)
      jg afterSwapping           (* nextsum > targetsum skip swaps *)

      cmp dword [edi], -1        (* thisArray[0][nextSum] ? -1 *)
      jne afterSwapping          (* thisArray[0][nextSum] = -1 skip swaps *)

                                 (* if not (nextSum > targetSum || ThisArray[0][nextSum] != -1) *) 
      mov [edi], eax             (* thisArray[0][nextSum] = thisArray[0][j] *)
      mov [ecx][edx*4], esi      (* thisArray[0][j      ] = nextsum         *)
      mov [edi][ebx*4][4], edx   (* thisArray[1][nextSum] = j               *)

afterSwapping:
      sub esi, edx               (* nextsum = nextsum - j --> nextsum = invoicesArray[i] *)
      mov edx, eax               (* j = thisArray[0][j] (the original not the modified on swappings) *)
      cmp edx, 0                 (* j ? 0 *)
      jg amountsLoopBegin        (* j > 0 loop (--> else break) *)
      
    cmp dword [ecx][ebx*4], -1   (* (ThisArray[0][targetSum]  ? -1)         *)
    jne invoicesLoopEnd          (* (ThisArray[0][targetSum] != -1) break   *)

  inc dword [ebp][-4]            (* i++ *)
  jmp invoicesLoopBegin          (* end for *)

invoicesLoopEnd:                 (* after end for *)

  (* epilogue *)

  (* restore non volatile registers *)
  pop esi
  pop edi

  (* free local vars and restore ebp *)
  mov esp, ebp
  pop ebp
  

  (* return to caller with 4 because of 5th parameter after the return address *)
  
  ret 4                          (* caller now have the results on the 
                                    the linked array AmountsMatrix *)


(* impact test of minimal changes: *)
(* an experimental test usign an extra register to hold the invoicesArray[i] start value of the
   internal loop, thus avoiding substracting j from nextsum to get it back to its original value
   on each cycle. An extra register, an extra mov and avoiding a sub introduced an improvement
   aproximatelly 0,6% 28 sec in a 4716 seconds test (30 repetitions of 158sec aproximatelly each).
   Problem was there seems no more accesible registers on this assembler implementation (no r8d xmm8..)
   so test were done with ebp register, but discarded as the improvement was not so significant
   and using that register it that way is not standard and causes debugger to loose the call stack trace 
   when the algorithm is running *)


(* Algorithm selector *)

(* Only to call procedures using the clarion calling convention, do not use
   with procedures using C / PASCAL calling convention (or adapt) *)


public processdispatcher:
  jmp eax                        (* indirect branch *)

(* this technique seems the easiest way but required an extra first parameter (integer) on each procedure called *)
(* other way could be adapting this to issue a new call to the target procedure (push mov call pop ret) *)

(* end alignment *)

  db 90H; db 90H; db 90H; db 90H; db 90H; db 90H; db 90H; db 90H;
  
  (*%E*)
