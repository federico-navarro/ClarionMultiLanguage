  MEMBER('KnapSack.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('KnapSack_BC0.CLW')
KnapSack_BC0:DctInit             PROCEDURE()
KnapSack_BC0:DctKill             PROCEDURE()
KnapSack_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  KnapSack_BC0:DctInit
  KnapSack_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  KnapSack_BC0:DctKill

