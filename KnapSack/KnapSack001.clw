

   MEMBER('KnapSack.clw')                                  ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('KNAPSACK001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Frame
!!! Wizard Application for E:\test\KnapLite\KnapSack\KnapSack.dct
!!! </summary>
Main PROCEDURE 

AppFrame             APPLICATION('ClarionMultiLanguage KnapSack project'),AT(,,505,318),FONT('Microsoft Sans Serif', |
  8,,FONT:regular,CHARSET:DEFAULT),RESIZE,CENTER,ICON('WAFRAME.ICO'),MAX,STATUS(-1,80,120, |
  45),SYSTEM,IMM
                       MENUBAR,USE(?Menubar)
                         MENU('&File'),USE(?FileMenu)
                           ITEM('Browse Invoices and Knapsack Console'),USE(?KnapConsole)
                           ITEM('About and Version History'),USE(?Version)
                           ITEM('&Print Setup ...'),USE(?PrintSetup),MSG('Setup printer'),STD(STD:PrintSetup)
                           ITEM,USE(?SEPARATOR1),SEPARATOR
                           ITEM('E&xit'),USE(?Exit),MSG('Exit this application'),STD(STD:Close)
                         END
                         MENU('&Edit'),USE(?EditMenu)
                           ITEM('Cu&t'),USE(?Cut),MSG('Cut Selection To Clipboard'),STD(STD:Cut)
                           ITEM('&Copy'),USE(?Copy),MSG('Copy Selection To Clipboard'),STD(STD:Copy)
                           ITEM('&Paste'),USE(?Paste),MSG('Paste From Clipboard'),STD(STD:Paste)
                         END
                         MENU('&Window'),USE(?WindowMenu),STD(STD:WindowList)
                           ITEM('T&ile'),USE(?Tile),MSG('Arrange multiple opened windows'),STD(STD:TileWindow)
                           ITEM('&Cascade'),USE(?Cascade),MSG('Arrange multiple opened windows'),STD(STD:CascadeWindow)
                           ITEM('&Arrange Icons'),USE(?Arrange),MSG('Arrange the icons for minimized windows'),STD(STD:ArrangeIcons)
                         END
                         MENU('&Help'),USE(?HelpMenu)
                           ITEM('&Contents'),USE(?Helpindex),MSG('View the contents of the help file'),STD(STD:HelpIndex)
                           ITEM('&Search for Help On...'),USE(?HelpSearch),MSG('Search for help on a subject'),STD(STD:HelpSearch)
                           ITEM('&How to Use Help'),USE(?HelpOnHelp),MSG('Provides general instructions on using help'), |
  STD(STD:HelpOnHelp)
                         END
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
Menu::Menubar ROUTINE                                      ! Code for menu items on ?Menubar
Menu::FileMenu ROUTINE                                     ! Code for menu items on ?FileMenu
  CASE ACCEPTED()
  OF ?KnapConsole
    START(Invoices, 25000)
  OF ?Version
    START(Version, 25000)
  END
Menu::EditMenu ROUTINE                                     ! Code for menu items on ?EditMenu
Menu::WindowMenu ROUTINE                                   ! Code for menu items on ?WindowMenu
Menu::HelpMenu ROUTINE                                     ! Code for menu items on ?HelpMenu

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = 1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.Open(AppFrame)                                      ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('Main',AppFrame)                            ! Restore window settings from non-volatile store
  SELF.SetAlerts()
      AppFrame{PROP:TabBarVisible}  = False
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',AppFrame)                         ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE ACCEPTED()
    ELSE
      DO Menu::Menubar                                     ! Process menu items on ?Menubar menu
      DO Menu::FileMenu                                    ! Process menu items on ?FileMenu menu
      DO Menu::EditMenu                                    ! Process menu items on ?EditMenu menu
      DO Menu::WindowMenu                                  ! Process menu items on ?WindowMenu menu
      DO Menu::HelpMenu                                    ! Process menu items on ?HelpMenu menu
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Invoices file 
!!! </summary>
Invoices PROCEDURE 

CurrentTab           STRING(80)                            ! 
CurrentProcess       CSTRING(81)                           ! 
AlgorithmsQueue      QUEUE,PRE()                           ! 
Description          CSTRING(51)                           ! 
Algorithm            CSTRING(21)                           ! 
Allocation           CSTRING(21)                           ! 
Implementation       CSTRING(21)                           ! 
ProcedureAddress     LONG                                  ! 
RepeatOrder          LONG                                  ! 
                     END                                   ! 
CurrentKnapsack      LONG                                  ! 
InvoicesQueue        QUEUE,PRE()                           ! 
Amount               LONG                                  ! 
NewOrder             LONG                                  ! 
                     END                                   ! 
DeleteAndLoad        LONG                                  ! 
GenerationType       STRING('R')                           ! 
InitialAmount        LONG                                  ! 
LimitAmount          LONG                                  ! 
CountStep            LONG                                  ! 
SortType             STRING('S')                           ! 
LastID               LONG                                  ! 
ProgressBar          LONG                                  ! 
CT                   LONG                                  ! 
InvoicesCount        LONG                                  ! 
InvoicesArray        &STRING                               ! 
InvoicesCell         &LONG                                 ! 
PaymentAmount        LONG                                  ! 
AmountsMatrix        &STRING                               ! 
AmountsCell          &LONG                                 ! 
SelAmount            LONG                                  ! 
lowIndex             LONG                                  ! 
highIndex            LONG                                  ! 
Notes                CSTRING(61)                           ! 
NotesBackup          CSTRING(61)                           ! 
AbortProcess         LONG                                  ! 
CurrentStep          LONG                                  ! 
CurrentAlgorithm     LONG                                  ! 
CurrentRepetition    LONG                                  ! 
DoNotDispose         LONG                                  ! 
PreAllocated         LONG                                  ! 
Repetitions          LONG                                  ! 
BRW1::View:Browse    VIEW(Invoices)
                       PROJECT(Inv:InvoiceID)
                       PROJECT(Inv:Amount)
                       JOIN(Knapsacks,'Kna:KnapsackID = CurrentKnapsack AND Kna:BrokenLinks = 0')
                         PROJECT(Kna:KnapsackID)
                         JOIN(Selections,'SEL:KnapsackID = Kna:KnapsackID AND SEL:InvoiceIDMatched=INV:InvoiceID')
                           PROJECT(Sel:SelectionOrder)
                         END
                       END
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
Inv:InvoiceID          LIKE(Inv:InvoiceID)            !List box control field - type derived from field
Inv:Amount             LIKE(Inv:Amount)               !List box control field - type derived from field
Sel:SelectionOrder     LIKE(Sel:SelectionOrder)       !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW2::View:Browse    VIEW(Knapsacks)
                       PROJECT(Kna:KnapsackID)
                       PROJECT(Kna:StartDate)
                       PROJECT(Kna:StartTime)
                       PROJECT(Kna:PaymentAmount)
                       PROJECT(Kna:InvoicesCount)
                       PROJECT(Kna:MinAmount)
                       PROJECT(Kna:AvgAmount)
                       PROJECT(Kna:MaxAmount)
                       PROJECT(Kna:BrokenLinks)
                       PROJECT(Kna:Algorithm)
                       PROJECT(Kna:Allocation)
                       PROJECT(Kna:Implementation)
                       PROJECT(Kna:InitTime)
                       PROJECT(Kna:ProcessTime)
                       PROJECT(Kna:PresentTime)
                       PROJECT(Kna:InvoicesSelected)
                       PROJECT(Kna:SelMinInvoiceID)
                       PROJECT(Kna:SelAvgInvoiceID)
                       PROJECT(Kna:SelMaxInvoiceID)
                       PROJECT(Kna:SelMinAmount)
                       PROJECT(Kna:SelAvgAmount)
                       PROJECT(Kna:SelMaxAmount)
                       PROJECT(Kna:Notes)
                       PROJECT(Kna:ProcessorSpecs)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
Kna:KnapsackID         LIKE(Kna:KnapsackID)           !List box control field - type derived from field
Kna:StartDate          LIKE(Kna:StartDate)            !List box control field - type derived from field
Kna:StartTime          LIKE(Kna:StartTime)            !List box control field - type derived from field
Kna:PaymentAmount      LIKE(Kna:PaymentAmount)        !List box control field - type derived from field
Kna:InvoicesCount      LIKE(Kna:InvoicesCount)        !List box control field - type derived from field
Kna:MinAmount          LIKE(Kna:MinAmount)            !List box control field - type derived from field
Kna:AvgAmount          LIKE(Kna:AvgAmount)            !List box control field - type derived from field
Kna:MaxAmount          LIKE(Kna:MaxAmount)            !List box control field - type derived from field
Kna:BrokenLinks        LIKE(Kna:BrokenLinks)          !List box control field - type derived from field
Kna:Algorithm          LIKE(Kna:Algorithm)            !List box control field - type derived from field
Kna:Allocation         LIKE(Kna:Allocation)           !List box control field - type derived from field
Kna:Implementation     LIKE(Kna:Implementation)       !List box control field - type derived from field
Kna:InitTime           LIKE(Kna:InitTime)             !List box control field - type derived from field
Kna:ProcessTime        LIKE(Kna:ProcessTime)          !List box control field - type derived from field
Kna:PresentTime        LIKE(Kna:PresentTime)          !List box control field - type derived from field
Kna:InvoicesSelected   LIKE(Kna:InvoicesSelected)     !List box control field - type derived from field
Kna:SelMinInvoiceID    LIKE(Kna:SelMinInvoiceID)      !List box control field - type derived from field
Kna:SelAvgInvoiceID    LIKE(Kna:SelAvgInvoiceID)      !List box control field - type derived from field
Kna:SelMaxInvoiceID    LIKE(Kna:SelMaxInvoiceID)      !List box control field - type derived from field
Kna:SelMinAmount       LIKE(Kna:SelMinAmount)         !List box control field - type derived from field
Kna:SelAvgAmount       LIKE(Kna:SelAvgAmount)         !List box control field - type derived from field
Kna:SelMaxAmount       LIKE(Kna:SelMaxAmount)         !List box control field - type derived from field
Kna:Notes              LIKE(Kna:Notes)                !List box control field - type derived from field
Kna:ProcessorSpecs     LIKE(Kna:ProcessorSpecs)       !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW7::View:Browse    VIEW(Selections)
                       PROJECT(Sel:KnapsackID)
                       PROJECT(Sel:SelectionOrder)
                       PROJECT(Sel:Amount)
                       PROJECT(Sel:InvoiceIDMatched)
                     END
Queue:Browse:2       QUEUE                            !Queue declaration for browse/combo box using ?List:2
Sel:KnapsackID         LIKE(Sel:KnapsackID)           !List box control field - type derived from field
Sel:SelectionOrder     LIKE(Sel:SelectionOrder)       !List box control field - type derived from field
Sel:Amount             LIKE(Sel:Amount)               !List box control field - type derived from field
Sel:InvoiceIDMatched   LIKE(Sel:InvoiceIDMatched)     !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse the Invoices file / Browse knapsacks and selections'),AT(,,530,390),FONT('Microsoft ' & |
  'Sans Serif',8,,FONT:regular,CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MAX,MDI,HLP('Invoices'), |
  SYSTEM
                       LIST,AT(3,2,156,250),USE(?Browse:1),HVSCROLL,FORMAT('44R(2)|M~Invoice ID~C(0)@n9@44R(2)' & |
  '|M~Amount~C(0)@n10@36R(2)|M~Selection Order~C(1)@n9b@'),FROM(Queue:Browse:1),IMM,MSG('Browsing t' & |
  'he Invoices file')
                       BUTTON('&Insert'),AT(164,2,104,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Change (Break links)'),AT(164,20,104,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'), |
  MSG('Change the Record'),TIP('Change the Record')
                       BUTTON('&Delete (Break links)'),AT(164,38,104,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'), |
  MSG('Delete the Record'),TIP('Delete the Record')
                       OPTION('Generation Type:'),AT(164,55,104,50),USE(GenerationType),BOXED
                         RADIO('Random'),AT(169,66),USE(?GenerationType:Radio1)
                         RADIO('Incremental'),AT(169,79),USE(?GenerationType:Radio2)
                         RADIO('Decremental'),AT(169,92),USE(?GenerationType:Radio3)
                       END
                       PROMPT('Initial Amount:'),AT(167,114),USE(?InitialAmount:Prompt)
                       ENTRY(@n11),AT(219,114,48,10),USE(InitialAmount),RIGHT(1)
                       PROMPT('Limit Amount:'),AT(167,129),USE(?LimitAmount:Prompt)
                       ENTRY(@n11),AT(219,127,48,10),USE(LimitAmount),RIGHT(1)
                       PROMPT('Count Step:'),AT(167,140),USE(?CountStep:Prompt)
                       ENTRY(@n9),AT(219,140,48,10),USE(CountStep),RIGHT(1)
                       OPTION('Sort Type:'),AT(164,175,104,50),USE(SortType),BOXED
                         RADIO('Shuffle'),AT(172,186),USE(?SortType:Radio1)
                         RADIO('Ascending'),AT(172,199),USE(?SortType:Radio2)
                         RADIO('Descending'),AT(172,212),USE(?SortType:Radio3)
                       END
                       BUTTON('Generate Invoices'),AT(164,154,104,18),USE(?Generate)
                       BUTTON('Reorder Invoices (Break links)'),AT(164,229,104,18),USE(?Reorder)
                       BUTTON('Delete all Invoices (Break links)'),AT(164,250,104,18),USE(?DeleteInvoices)
                       PROMPT('Current selected KnapSack for above browses (on 1st only with updated links):'),AT(2, |
  252,130,18),USE(?CurrentKnapsack:Prompt:2),FONT(,,,FONT:regular+FONT:underline),TRN
                       SPIN(@n4),AT(134,257,25,10),USE(CurrentKnapsack),RIGHT(1)
                       LIST,AT(3,272,525,95),USE(?List),RIGHT(1),HVSCROLL,FORMAT('20R(2)|M~Kn.ID~C(0)@n4@49L(2' & |
  ')|M~Start Date~C(1)@D10@35R(2)|M~Start Time~C(1)@t4@36R(2)|M~Payment Amount~L(1)@n11' & |
  '@36R(2)|M~Invoices Count~L(1)@n9@36R(2)|M~Min Amount~L(1)@n9@36R(2)|M~Avg Amount~L(1' & |
  ')@n9@36R(2)|M~Max Amount~L(1)@n9@4C|M~Broken Links~L(1)@N~*~1B@50L(2)|M~Algorithm~C(' & |
  '0)@s20@50L(2)|M~Allocation~C(0)@s20@70L(2)|M~Implementation~C(0)@s20@24R(2)|M~Init T' & |
  'ime~L(1)@n_10@24R(2)|M~Process Time~L(1)@n_10@24R(2)|M~Present Time~L(1)@n_10@36R(2)' & |
  '|M~Invoices Selected~L(1)@n9@36R(2)|M~Sel Min Invoice ID~L(1)@n9@36R(2)|M~Sel Avg In' & |
  'voice ID~L(1)@n9@36R(2)|M~Sel Max Invoice ID~L(1)@n9@36R(2)|M~Sel Min Amount~L(1)@n9' & |
  '@36R(2)|M~Sel Avg Amount~L(1)@n9@36R(2)|M~Sel Max Amount~L(1)@n9@240L(2)|M~Notes~L(1' & |
  ')@s60@240L(2)|M~Processor Specs~L(1)@s100@'),FROM(Queue:Browse),IMM
                       LIST,AT(273,3,254,249),USE(?List:2),RIGHT(1),HVSCROLL,FORMAT('50R(2)|M~Knapsack ID~C(1)' & |
  '@n4@60R(2)|M~Selection Order~C(1)@n9@60R(2)|M~Amount~C(1)@n11@36R(2)|M~Invoice ID Ma' & |
  'tched~C(1)@n9@'),FROM(Queue:Browse:2),IMM
                       STRING(@s80),AT(273,252,255),USE(CurrentProcess),CENTER,HIDE,TRN
                       PROGRESS,AT(273,262,255),USE(ProgressBar),HIDE,RANGE(0,100)
                       PROMPT('Payment Amount:'),AT(2,367),USE(?PaymentAmount:Prompt),TRN
                       ENTRY(@n11),AT(3,377,55,10),USE(PaymentAmount),RIGHT(1)
                       PROMPT('Algorithm:'),AT(67,367),USE(?CurrentProcess:Prompt),TRN
                       LIST,AT(67,377,113,10),USE(?AlgorithmList),VSCROLL,DROP(10,150),FORMAT('150L(2)|M@s50@'),FROM(AlgorithmsQueue)
                       BUTTON('Find First Solution'),AT(289,370,73,18),USE(?FindFirstSolution)
                       BUTTON('&Close'),AT(484,370,44,18),USE(?Close),LEFT,ICON('WACLOSE.ICO'),MSG('Close Window'), |
  TIP('Close Window')
                       PROMPT('Notes:'),AT(185,367),USE(?Notes:Prompt),TRN
                       ENTRY(@s60),AT(185,377,99,10),USE(Notes)
                       PROMPT('Repetitions:'),AT(367,367),USE(?Repetitions:Prompt),TRN
                       ENTRY(@n7),AT(367,377,34,10),USE(Repetitions),RIGHT(1)
                       BUTTON('Repeated FFS 3*a#*r#'),AT(404,370,78,18),USE(?RepeatingTest),TIP('Run "Find Fir' & |
  'st Solution" repeated times, according to "Repetitions" value.<0DH,0AH,0DH,0AH>If Re' & |
  'petitions = 1, run "FFS" for every algorithm once.<0DH,0AH,0DH,0AH>If Repetitions > ' & |
  '1, run "FFS" for every algorithm the number of repetitions <0DH,0AH>times in this or' & |
  'der: algorithm 1, repetition 1, repetition 2, ..., repetition n, <0DH,0AH>algorithm ' & |
  '2, r1 r2 .. rn, ... algorithm n, r1 r2 .. rn, plus again run "FFS" for every<0DH,0AH>' & |
  'algorithm the number of repetitions times, but in this order: <0DH,0AH>repetition 1,' & |
  ' all algorithms, repetition 2, all algorithms,..., repetition n, all algorithms, <0DH>' & |
  '<0AH>plus again in this same order but previously shuffling the invoices order rando' & |
  'mly. <0DH,0AH,0DH,0AH>These combinations could help to reduce deviation on results c' & |
  'aused by external factors.')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetFromAsk           PROCEDURE(*BYTE Request,*BYTE Response),DERIVED
SetAlerts              PROCEDURE(),DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort0:StepClass StepLongClass                        ! Default Step Manager
BRW2                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
ScrollEnd              PROCEDURE(SIGNED Event),DERIVED
TakeNewSelection       PROCEDURE(),DERIVED
                     END

BRW2::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW7                 CLASS(BrowseClass)                    ! Browse using ?List:2
Q                      &Queue:Browse:2                !Reference to browse queue
                     END

BRW7::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
DeleteInvoices ROUTINE
  IF DeleteAndLoad
    CurrentProcess = '1/2 Loading and Sorting Invoices'
    FREE(InvoicesQueue)
    InvoicesCount = RECORDS(INVOICES)
  ELSE
    CurrentProcess = '1/1 Deleting Invoices'
  END
  UNHIDE(?CurrentProcess)
  DISPLAY(?CurrentProcess)
  ProgressBar = 1
  ?ProgressBar{PROP:RangeLow } = 1
  ?ProgressBar{PROP:RangeHigh} = RECORDS(INVOICES)
  UNHIDE(?ProgressBar)
  
  STREAM(INVOICES)
  SET(INVOICES)
  LOOP
    NEXT(INVOICES)
    IF ERRORCODE() THEN BREAK END
    ProgressBar += 1
    DISPLAY(?ProgressBar)
    IF ProgressBar % 10 = 0 THEN YIELD() END
    IF DeleteAndLoad
      InvoicesQueue.Amount = Inv:Amount
      CASE SortType
      OF 'A'; InvoicesQueue.NewOrder =  Inv:Amount
      OF 'D'; InvoicesQueue.NewOrder = -Inv:Amount
      OF 'S'; InvoicesQueue.NewOrder = RANDOM(1,      InvoicesCount)
      END
      ADD(InvoicesQueue,+InvoicesQueue.NewOrder)
    END
    DELETE(INVOICES)
  END
  FLUSH(INVOICES)

  IF DeleteAndLoad  
    DeleteAndLoad = 0
  ELSE
    HIDE(?CurrentProcess)
    HIDE(?ProgressBar)
    BRW1.ResetFromView()
    ThisWindow.Reset(1)
  END
  
  DO MarkBrokenLinks
  
MarkBrokenLinks ROUTINE
  STREAM(Knapsacks)
  SET(Knapsacks)
  LOOP
    NEXT(Knapsacks)
    IF ERRORCODE() THEN BREAK END
    Kna:BrokenLinks += 1
    PUT(Knapsacks)
  END
  FLUSH(Knapsacks)
  BRW2.ResetFromView()

    
CreateInvoicesArray ROUTINE
  InvoicesCount = RECORDS(INVOICES)
  Kna:InvoicesCount = InvoicesCount
  IF PreAllocated = 0
    InvoicesArray &= NEW STRING(InvoicesCount*SIZE(INV:Amount))
  END
  BUFFER(INVOICES,100,0,10,300)
  CLEAR(Kna:MinAmount,1) 
  SET(Inv:KeyID)
  CT = 0
  LOOP
    NEXT(Invoices)
    IF ERRORCODE() THEN 
      IF CT < InvoicesCount
        MESSAGE('Less Invoices than Records count','Unexpected Error !')
        AbortProcess = 1 
      END
      BREAK 
    END
    CT += 1
    IF CT > InvoicesCount
      MESSAGE('More Invoices than Records count','Unexpected Error !')
      AbortProcess = 1 
      BREAK 
    END
    InvoicesCell &= ADDRESS(InvoicesArray) + (CT-1) * SIZE(Inv:Amount)
    InvoicesCell  = Inv:Amount
    IF KNA:MinAmount > Inv:Amount 
       KNA:MinAmount = Inv:Amount 
    END
    IF KNA:MaxAmount < Inv:Amount 
       KNA:MaxAmount = Inv:Amount 
    END
    KNA:AvgAmount   += Inv:Amount 
  END
  IF CT
    Kna:AvgAmount /= CT
  ELSE
    Kna:MinAmount = 0
  END
FindFirstSolution ROUTINE
  CurrentProcess = '1/3 Initializing memory and loading invoices' 
  UNHIDE(?CurrentProcess)
  DISPLAY(?CurrentProcess)
  YIELD()
  
  SET(Kna:KeyID)
  PREVIOUS(Knapsacks)
  IF ERRORCODE() THEN
    LastID = 1
  ELSE
    LastID = Kna:KnapsackID + 1
  END
  CLEAR(Kna:Record)
  Kna:KnapsackID = LastID 
  
  MarkTime(Kna:StartDate,Kna:StartTime)

  Kna:PaymentAmount  = PaymentAmount
  Kna:InvoicesCount  = InvoicesCount
  Kna:Algorithm      = AlgorithmsQueue.Algorithm
  Kna:Allocation     = AlgorithmsQueue.Allocation
  Kna:Implementation = AlgorithmsQueue.Implementation
  Kna:Notes          = Notes
  Kna:ProcessorSpecs = GETREG(REG_LOCAL_MACHINE,'Hardware\Description\System\CentralProcessor\0','ProcessorNameString') |
               & '/' & GETREG(REG_LOCAL_MACHINE,'Hardware\Description\System\CentralProcessor\0','Identifier')

  DO CreateInvoicesArray
  IF AbortProcess THEN 
    HIDE(?CurrentProcess)
    EXIT
  END
  
  ADD(Knapsacks)
  IF ERRORCODE() THEN 
    MESSAGE('Adding Knapsack','Unexpected Error !')
    HIDE(?CurrentProcess)
    EXIT
  END
  GET(Knapsacks,Kna:KeyID)
  IF ERRORCODE() THEN 
    MESSAGE('Fetching Knapsack','Unexpected Error !')
    HIDE(?CurrentProcess)
    EXIT
  END
  
  IF AlgorithmsQueue.Allocation = 'Clarion NEW'
    IF PreAllocated < 2
      AmountsMatrix &= NEW STRING((PaymentAmount+1)*2*SIZE(Inv:Amount))
    END
    CLEAR(AmountsMatrix,1)
    AmountsCell &= ADDRESS(AmountsMatrix)
    AmountsCell  = 0
  END
    InvoicesCell &= ADDRESS(InvoicesArray)
   !message(InvoicesCell)
  
  Kna:InitTime = MarkTime()

  CurrentProcess = '2/3 Running algorithm' 
  DISPLAY(?CurrentProcess)
  YIELD()

  RunProcess(AlgorithmsQueue.ProcedureAddress,PaymentAmount,ADDRESS(AmountsMatrix),InvoicesCount,ADDRESS(InvoicesArray))
  
!If using different calling conventions could use:
!  CASE AlgorithmsQueue.ProcedureAddress
!  OF ADDRESS(FindInvoicesClarion  ); FindInvoicesClarion  (0,ADDRESS(AmountsMatrix),ADDRESS(InvoicesArray),PaymentAmount,InvoicesCount)
!  OF ADDRESS(FindInvoicesCmalloc  ); FindInvoicesCmalloc  (0,                     0,ADDRESS(InvoicesArray),PaymentAmount,InvoicesCount)
!  OF ADDRESS(FindInvoicesC        ); FindInvoicesC        (0,ADDRESS(AmountsMatrix),ADDRESS(InvoicesArray),PaymentAmount,InvoicesCount)
!  OF ADDRESS(FindInvoicesAssembler); FindInvoicesAssembler(0,ADDRESS(AmountsMatrix),ADDRESS(InvoicesArray),PaymentAmount,InvoicesCount)
!  END

  Kna:ProcessTime = MarkTime()

  CurrentProcess = '3/3 Writing results and disposing memory' 
  DISPLAY(?CurrentProcess)
  YIELD()

  LastID = 0

  CLEAR(Kna:SelMinAmount   ,1) 
  CLEAR(Kna:SelMinInvoiceID,1) 

  STREAM(Invoices)
  STREAM(Selections)

  IF AlgorithmsQueue.Allocation = 'Clarion NEW'          !Results on AmountsMatrix
    InvoicesCell &= ADDRESS(InvoicesArray)
    CT = 0
    AmountsCell      &= ADDRESS(AmountsMatrix) +  PaymentAmount                 * SIZE(Inv:Amount) 
    IF AmountsCell <> -1
      lowIndex        = PaymentAmount 
      LOOP WHILE lowIndex>0
        highIndex     = lowIndex
        AmountsCell  &= ADDRESS(AmountsMatrix) + (PaymentAmount + lowIndex + 1) * SIZE(Inv:Amount)
        lowIndex      = AmountsCell
        InvoicesCell &= ADDRESS(InvoicesArray) +                             CT * SIZE(Inv:Amount)
        InvoicesCell  = highIndex-lowIndex
        CT += 1
      END
    ELSE  
      !No exact solution found, although other solutions can be found searching backwards AmountsMatrix 
      ! (from better to worse), but are not considered on this procedure
    END
    InvoicesCount     = CT
  ELSE          !Results on InvoiceArray - look for invoices selected count on last row
    InvoicesCell     &= ADDRESS(InvoicesArray) + (InvoicesCount-1) * SIZE(Inv:Amount)
    IF InvoicesCell  <= 0 
      InvoicesCount   = InvoicesCell * (-1)
    END
  END
  LOOP CT = InvoicesCount-1 TO 0 BY -1                      !Process reversed order
    InvoicesCell     &= ADDRESS(InvoicesArray) +                CT * SIZE(Inv:Amount)
    SelAmount         = InvoicesCell
    DO ProcessSelection
  END
  IF InvoicesCount
    Kna:SelAvgAmount    /= InvoicesCount
    Kna:SelAvgInvoiceID /= InvoicesCount
  ELSE
    Kna:SelMinAmount     = 0
    Kna:SelMinInvoiceID  = 0
  END
  Kna:InvoicesSelected   = InvoicesCount
  
  FLUSH(Invoices)
  FLUSH(Selections)
 
  IF DoNotDispose = 0
    InvoicesCell &= NULL
    AmountsCell  &= NULL
    DISPOSE(InvoicesArray)
    DISPOSE(AmountsMatrix)
  END
  
  Kna:PresentTime = MarkTime()
  
  PUT(Knapsacks)
  
  HIDE(?CurrentProcess)
  BRW2.ResetFromView()
  BRW1.ResetFromView()
  BRW7.ResetFromView()
  ThisWindow.Reset(1)
  SELECT(?List,RECORDS(Queue:Browse:1))
  DISPLAY
  YIELD()
  POST(EVENT:ScrollBottom,?List)
  
ProcessSelection ROUTINE
  IF KNA:SelMinAmount > SelAmount
     KNA:SelMinAmount = SelAmount
  END
  IF KNA:SelMaxAmount < SelAmount
     KNA:SelMaxAmount = SelAmount
  END
  KNA:SelAvgAmount   += SelAmount

  CLEAR(SEL:Record)
  Sel:KnapsackID     = Kna:KnapsackID
  Sel:SelectionOrder = InvoicesCount-CT
  Sel:Amount         = SelAmount
  
  INV:InvoiceID = LastID  
  SET(Inv:KeyID,Inv:KeyID)
  LOOP  
    NEXT(Invoices)
    IF ERRORCODE() THEN BREAK END  !it should not happend
    LastID = Inv:InvoiceID
    IF Inv:Amount = SelAmount
      Sel:InvoiceIDMatched = Inv:InvoiceID
      BREAK
    END
  END
  
  ADD(Selections)

  !IF Sel:InvoiceIDMatched
  IF KNA:SelMinInvoiceID > Sel:InvoiceIDMatched
     KNA:SelMinInvoiceID = Sel:InvoiceIDMatched
  END
  IF KNA:SelMaxInvoiceID < Sel:InvoiceIDMatched
     KNA:SelMaxInvoiceID = Sel:InvoiceIDMatched
  END
  KNA:SelAvgInvoiceID   += Sel:InvoiceIDMatched

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Invoices')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('CurrentKnapsack',CurrentKnapsack)                  ! Added by: BrowseBox(ABC)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Invoices.Open                                     ! File Invoices used by this procedure, so make sure it's RelationManager is open
  Relate:Knapsacks.Open                                    ! File Knapsacks used by this procedure, so make sure it's RelationManager is open
  Relate:Selections.Open                                   ! File Selections used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Invoices,SELF) ! Initialize the browse manager
  BRW2.Init(?List,Queue:Browse.ViewPosition,BRW2::View:Browse,Queue:Browse,Relate:Knapsacks,SELF) ! Initialize the browse manager
  BRW7.Init(?List:2,Queue:Browse:2.ViewPosition,BRW7::View:Browse,Queue:Browse:2,Relate:Selections,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha)       ! Moveable thumb based upon Inv:InvoiceID for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,Inv:KeyID)       ! Add the sort order for Inv:KeyID for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,Inv:InvoiceID,1,BRW1)          ! Initialize the browse locator using  using key: Inv:KeyID , Inv:InvoiceID
  BRW1.AddResetField(CurrentKnapsack)                      ! Apply the reset field
  BRW1.AddField(Inv:InvoiceID,BRW1.Q.Inv:InvoiceID)        ! Field Inv:InvoiceID is a hot field or requires assignment from browse
  BRW1.AddField(Inv:Amount,BRW1.Q.Inv:Amount)              ! Field Inv:Amount is a hot field or requires assignment from browse
  BRW1.AddField(Sel:SelectionOrder,BRW1.Q.Sel:SelectionOrder) ! Field Sel:SelectionOrder is a hot field or requires assignment from browse
  BRW2.Q &= Queue:Browse
  BRW2.AddSortOrder(,Kna:KeyID)                            ! Add the sort order for Kna:KeyID for sort order 1
  BRW2.AddLocator(BRW2::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW2::Sort0:Locator.Init(,Kna:KnapsackID,1,BRW2)         ! Initialize the browse locator using  using key: Kna:KeyID , Kna:KnapsackID
  BRW2.AddField(Kna:KnapsackID,BRW2.Q.Kna:KnapsackID)      ! Field Kna:KnapsackID is a hot field or requires assignment from browse
  BRW2.AddField(Kna:StartDate,BRW2.Q.Kna:StartDate)        ! Field Kna:StartDate is a hot field or requires assignment from browse
  BRW2.AddField(Kna:StartTime,BRW2.Q.Kna:StartTime)        ! Field Kna:StartTime is a hot field or requires assignment from browse
  BRW2.AddField(Kna:PaymentAmount,BRW2.Q.Kna:PaymentAmount) ! Field Kna:PaymentAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:InvoicesCount,BRW2.Q.Kna:InvoicesCount) ! Field Kna:InvoicesCount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:MinAmount,BRW2.Q.Kna:MinAmount)        ! Field Kna:MinAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:AvgAmount,BRW2.Q.Kna:AvgAmount)        ! Field Kna:AvgAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:MaxAmount,BRW2.Q.Kna:MaxAmount)        ! Field Kna:MaxAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:BrokenLinks,BRW2.Q.Kna:BrokenLinks)    ! Field Kna:BrokenLinks is a hot field or requires assignment from browse
  BRW2.AddField(Kna:Algorithm,BRW2.Q.Kna:Algorithm)        ! Field Kna:Algorithm is a hot field or requires assignment from browse
  BRW2.AddField(Kna:Allocation,BRW2.Q.Kna:Allocation)      ! Field Kna:Allocation is a hot field or requires assignment from browse
  BRW2.AddField(Kna:Implementation,BRW2.Q.Kna:Implementation) ! Field Kna:Implementation is a hot field or requires assignment from browse
  BRW2.AddField(Kna:InitTime,BRW2.Q.Kna:InitTime)          ! Field Kna:InitTime is a hot field or requires assignment from browse
  BRW2.AddField(Kna:ProcessTime,BRW2.Q.Kna:ProcessTime)    ! Field Kna:ProcessTime is a hot field or requires assignment from browse
  BRW2.AddField(Kna:PresentTime,BRW2.Q.Kna:PresentTime)    ! Field Kna:PresentTime is a hot field or requires assignment from browse
  BRW2.AddField(Kna:InvoicesSelected,BRW2.Q.Kna:InvoicesSelected) ! Field Kna:InvoicesSelected is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelMinInvoiceID,BRW2.Q.Kna:SelMinInvoiceID) ! Field Kna:SelMinInvoiceID is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelAvgInvoiceID,BRW2.Q.Kna:SelAvgInvoiceID) ! Field Kna:SelAvgInvoiceID is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelMaxInvoiceID,BRW2.Q.Kna:SelMaxInvoiceID) ! Field Kna:SelMaxInvoiceID is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelMinAmount,BRW2.Q.Kna:SelMinAmount)  ! Field Kna:SelMinAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelAvgAmount,BRW2.Q.Kna:SelAvgAmount)  ! Field Kna:SelAvgAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:SelMaxAmount,BRW2.Q.Kna:SelMaxAmount)  ! Field Kna:SelMaxAmount is a hot field or requires assignment from browse
  BRW2.AddField(Kna:Notes,BRW2.Q.Kna:Notes)                ! Field Kna:Notes is a hot field or requires assignment from browse
  BRW2.AddField(Kna:ProcessorSpecs,BRW2.Q.Kna:ProcessorSpecs) ! Field Kna:ProcessorSpecs is a hot field or requires assignment from browse
  BRW7.Q &= Queue:Browse:2
  BRW7.AddSortOrder(,Sel:KeyKnaID)                         ! Add the sort order for Sel:KeyKnaID for sort order 1
  BRW7.AddRange(Sel:KnapsackID,CurrentKnapsack)            ! Add single value range limit for sort order 1
  BRW7.AddLocator(BRW7::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW7::Sort0:Locator.Init(,Sel:SelectionOrder,1,BRW7)     ! Initialize the browse locator using  using key: Sel:KeyKnaID , Sel:SelectionOrder
  BRW7.AddField(Sel:KnapsackID,BRW7.Q.Sel:KnapsackID)      ! Field Sel:KnapsackID is a hot field or requires assignment from browse
  BRW7.AddField(Sel:SelectionOrder,BRW7.Q.Sel:SelectionOrder) ! Field Sel:SelectionOrder is a hot field or requires assignment from browse
  BRW7.AddField(Sel:Amount,BRW7.Q.Sel:Amount)              ! Field Sel:Amount is a hot field or requires assignment from browse
  BRW7.AddField(Sel:InvoiceIDMatched,BRW7.Q.Sel:InvoiceIDMatched) ! Field Sel:InvoiceIDMatched is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Resize,Resize:SetMinSize)       ! Controls will change size as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('Invoices',QuickWindow)                     ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: UpdateInvoices
  BRW2.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW7.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
    CLEAR(AlgorithmsQueue)
    AlgorithmsQueue.Description      = 'Clarion alloc & implementation'
    AlgorithmsQueue.Algorithm        = 'K0/1M-E-ARRLL'
    AlgorithmsQueue.Allocation       = 'Clarion NEW'
    AlgorithmsQueue.Implementation   = 'Clarion Procedure'
    AlgorithmsQueue.ProcedureAddress = ADDRESS(FindInvoicesClarionWrapper)
    ADD(AlgorithmsQueue)
    AlgorithmsQueue.Description      = 'Clarion alloc SV C implementation'
    AlgorithmsQueue.Algorithm        = 'K0/1M-E-ARRLL'
    AlgorithmsQueue.Allocation       = 'Clarion NEW'
    AlgorithmsQueue.Implementation   = 'SV C function'
    AlgorithmsQueue.ProcedureAddress = ADDRESS(FindInvoicesC)
    ADD(AlgorithmsQueue)
    AlgorithmsQueue.Description      = 'Clarion alloc SV Assembler implementation'
    AlgorithmsQueue.Algorithm        = 'K0/1M-E-ARRLL'
    AlgorithmsQueue.Allocation       = 'Clarion NEW'
    AlgorithmsQueue.Implementation   = 'SV Assembler Proced.'
    AlgorithmsQueue.ProcedureAddress = ADDRESS(FindInvoicesAssembler)
    ADD(AlgorithmsQueue)
    AlgorithmsQueue.Description      = 'Clarion alloc SV Modula-2 implementation'
    AlgorithmsQueue.Algorithm        = 'K0/1M-E-ARRLL'
    AlgorithmsQueue.Allocation       = 'Clarion NEW'
    AlgorithmsQueue.Implementation   = 'SV Modula-2 Proced.'
    AlgorithmsQueue.ProcedureAddress = ADDRESS(FindInvoicesModula2Wrapper)
    ADD(AlgorithmsQueue)
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    FREE(AlgorithmsQueue)
    FREE(InvoicesQueue)
    
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Invoices.Close
    Relate:Knapsacks.Close
    Relate:Selections.Close
  END
  IF SELF.Opened
    INIMgr.Update('Invoices',QuickWindow)                  ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateInvoices
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?Generate
      ThisWindow.Update()
      LastID = 0
      
      SET(INV:KeyID)
      IF ACCESS:INVOICES.TRYPREVIOUS() = LEVEL:BENIGN THEN
        LastID = INV:InvoiceID
      END
      
      IF InitialAmount = 0
        MESSAGE('Minimum Initial Amount is 1')
        CYCLE
      END
      
      IF GenerationType = 'R' AND InitialAmount > LimitAmount
          MESSAGE('Limit Amount less than Initial')
          CYCLE
      END
      
      CurrentProcess = '1/1 Generating Invoices'
      UNHIDE(?CurrentProcess)
      DISPLAY(?CurrentProcess)
      
      STREAM(INVOICES)
      
      CASE GenerationType
      OF 'R'
        ProgressBar = 1
        ?ProgressBar{PROP:RangeLow } = 1
        ?ProgressBar{PROP:RangeHigh} = CountStep
        UNHIDE(?ProgressBar)
        LOOP CountStep TIMES
          ProgressBar += 1
          DISPLAY(?ProgressBar)
          IF ProgressBar % 10 = 0 THEN YIELD() END
          LastID += 1
          INV:InvoiceID = LastID
          INV:Amount    = RANDOM(InitialAmount,LimitAmount)
          ADD(INVOICES) !ACCESS:Invoices.INSERT()
        END
      OF 'I'
        ProgressBar = InitialAmount
        ?ProgressBar{PROP:RangeLow } = InitialAmount
        ?ProgressBar{PROP:RangeHigh} = LimitAmount
        UNHIDE(?ProgressBar)
        LOOP CT = InitialAmount TO LimitAmount BY CountStep
          ProgressBar += CountStep
          DISPLAY(?ProgressBar)
          YIELD()
          LastID += 1
          INV:InvoiceID = LastID
          INV:Amount    = CT
          ADD(INVOICES) !ACCESS:Invoices.INSERT()
        END    
      OF 'D'
        ProgressBar = InitialAmount
        ?ProgressBar{PROP:RangeLow } = InitialAmount
        ?ProgressBar{PROP:RangeHigh} = LimitAmount
        UNHIDE(?ProgressBar)
        LOOP CT = LimitAmount TO InitialAmount BY -CountStep
          ProgressBar += CountStep
          DISPLAY(?ProgressBar)
          YIELD()
          LastID += 1
          INV:InvoiceID = LastID
          INV:Amount    = CT
          ADD(INVOICES) !ACCESS:Invoices.INSERT()
        END    
      END
      FLUSH(INVOICES)
      HIDE(?ProgressBar)
      HIDE(?CurrentProcess)
      BRW1.ResetFromView()
      ThisWindow.Reset(1)
    OF ?Reorder
      ThisWindow.Update()
        DeleteAndLoad = 1
        DO DeleteInvoices
        
        CurrentProcess = '2/2 Rewriting Invoices'
        DISPLAY(?CurrentProcess)
        STREAM(INVOICES)
        LOOP CT = 1 TO RECORDS(InvoicesQueue)
          GET(InvoicesQueue,CT)
          ProgressBar = CT
          DISPLAY(?ProgressBar)
          IF ProgressBar % 10 = 0 THEN YIELD() END
      
          Inv:InvoiceID = CT
          Inv:Amount    = InvoicesQueue.Amount
          ADD(Invoices)
        END
        FLUSH(INVOICES)
        FREE(InvoicesQueue)
      
        HIDE(?CurrentProcess)
        HIDE(?ProgressBar)
        BRW1.ResetFromView()
        ThisWindow.Reset(1)
    OF ?DeleteInvoices
      ThisWindow.Update()
        !EMPTY(INVOICES)
        DeleteAndLoad = 0
        DO DeleteInvoices
    OF ?FindFirstSolution
      ThisWindow.Update()
        IF PaymentAmount <= 0
          MESSAGE('Please choose Payment amount')
          CYCLE
        END
        IF NOT INRANGE(CHOICE(?AlgorithmList),1,RECORDS(AlgorithmsQueue))
          MESSAGE('Please choose an Algorithm')
          CYCLE
        END
        GET(AlgorithmsQueue,CHOICE(?AlgorithmList))  
        DO FindFirstSolution
    OF ?RepeatingTest
      ThisWindow.Update()
        IF PaymentAmount <= 0
          MESSAGE('Please choose Payment amount')
          CYCLE
        END
        IF Repetitions <= 0
          MESSAGE('Please choose number of repetitions')
          CYCLE
        END
        NotesBackup = Notes
        ProgressBar = 0
        ?ProgressBar{PROP:RangeLow } = 0
        ?ProgressBar{PROP:RangeHigh} = CHOOSE(Repetitions=1,1,3) * RECORDS(AlgorithmsQueue) * Repetitions 
        UNHIDE(?ProgressBar)  
        
        DoNotDispose = 1
        !Step 1
        LOOP CurrentAlgorithm = 1 TO RECORDS(AlgorithmsQueue)
          GET(AlgorithmsQueue,CurrentAlgorithm)  
          LOOP CurrentRepetition = 1 TO Repetitions
             Notes = 'S1A' & CurrentAlgorithm & 'R' & CurrentRepetition & ' ' & NotesBackup
             IF CurrentAlgorithm = RECORDS(AlgorithmsQueue) AND Repetitions = 1
               DoNotDispose = 0
             END
             DO FindFirstSolution
             ProgressBar = (CurrentAlgorithm-1) * Repetitions + CurrentRepetition
             DISPLAY(?ProgressBar)
             YIELD()
             IF ~(AmountsMatrix &= NULL)
               PreAllocated = 2
             ELSIF ~(InvoicesArray &= NULL)
               PreAllocated = 1
             END
          END
        END
            
       IF Repetitions > 1
        !Step 2       
        LOOP CurrentRepetition = 1 TO Repetitions
          LOOP CurrentAlgorithm = 1 TO RECORDS(AlgorithmsQueue)
            GET(AlgorithmsQueue,CurrentAlgorithm)  
            Notes = 'S2R' & CurrentRepetition & 'A' & CurrentAlgorithm & ' ' & NotesBackup
            DO FindFirstSolution
            ProgressBar = RECORDS(AlgorithmsQueue) * Repetitions +  |
                          RECORDS(AlgorithmsQueue) * (CurrentRepetition-1) + CurrentAlgorithm
            DISPLAY(?ProgressBar)
            YIELD()
          END
        END
        
        !Step 3       
        LOOP CurrentRepetition = 1 TO Repetitions
          LOOP CurrentAlgorithm = 1 TO RECORDS(AlgorithmsQueue)
            GET(AlgorithmsQueue,CurrentAlgorithm)  
            AlgorithmsQueue.RepeatOrder = RANDOM(1,100)
            PUT(AlgorithmsQueue)
          END
          
          SORT(AlgorithmsQueue,+AlgorithmsQueue.RepeatOrder)
          
          LOOP CurrentAlgorithm = 1 TO RECORDS(AlgorithmsQueue)
            GET(AlgorithmsQueue,CurrentAlgorithm)  
            Notes = 'S3R' & CurrentRepetition & 'A' & CurrentAlgorithm & ' ' & NotesBackup
            IF CurrentAlgorithm = RECORDS(AlgorithmsQueue) AND CurrentRepetition = Repetitions
              DoNotDispose = 0
            END
            DO FindFirstSolution
            ProgressBar = 2 * RECORDS(AlgorithmsQueue) * Repetitions +  |
                          RECORDS(AlgorithmsQueue) * (CurrentRepetition-1) + CurrentAlgorithm
            DISPLAY(?ProgressBar)
            YIELD()
          END
        END  
       END
        
        PreAllocated = 0
        HIDE(?ProgressBar)
        Notes = NotesBackup
        DISPLAY(?Notes)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END


BRW1.ResetFromAsk PROCEDURE(*BYTE Request,*BYTE Response)

  CODE
  PARENT.ResetFromAsk(Request,Response)
    IF (Request = ChangeRecord OR Request = DeleteRecord) AND Response = RequestCompleted
      DO MarkBrokenLinks
    END
    


BRW1.SetAlerts PROCEDURE

  CODE
  SELF.EditViaPopup = False
  PARENT.SetAlerts


BRW2.ScrollEnd PROCEDURE(SIGNED Event)

  CODE
  PARENT.ScrollEnd(Event)
  !


BRW2.TakeNewSelection PROCEDURE

  CODE
  PARENT.TakeNewSelection
  CurrentKnapsack = Kna:KnapsackID
  DISPLAY(?CurrentKnapsack)


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! Form Invoices
!!! </summary>
UpdateInvoices PROCEDURE 

CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
History::Inv:Record  LIKE(Inv:RECORD),THREAD
QuickWindow          WINDOW('Form Invoices'),AT(,,163,70),FONT('Microsoft Sans Serif',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,GRAY,IMM,MDI,HLP('UpdateInvoices'),SYSTEM
                       SHEET,AT(4,4,155,44),USE(?CurrentTab)
                         TAB('&1) General'),USE(?Tab:1)
                           PROMPT('Invoice ID:'),AT(8,20),USE(?Inv:InvoiceID:Prompt),TRN
                           ENTRY(@n9),AT(61,20,40,10),USE(Inv:InvoiceID),RIGHT(1),SKIP
                           PROMPT('Amount:'),AT(8,34),USE(?Inv:Amount:Prompt),TRN
                           ENTRY(@n10),AT(61,34,44,10),USE(Inv:Amount),RIGHT(1)
                         END
                       END
                       BUTTON('&OK'),AT(4,52,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(57,52,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       BUTTON('&Help'),AT(110,52,49,14),USE(?Help),LEFT,ICON('WAHELP.ICO'),FLAT,MSG('See Help Window'), |
  STD(STD:Help),TIP('See Help Window')
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateInvoices')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Inv:InvoiceID:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(Inv:Record,History::Inv:Record)
  SELF.AddHistoryField(?Inv:InvoiceID,1)
  SELF.AddHistoryField(?Inv:Amount,2)
  SELF.AddUpdateFile(Access:Invoices)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Invoices.Open                                     ! File Invoices used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Invoices
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?Inv:InvoiceID{PROP:ReadOnly} = True
    ?Inv:Amount{PROP:ReadOnly} = True
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('UpdateInvoices',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Invoices.Close
  END
  IF SELF.Opened
    INIMgr.Update('UpdateInvoices',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Source
!!! Stopwatch
!!! </summary>
MarkTime             PROCEDURE  (<*Long ParStartDate>,<*Long ParStartTime>,<Long DontReset>) ! Declare Procedure

StartDate LONG,STATIC
StartTime LONG,STATIC

CurrentDate LONG
CurrentTime LONG
MaxTime     EQUATE(24*60*60*100)

ELLAPSED    Long

  CODE
  CurrentDate = TODAY()
  CurrentTime = CLOCK()
  
  IF CurrentDate < TODAY()
     CurrentDate = TODAY()
     CurrentTime = CLOCK()
  END

  IF NOT OMITTED(1) THEN ParStartDate = CurrentDate END
  IF NOT OMITTED(2) THEN ParStartTime = CurrentTime END
  
  Ellapsed = (CurrentDate - StartDate) * MaxTime + CurrentTime - StartTime 
    
  IF OMITTED(3) OR DontReset = 0
    StartDate = CurrentDate
    StartTime = CurrentTime
  END
  
  RETURN Ellapsed
!!! <summary>
!!! Generated from procedure template - Window
!!! About and Version History
!!! </summary>
Version PROCEDURE 

VersionText          CSTRING(10000)                        ! 
QuickWindow          WINDOW('About and Version History'),AT(,,263,233),FONT('Microsoft Sans Serif',8,,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,CENTER,GRAY,IMM,MAX,HLP('Version'),SYSTEM
                       TEXT,AT(3,2,257,211),USE(VersionText),VSCROLL,READONLY
                       BUTTON('&Close'),AT(211,217,49,14),USE(?Ok),MSG('Close the window'),TIP('Close the window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Version')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?VersionText
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Ok,RequestCancelled)                    ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Ok,RequestCompleted)                    ! Add the close control to the window manger
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('Version',QuickWindow)                      ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.SetAlerts()
  VersionText = '' &|
  'KnapSack project for testing and benchmarking knapsack algorithms with different '  &|
  'languages (Clarion, C, Assembler, Modula-2) <13,10>' &|
  '<13,10>' &|
  '2017-08-09 Version 0 <13,10>-Original idea and approaches discussed on Clarion 10 newsgroup ' &|
  '(news.softvelocity.com) on Thread "Algorithm Challenge" started by Ray Rippey ' &|
  '(there is a Sum up on 2017-08-23)<13,10>' &|
  '<13,10>' &|
  '2017-08-25 Version 1  by Andrej Kozelj<13,10>' &|
  ' -files.7z providing sln app and empty dct with the application frame menu<13,10>' &|'
  ' -Sv. C version of the algorithm with unique parameter prototype<13,10>'&|
  ' -hand coded array[8] test case on "Click Me" window<13,10>'&|
  '<13,10>' &|
  '2017-09-06 Version 2  by Federico Navarro<13,10>' &|
  ' -Clarion and Sv.Assembler version of the algorithm<13,10>' &|
  ' -minimal tweaks to the Sv.C version: inform Invoices selected on last row of InvoicesArray<13,10>' &|
  ' -another Sv.C version using allocated AmountsMatrix on Clarion side<13,10>' &|
  ' -some basic output to debug piped through a common Clarion procedure<13,10>' &|
  ' -unified prototypes for unified calling by Address to different algorithms (which shares the same Clarion ' &|
  'calling convention)<13,10>' &|
  ' -adapted the "Click me" window test case on FindInWindow procedure to use the new prototype and '&|
  'to also call new algorithms added<13,10>'&|
  ' -new user interface "Knapsack Console" with files, editable data stored for repeatable and shareable dynamic tests, ' &|
  'which backups can be made for different test cases or deleted to start from scratch, also the contents can be exported ' &|
  'to CSV with Topscan<13,10>'&|
  ' -Browse/Form of Invoices<13,10>'&|
  ' -parameterized (Random/Incrementing/Decrementing, From, To, Count) Invoices generator for easy getting large data sets<13,10>' &|
  ' -Invoices reordering option with Random / Ascending / Descending methods and Delete All option<13,10>' &|
  ' -progress bar indicator for most task except the internal loops execution of the algorithms to not alter their process time<13,10>' &|
  ' -Knapsacks and Selections files for storing parameters used, results and statistics data, ' &| 
  'like Min Max Avg of Amounts in total Invoices and of Amounts and IDs in Selected Invoices, ' &| 
  'Start date/time and elapsed times on initialization, process, and presentations stages<13,10>' &|
  ' -Invoices'' matcher to link Invoices selected on each algorithm<13,10>' &|
  ' -invocator of repeated tests to automatically run n times each algorithm in three different orders: collated, in cycles, and random, to reach ' &|
  'more precision and veracity on the statistic results<13,10>' &|
  ' -implemented the new alternative memory allocator for clarion zdfast by Dave Nichols (Assembler version) but commented out as ' &|
  'it seemed not improving this kind of allocation (big and by once on one unique thread)<13,10>' &|
  '<13,10>' &|
  '2021-04-14 Version 2.1  by Federico Navarro<13,10>' &|
  ' -Modula-2 version of the algorithm (callable from Knapsack Console and FindInWindow)<13,10>' &|
  '<13,10>' &|
  '2021-05-26 Version 2.2  by Federico Navarro<13,10>' &|
  ' -added more Clarion algorithms: Reference assignments (existing), using Peek & Poke, using 1d and 2d arrays and using local arrays<13,10>' &|
  ' -moved parameter positions for standarization, ie array size previous to its address, exception is targetSum which is half minus one the size<13,10>' &|
  ' -change disposition of thisArray non interleaving Sums and Results for up to 40% faster processing<13,10>' &|
  '<13,10>' &|
  '2021-05-28 Version 2.3  by Federico Navarro<13,10>' &|
  ' -resimplified app design, deleted the "Click me" window, the commented code with previous versions and the extra algorithms, left only the 4 of knaplite project<13,10>' &|
  ''
  !this could be loaded from a .txt file, but avoided for simplicity and portability,
  !ie SystemSringClass >= C10, and avoiding other file drivers or special apis.
  !in the same sense, the database could be sqlite instead tps, but would need >= C9
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Version',QuickWindow)                   ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Source
!!! Prototype Adapter to Modula-2 Algorithm
!!! </summary>
FindInvoicesModula2Wrapper PROCEDURE  (LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray) ! Declare Procedure

  CODE
  FindInvoicesModula2((PaymentAmount+1)*2*SIZE(PaymentAmount),AmountsArray,InvoicesCount*SIZE(InvoicesCount),InvoicesArray)
!!! <summary>
!!! Generated from procedure template - Source
!!! Prototype Adapter to Clarion Algorithm
!!! </summary>
FindInvoicesClarionWrapper PROCEDURE  (LONG     MyEIP,LONG PaymentAmount,LONG AmountsArray,LONG InvoicesCount,LONG InvoicesArray) ! Declare Procedure

  CODE
  RunProcess(ADDRESS(FindInvoicesClarion),(PaymentAmount+1)*2,AmountsArray,InvoicesCount,InvoicesArray)
  !Using RunProcess avoids compiler type mismatch verification on Clarion prototypes
  ! to allow the string buffer passed by address be represented on the destination
  ! as an array of Integers
  
