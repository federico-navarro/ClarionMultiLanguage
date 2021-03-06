!Derived from the C implementation of KnapSack 0/1 using Memoization 
!and Linked Lists provided by Andrej Koselj 

  MEMBER('KnapLite')

FindInvoicesClarion PROCEDURE(LONG MyEIP,*LONG[] thisArray,*LONG[] invoiceArray) ! Declare Procedure
i                    LONG                                  ! 
j                    LONG                                  ! 
nextSum              LONG                                  ! 
targetSum            LONG                                  ! 
nRows                LONG                                  ! 

  CODE
 
     targetSum = MAXIMUM(thisArray   ,1) / 2 - 1
     nRows     = MAXIMUM(invoiceArray,1)
     
     LOOP i=0 TO nRows - 1
         j=0
         LOOP
             nextSum                    = invoiceArray   [i+1] + j
             IF nextSum > targetSum   OR  thisArray[nextSum+1] <> -1
                 j                      = thisArray      [j+1]
             ELSE
                 thisArray[nextSum+1]   = thisArray      [j+1]
                 thisArray      [j+1]   = nextSum
                 thisArray[nextSum+targetSum+2] = j
                 j                      = thisArray[nextSum+1]
             END
             if (j<=0) THEN BREAK END
         END
         if thisArray[targetSum+1] <> -1 THEN BREAK END
     END
