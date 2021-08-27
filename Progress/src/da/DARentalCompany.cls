USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DARentalCompany INHERITS src.DA.DAGeneric:
    {src/include/dsRentalCompany.i}.
    {src/include/dsCarAgency.i}.

    DEFINE PRIVATE VARIABLE beCarAgency AS src.be.beCarAgency.
    DEFINE PRIVATE VARIABLE beUserRole  AS src.be.beUserRole.
     
    CONSTRUCTOR PUBLIC DARentalCompany() :
        TableName = "RentalCompany".
        TempTableName = "ttRentalCompany".
    END CONSTRUCTOR.
     
    DESTRUCTOR PUBLIC DARentalCompany() :
    END DESTRUCTOR.
     
    METHOD PUBLIC VOID FetchAllRentalCompany (OUTPUT DATASET dsRentalCompany):
        DEFINE BUFFER bufRentalCompany FOR RentalCompany.
        DATASET dsRentalCompany:EMPTY-DATASET ().
        DO TRANSACTION:         
            FOR EACH bufRentalCompany NO-LOCK:
                CREATE ttRentalCompany.
                BUFFER-COPY bufRentalCompany TO ttRentalCompany.
            END.
        END.
    END METHOD.
     
    METHOD PUBLIC VOID CreateRentalCompany (INPUT-OUTPUT DATASET dsRentalCompany):
        DEFINE BUFFER bufRentalCompany FOR RentalCompany.
        DO TRANSACTION:
            FOR EACH ttRentalCompany NO-LOCK:
               CREATE bufRentalCompany.
               BUFFER-COPY ttRentalCompany EXCEPT RentalCompanyID TO bufRentalCompany.
               bufRentalCompany.RentalCompanyId = GUID.
            END.    
        END.        
   END METHOD.    

   METHOD PUBLIC VOID UpdateRentalCompany (INPUT-OUTPUT DATASET dsRentalCompany) :
       DEFINE BUFFER bufRentalCompany FOR RentalCompany.
       DO TRANSACTION:
           FOR EACH ttRentalCompany NO-LOCK:
               FIND FIRST bufRentalCompany EXCLUSIVE-LOCK                    
                        WHERE bufRentalCompany.RentalCompanyId = ttRentalCompany.RentalCompanyId NO-ERROR.
                   IF AVAILABLE bufRentalCompany THEN 
                       BUFFER-COPY ttRentalCompany EXCEPT RentalCompanyId TO bufRentalCompany.
                   ELSE 
                       UNDO, THROW NEW Progress.Lang.AppError("Cannot find the RentalCompany", 100).                                
           END.      
        END.  
   END METHOD.        
    
    METHOD PUBLIC VOID DeleteRentalCompany (INPUT-OUTPUT DATASET dsRentalCompany):
        DEFINE BUFFER bufRentalCompany FOR RentalCompany.
        beCarAgency = NEW src.BE.BECarAgency().
        beUserRole  = NEW src.BE.BEUserRole().
        DO TRANSACTION:
            FOR EACH bttRentalCompany NO-LOCK:
                FIND FIRST bufRentalCompany EXCLUSIVE-LOCK
                        WHERE bufRentalCompany.RentalCompanyId = bttRentalCompany.RentalCompanyId NO-ERROR.
                    IF AVAILABLE bufRentalCompany THEN  
                        DO:
                            beCarAgency:DeleteCarAgencyWithRentalCompany(bufRentalCompany.RentalCompanyId).
                            beUserRole:DeleteUserRoleWithRentalCompanyId(bufRentalCompany.RentalCompanyId).
                            DELETE bufRentalCompany.
                        END.
                    ELSE
                        UNDO, THROW NEW Progress.Lang.AppError("Cannot find the RentalCompany", 100).        
            END.  
        END.  
        FINALLY:
            DELETE OBJECT beCarAgency NO-ERROR.
            DELETE OBJECT beUserRole NO-ERROR.            
        END FINALLY.            
    END METHOD.
    
    METHOD PUBLIC LOGICAL ExistsWithRentalCompanyId(INPUT ipcRentalCompanyId AS CHARACTER):
        DEFINE BUFFER bufRentalCompany FOR RentalCompany.
        FIND FIRST bufRentalCompany NO-LOCK WHERE bufRentalCompany.RentalCompanyId EQ ipcRentalCompanyId NO-ERROR.
        RETURN AVAILABLE(bufRentalCompany).
    END METHOD.     
    
    METHOD PUBLIC LOGICAL ExistsWithSameDescription(INPUT ipcDescription AS CHARACTER):
        DEFINE BUFFER bufRentalCompany FOR RentalCompany.
        FIND FIRST bufRentalCompany NO-LOCK WHERE bufRentalCompany.Description EQ ipcDescription NO-ERROR.
        RETURN AVAILABLE(bufRentalCompany).
    END METHOD.        
END CLASS.
