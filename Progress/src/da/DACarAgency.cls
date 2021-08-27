USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DACarAgency INHERITS src.DA.DAGeneric:
    {src/include/dsCarAgency.i}.

    DEFINE PRIVATE VARIABLE beCarStock AS src.be.beCarStock.
    DEFINE PRIVATE VARIABLE beRent     AS src.be.BERent.
     
    CONSTRUCTOR PUBLIC DACarAgency() :
        TableName = "CarAgency".
        TempTableName = "ttCarAgency".
    END CONSTRUCTOR.
     
    DESTRUCTOR PUBLIC DACarAgency() :
    END DESTRUCTOR.
     
    METHOD PUBLIC VOID FetchAllCarAgency (OUTPUT DATASET dsCarAgency):
        DEFINE BUFFER bufCarAgency FOR CarAgency.
        DATASET dsCarAgency:EMPTY-DATASET ().
        
        DO TRANSACTION: 
            FOR EACH bufCarAgency NO-LOCK:
                CREATE ttCarAgency.
                BUFFER-COPY bufCarAgency TO ttCarAgency.
            END.
        END.
    END METHOD.
    
     
    METHOD PUBLIC VOID CreateCarAgency (INPUT-OUTPUT DATASET dsCarAgency):
        DEFINE BUFFER bufCarAgency FOR CarAgency.
        DO TRANSACTION:
            FOR EACH ttCarAgency NO-LOCK:
                CREATE bufCarAgency.
                BUFFER-COPY ttCarAgency EXCEPT CarAgencyID TO bufCarAgency.
                bufCarAgency.CarAgencyId = GUID.
            END.     
        END.       
   END METHOD.    

   METHOD PUBLIC VOID UpdateCarAgency (INPUT-OUTPUT DATASET dsCarAgency) :
       DEFINE BUFFER bufCarAgency FOR CarAgency.
       DO TRANSACTION:
           FOR EACH ttCarAgency NO-LOCK:
               FIND FIRST bufCarAgency EXCLUSIVE-LOCK                    
                        WHERE bufCarAgency.CarAgencyId = ttCarAgency.CarAgencyId NO-ERROR.
                   IF AVAILABLE bufCarAgency THEN 
                       BUFFER-COPY ttCarAgency EXCEPT CarAgencyId TO bufCarAgency.
                   ELSE 
                       UNDO, THROW NEW Progress.Lang.AppError("Cannot find the CarAgency", 100).                                
            END.    
        END.               
    END METHOD.        
    
    METHOD PUBLIC VOID DeleteCarAgency (INPUT-OUTPUT DATASET dsCarAgency):
        beCarStock = NEW src.BE.BECarStock().
        beRent     = NEW src.BE.BERent().
        DEFINE BUFFER bufCarAgency FOR CarAgency.
        DO TRANSACTION:
            FOR EACH bttCarAgency NO-LOCK:
                FIND FIRST bufCarAgency EXCLUSIVE-LOCK
                    WHERE bufCarAgency.CarAgencyId = bttCarAgency.CarAgencyId NO-ERROR.
                IF AVAILABLE bufCarAgency THEN
                    DO:
                        IF beRent:ExistsActiveRentWithCarAgencyId(INPUT bufCarAgency.CarAgencyId) THEN
                            UNDO , THROW NEW Progress.Lang.AppError("There is still open rents in this agency.", 100).     
                        ELSE 
                            DO:
                                beCarStock:DeleteCarStockWithCarAgency(INPUT bufCarAgency.CarAgencyId).                        
                                DELETE bufCarAgency.
                            END.
                    END.
                ELSE
                    UNDO, THROW NEW Progress.Lang.AppError("Cannot find the CarAgency", 100).        
            END.   
        END. 
        FINALLY:
            DELETE OBJECT beCarStock NO-ERROR.
        END FINALLY.          
    END METHOD.

    METHOD PUBLIC VOID DeleteCarAgencyWithRentalCompany(INPUT ipcRCId AS CHARACTER):       
        DEFINE BUFFER bufCarAgency FOR CarAgency. 
        FOR EACH bufCarAgency EXCLUSIVE-LOCK 
            WHERE bufCarAgency.RentalCompanyId EQ ipcRCId:
            DELETE bufCarAgency.
        END. 
    END METHOD.    
    
    METHOD PUBLIC LOGICAL ExistsCarAgency(INPUT ipcAgencyId AS CHARACTER ):
        DEFINE BUFFER bufCarAgency FOR CarAgency.
        RETURN CAN-FIND (FIRST bufCarAgency NO-LOCK WHERE bufCarAgency.CarAgencyId = ipcAgencyId).
    END METHOD.
                
END CLASS.

