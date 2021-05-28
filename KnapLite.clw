
  PROGRAM

!KnapLite: KnapSack without UI and Clarion malloc version only
!v1.0 2021-04-11 by Federico Navarro: resimplification of previously made project

  MAP
    MODULE('KnapCla.cla')
      FindInvoicesClarion  (LONG     MyEIP,*LONG[] AmountsMatrix,*LONG[] InvoicesArray)   !Find first solution implemented with Clarion code
    END
    MODULE('KnapC.c')
      FindInvoicesC        (LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray),RAW,NAME('_FindInvoicesC')
    END
    MODULE('KnapAsm.a')
      FindInvoicesAssembler(LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray),NAME('asmknapsack')
      RunProcess           (LONG TargetEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray),NAME('processdispatcher')
    END
    MODULE('KnapMod.mod')
      FindInvoicesModula2  (LONG AmountArraySize,LONG AmountsArray,LONG InvoicesArraySize,LONG InvoicesArray),NAME('KnapMod$modknapsack')
    END
    Main
  END

  CODE
  
  Main
  
Main                 PROCEDURE

MyArray              LONG,DIM(8)                           ! 
MyResult             CSTRING(100)                          ! 

ResultSt             CSTRING(500)

ThisArray            &STRING   

nRows                LONG
nTarget              LONG
HighIndex            LONG
LowIndex             LONG

ThisArrayCell        &LONG

ThisArrayBaseAddr    LONG

CellSize             EQUATE(SIZE(nTarget)) !4

  CODE

  ResultSt       = ''
  nRows          = 8  !array length:keep this value equal o less the size of MyArray
  nTarget        = 20 !target sum

  myArray[1]     = 7  !invoices' values
  myArray[2]     = 1
  myArray[3]     = 5
  myArray[4]     = 3
  myArray[5]     = 8
  myArray[6]     = 2

  ThisArray            &= NEW STRING((ntarget+1)*CellSize*2) !* both Sum&Results
  ThisArrayBaseAddr     = ADDRESS(ThisArray)

  ResultSt = 'Find first solution to knapsack 0-1 for '
  LOOP LowIndex = 1 TO nRows
    ResultSt = ResultSt & CHOOSE(MyArray[LowIndex]>0,CHOOSE(LowIndex=1,'',',') & MyArray[LowIndex],'')
  END
  ResultSt = ResultSt & ' with target sum ' & nTarget & '<13,10>'
  DO PrepareArray 
  RunProcess(ADDRESS(FindInvoicesClarion),nTarget*2+2,ADDRESS(ThisArray),nRows,ADDRESS(myArray))
  !Using RunProcess avoids compiler type mismatch verification on Clarion prototypes
  ! to allow the string buffer passed by address be represented on the destination
  ! as an array of Integers
  DO GetResult
  ResultSt = ResultSt & 'FindInvoicesClarion: '   & MyResult & '<13,10>'
 
  DO PrepareArray 
  FindInvoicesC        (0,nTarget,ADDRESS(ThisArray),nRows,ADDRESS(myArray))
  DO GetResult
  ResultSt = ResultSt & 'FindInvoicesC: '         & MyResult & '<13,10>'
 
  DO PrepareArray 
  FindInvoicesAssembler(0,nTarget,ADDRESS(ThisArray),nRows,ADDRESS(myArray))
  DO GetResult
  ResultSt = ResultSt & 'FindInvoicesAssembler: ' & MyResult & '<13,10>'

  MESSAGE('Press OK') !release version needed this for some init previous to call Modula-2
  DO PrepareArray 
  FindInvoicesModula2(SIZE(ThisArray),ADDRESS(ThisArray),nRows*CellSize,ADDRESS(myArray)) !,nTarget,nRows)
  DO GetResult
  ResultSt = ResultSt & 'FindInvoicesModula2: ' & MyResult & '<13,10>'

  ThisArrayCell        &= NULL
  DISPOSE(ThisArray)

  MESSAGE(ResultSt) 

PrepareArray ROUTINE
  CLEAR(ThisArray,1)
  ThisArrayCell        &= ThisArrayBaseAddr + 0
  ThisArrayCell         = 0

GetResult ROUTINE
         MyResult = ''
         ThisArrayCell        &= ThisArrayBaseAddr +  nTarget             * CellSize  
         if ThisArrayCell <> -1
           lowIndex            = ntarget
           LOOP while lowIndex>0
             highIndex         = lowIndex
             ThisArrayCell    &= ThisArrayBaseAddr + (nTarget+lowIndex+1) * CellSize
             lowIndex          = ThisArrayCell
             MyResult          = (highIndex-lowIndex) & CHOOSE(MyResult='','',',') & MyResult
           END
         END
