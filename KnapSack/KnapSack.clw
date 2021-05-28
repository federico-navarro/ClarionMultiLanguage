   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
     MODULE('KNAPSACK_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('KNAPSACK001.CLW')
Main                   PROCEDURE   !Wizard Application for E:\test\KnapLite\KnapSack\KnapSack.dct
MarkTime               FUNCTION(<*Long ParStartDate>,<*Long ParStartTime>,<Long DontReset>),Long,Proc   !Stopwatch
FindInvoicesModula2Wrapper PROCEDURE(LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray)   !Prototype Adapter to Modula-2 Algorithm
FindInvoicesClarionWrapper PROCEDURE(LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray)   !Prototype Adapter to Clarion Algorithm
     END
         MODULE('KnapCla.clw')
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
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Invoices             FILE,DRIVER('TOPSPEED'),PRE(Inv),CREATE,BINDABLE,THREAD ! Invoices            
KeyID                    KEY(Inv:InvoiceID),NOCASE,PRIMARY ! By ID               
Record                   RECORD,PRE()
InvoiceID                   LONG                           !                     
Amount                      LONG                           !                     
                         END
                     END                       

Knapsacks            FILE,DRIVER('TOPSPEED'),PRE(Kna),CREATE,BINDABLE,THREAD !                     
KeyID                    KEY(Kna:KnapsackID),NOCASE,PRIMARY ! By ID               
Record                   RECORD,PRE()
KnapsackID                  LONG                           !                     
StartDate                   LONG                           !                     
StartTime                   LONG                           !                     
PaymentAmount               LONG                           !                     
InvoicesCount               LONG                           !                     
MinAmount                   LONG                           !                     
AvgAmount                   LONG                           !                     
MaxAmount                   LONG                           !                     
BrokenLinks                 LONG                           !                     
Algorithm                   CSTRING(21)                    !                     
Allocation                  CSTRING(21)                    !                     
Implementation              CSTRING(21)                    !                     
InitTime                    LONG                           !                     
ProcessTime                 LONG                           !                     
PresentTime                 LONG                           !                     
InvoicesSelected            LONG                           !                     
SelMinInvoiceID             LONG                           !                     
SelAvgInvoiceID             LONG                           !                     
SelMaxInvoiceID             LONG                           !                     
SelMinAmount                LONG                           !                     
SelAvgAmount                LONG                           !                     
SelMaxAmount                LONG                           !                     
Notes                       CSTRING(61)                    !                     
ProcessorSpecs              CSTRING(101)                   !                     
                         END
                     END                       

Selections           FILE,DRIVER('TOPSPEED'),PRE(Sel),CREATE,BINDABLE,THREAD !                     
KeyKnaID                 KEY(Sel:KnapsackID,Sel:SelectionOrder),NOCASE,PRIMARY !                     
KeyInvID                 KEY(Sel:InvoiceIDMatched,Sel:KnapsackID),NOCASE !                     
Record                   RECORD,PRE()
KnapsackID                  LONG                           !                     
SelectionOrder              LONG                           !                     
Amount                      LONG                           !                     
InvoiceIDMatched            LONG                           !                     
                         END
                     END                       

!endregion

Access:Invoices      &FileManager,THREAD                   ! FileManager for Invoices
Relate:Invoices      &RelationManager,THREAD               ! RelationManager for Invoices
Access:Knapsacks     &FileManager,THREAD                   ! FileManager for Knapsacks
Relate:Knapsacks     &RelationManager,THREAD               ! RelationManager for Knapsacks
Access:Selections    &FileManager,THREAD                   ! FileManager for Selections
Relate:Selections    &RelationManager,THREAD               ! RelationManager for Selections

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\KnapSack.INI', NVD_INI)                   ! Configure INIManager to use INI file
  DctInit()
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

