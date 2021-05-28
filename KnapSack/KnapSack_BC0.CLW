  MEMBER('KnapSack.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
KnapSack_BC0:DctInit    PROCEDURE()
KnapSack_BC0:DctKill    PROCEDURE()
KnapSack_BC0:FilesInit  PROCEDURE()
  END

Hide:Access:Invoices CLASS(FileManager),TYPE               ! FileManager for Invoices
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Invoices CLASS(RelationManager),TYPE           ! RelationManager for Invoices
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Knapsacks CLASS(FileManager),TYPE              ! FileManager for Knapsacks
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Knapsacks CLASS(RelationManager),TYPE          ! RelationManager for Knapsacks
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Selections CLASS(FileManager),TYPE             ! FileManager for Selections
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Selections CLASS(RelationManager),TYPE         ! RelationManager for Selections
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:Invoices &Hide:Access:Invoices,AUTO,THREAD
_Hide:Relate:Invoices &Hide:Relate:Invoices,AUTO,THREAD
_Hide:Access:Knapsacks &Hide:Access:Knapsacks,AUTO,THREAD
_Hide:Relate:Knapsacks &Hide:Relate:Knapsacks,AUTO,THREAD
_Hide:Access:Selections &Hide:Access:Selections,AUTO,THREAD
_Hide:Relate:Selections &Hide:Relate:Selections,AUTO,THREAD


KnapSack_BC0:DctInit PROCEDURE()
  CODE
  _Hide:Access:Invoices &= NEW(Hide:Access:Invoices)
  _Hide:Relate:Invoices &= NEW(Hide:Relate:Invoices)
  _Hide:Access:Knapsacks &= NEW(Hide:Access:Knapsacks)
  _Hide:Relate:Knapsacks &= NEW(Hide:Relate:Knapsacks)
  _Hide:Access:Selections &= NEW(Hide:Access:Selections)
  _Hide:Relate:Selections &= NEW(Hide:Relate:Selections)
  Relate:Invoices &= _Hide:Relate:Invoices
  Relate:Knapsacks &= _Hide:Relate:Knapsacks
  Relate:Selections &= _Hide:Relate:Selections


KnapSack_BC0:FilesInit PROCEDURE()
  CODE
  _Hide:Relate:Invoices.Init
  _Hide:Relate:Knapsacks.Init
  _Hide:Relate:Selections.Init


KnapSack_BC0:DctKill PROCEDURE()
  CODE
  _Hide:Relate:Invoices.Kill
  DISPOSE(_Hide:Relate:Invoices)
  _Hide:Relate:Knapsacks.Kill
  DISPOSE(_Hide:Relate:Knapsacks)
  _Hide:Relate:Selections.Kill
  DISPOSE(_Hide:Relate:Selections)


Hide:Relate:Invoices.Init PROCEDURE()
  CODE
  _Hide:Access:Invoices.Init
  SELF.Init(Access:Invoices,1)


Hide:Access:Invoices.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Inv:Record
  SELF.FileNameValue = 'Invoices'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Invoices
  PARENT.Init
  Access:Invoices &= SELF


Hide:Access:Invoices.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Invoices &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Invoices.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Invoices,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Inv:KeyID,'By ID',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Invoices.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Selections,RI:None,RI:None,Sel:KeyInvID)
  SELF.AddRelationLink(Inv:InvoiceID,Sel:InvoiceIDMatched)


Hide:Relate:Invoices.Kill PROCEDURE

  CODE
  _Hide:Access:Invoices.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:Invoices &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Invoices)                           ! destroy the file manager


Hide:Relate:Knapsacks.Init PROCEDURE()
  CODE
  _Hide:Access:Knapsacks.Init
  SELF.Init(Access:Knapsacks,1)


Hide:Access:Knapsacks.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Kna:Record
  SELF.FileNameValue = 'Knapsacks'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Knapsacks
  PARENT.Init
  Access:Knapsacks &= SELF


Hide:Access:Knapsacks.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Knapsacks &= NULL                                 ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Knapsacks.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Knapsacks,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Kna:KeyID,'By ID',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Knapsacks.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Selections,RI:None,RI:None,Sel:KeyKnaID)
  SELF.AddRelationLink(Kna:KnapsackID,Sel:KnapsackID)


Hide:Relate:Knapsacks.Kill PROCEDURE

  CODE
  _Hide:Access:Knapsacks.Kill                              ! Kill the file manager
  PARENT.Kill
  Relate:Knapsacks &= NULL                                 ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Knapsacks)                          ! destroy the file manager


Hide:Relate:Selections.Init PROCEDURE()
  CODE
  _Hide:Access:Selections.Init
  SELF.Init(Access:Selections,1)


Hide:Access:Selections.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= Sel:Record
  SELF.FileNameValue = 'Selections'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Selections
  PARENT.Init
  Access:Selections &= SELF


Hide:Access:Selections.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Selections &= NULL                                ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Selections.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Selections,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(Sel:KeyKnaID,'Sel:KeyKnaID',2)
    SELF.AddKey(Sel:KeyInvID,'Sel:KeyInvID',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Selections.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Invoices)

  SELF.AddRelation(Relate:Knapsacks)


Hide:Relate:Selections.Kill PROCEDURE

  CODE
  _Hide:Access:Selections.Kill                             ! Kill the file manager
  PARENT.Kill
  Relate:Selections &= NULL                                ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Selections)                         ! destroy the file manager

