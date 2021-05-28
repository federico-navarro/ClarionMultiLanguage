(*
    Knapsack Algorithm for Clarion Integrated Modula-2 compiler
    
    Linked Array version
    
    Implemented by Federico Navarro  2021
    
    Based on C implementation provided by Andrej Koselj
    
    See TopSpeed Modula-2 Language and Library Reference available on c5 (and others) docs
    
    Using INTEGER type, which although Language Reference states -32768 to 32767,
    debugger shows it uses 32 bits as LONGINT. Compiler refuses a LONGINT as
    an array index.
    
    Array parameters internally uses two parameters: SIZE and ADDRESS, being
    the size the number of rows by the cell size (4 bytes), if passing only
    the rows, Index out of range would raise. Clarion Debugger shows the
    array size incorrectly on the inspection window.
    Even it seems there is a misunderstanding between Clarion and Modula-2
    compilers because a passing *LONG[] on Clarion prototype, and receiving
    a VAR ARRAY OF INTEGER on Modula-2, Clarion sends the size parameter as
    number of rows and Modula-2 expects in bytes, so the workaround is a 
    LONG ArraySize,LONG ArrayAddress prototype on Clarion side.
    
    Other interesting links:
    https://www.modula2.org/reference/index.php
    https://people.inf.ethz.ch/wirth/
    https://en.wikipedia.org/wiki/Niklaus_Wirth
    https://www.icetips.com/downloads.php?dl=PAR2
    https://www.icetips.com/par2downloads/M2WinLib.ZIP
    https://web.archive.org/web/20090427041534/http://www.excelsior-usa.com/tscp.html
    https://web.archive.org/web/20090428035921/http://www.excelsior-usa.com/doc/xc.html
    https://web.archive.org/web/20200629053835/http://rosettacode.org/wiki/Category:Modula-2   

    Version History
    2021-04-05 First release
    2021-05-26 Change disposition of thisArray non interleaving Sums and Results
                for up to 40% faster processing
    *)

IMPLEMENTATION MODULE KnapMod;
    
PROCEDURE modknapsack(VAR thisArray : ARRAY OF INTEGER ; VAR invoiceArray : ARRAY OF INTEGER );
    
 VAR
    i, j, nextSum, nRows, targetSum: INTEGER; 
    
 BEGIN
     nRows := HIGH(invoiceArray) + 1;
     targetSum := (HIGH(thisArray) - 1) DIV 2;
     i := 0;
     REPEAT
         j := 0;
         REPEAT
             nextSum                            := invoiceArray   [i] + j;
             IF ((nextSum > targetSum)     OR     (thisArray[nextSum] <> -1)) THEN
                 j                              := thisArray      [j];
             ELSE
                 thisArray          [nextSum]   := thisArray      [j];
                 thisArray                [j]   := nextSum;
                 thisArray[targetSum+nextSum+1] := j;
                 j                              := thisArray[nextSum];
             END;
         UNTIL (j<=0);
         i := i + 1;
     UNTIL ((i >= nRows) OR (thisArray[targetSum] <> -1));
   END modknapsack;
END KnapMod.
