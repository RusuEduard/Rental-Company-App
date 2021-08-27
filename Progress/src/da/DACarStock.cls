 
 /*------------------------------------------------------------------------
    File        : DACarStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:05:10 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.DA.DAGeneric.


BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DACarStock INHERITS DAGeneric: 
    {src/include/dsCarStock.i}

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DACarStock ():
        TempTableName = "ttCarStock".
        TableName = "CarStock".
    END CONSTRUCTOR.
    

  
   /*
     Creates car stocks for existing cars
   */
   METHOD PUBLIC  VOID CreateCarStock(INPUT-OUTPUT  DATASET dsCarStock):
        
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        DO TRANSACTION:
            FOR EACH ttCarStock  WHERE ROW-STATE(ttCarStock) = ROW-CREATED :
                CREATE bufCarStock.
                BUFFER-COPY ttCarStock EXCEPT CarStockId TO bufCarStock.
                bufCarStock.CarStockId =  GUID.
              
            END.
        END.
    END METHOD.
    
    
    /*
      Deletes all carstocks that refer a given car
    */
    METHOD PUBLIC VOID EmptyStockForCar(INPUT ipcCarId AS CHARACTER  ):
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        MESSAGE "[delete] da car stock empty start".
        FOR EACH bufCarStock EXCLUSIVE-LOCK WHERE bufCarStock.CarId = ipcCarId:
            DELETE bufCarStock.
        END.
        MESSAGE "[delete] da car stock empty end".
        
    END METHOD .

    
    /*
      Deletes existing car stocks
    */
    METHOD PUBLIC VOID DeleteCarStock(INPUT-OUTPUT  DATASET dsCarStock):
        
        MESSAGE "[delete] da car stock  start".
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        DO TRANSACTION:
            FOR EACH bttCarStock :
                MESSAGE "for bttCarStock " bttCarStock.CarStockId.
                FIND  FIRST bufCarStock EXCLUSIVE-LOCK WHERE bufCarStock.CarStockId = bttCarStock.CarStockId 
                                                       NO-ERROR.
                            
                IF AVAILABLE (bufCarStock) THEN  DO:  
                    DELETE bufCarStock.
                END.
                ELSE UNDO , THROW NEW Progress.Lang.AppError("Car stock not found.", 100).     
            END.
        END.
        MESSAGE "[delete] da car stock end".
        
    END METHOD.
    
    
    /*
      Checks if there is a car stock with the given CarStockId
    */
    METHOD PUBLIC LOGICAL ExistsWithCarStockId(INPUT ipcCarStockId AS CHARACTER):
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        RETURN CAN-FIND( FIRST bufCarStock NO-LOCK WHERE bufCarStock.CarStockId = ipcCarStockId).
        
    END METHOD.
    
    

    /*
      Updates existing car stocks
    */
    METHOD PUBLIC VOID UpdateCarStock(INPUT-OUTPUT DATASET dsCarStock):
        
        DEFINE BUFFER bufCarStock FOR CarStock.
          
        DO TRANSACTION:
            FOR EACH ttCarStock WHERE ROW-STATE(ttCarStock) = ROW-MODIFIED :
                FIND  FIRST bufCarStock EXCLUSIVE-LOCK  WHERE bufCarStock.CarStockId = ttCarStock.CarStockId 
                                                        NO-ERROR.
                            
                IF AVAILABLE (bufCarStock ) THEN  BUFFER-COPY ttCarStock EXCEPT CarStockId TO  bufCarStock.
                ELSE UNDO , THROW NEW Progress.Lang.AppError("Car stock not found.", 100).     
            END.
        END.
    END METHOD.
    
    
    
    METHOD PUBLIC VOID FetchAllCarStocks (OUTPUT DATASET dsCarStock):
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        DATASET dsCarStock:EMPTY-DATASET ().
        FOR EACH bufCarStock NO-LOCK :
            CREATE ttCarStock.
            BUFFER-COPY bufCarStock TO ttCarStock.
        END.
    END METHOD.
    
    
    /*
      Returns true if there is no other car stock available in the desired period(for create)
    */
    METHOD PUBLIC LOGICAL ExistsCarStock (INPUT  DATASET dsCarStock):
        DEFINE BUFFER bufCarStock FOR CarStock.
        
        FOR EACH ttCarStock,
            EACH bufCarStock NO-LOCK  WHERE bufCarStock.CarId = ttCarStock.CarId  AND 
                                            bufCarStock.CarStockId <> ttCarStock.CarStockId AND 
                                            bufCarStock.CarAgencyId = ttCarStock.CarAgencyId
                                                :
                
                MESSAGE "buf from " bufCarStock.ValidFrom " to " bufCarStock.ValidTo.
                MESSAGE "tt from " ttCarStock.ValidFrom " to " ttCarStock.ValidTo.
                
                IF ttCarStock.ValidTo = ? THEN DO:
                    MESSAGE "first if".
                    IF  bufCarStock.ValidTo = ? THEN  RETURN TRUE.
                    IF  bufCarStock.ValidTo < ttCarStock.ValidFrom THEN RETURN  FALSE.
                END.
                
                IF bufCarStock.ValidTo = ? THEN DO:
                    MESSAGE "second if".
                    IF  ttCarStock.ValidTo = ? THEN  RETURN TRUE.
                    IF  ttCarStock.ValidTo < bufCarStock.ValidFrom THEN RETURN  FALSE.
                END.
                
                
                IF ttCarStock.ValidFrom < bufCarStock.ValidFrom AND ttCarStock.ValidTo < bufCarStock.ValidTo 
                THEN 
                DO:
                    MESSAGE "third if".
                    IF ttCarStock.ValidTo < bufCarStock.ValidFrom THEN RETURN FALSE .
                    ELSE RETURN TRUE .
                END.
                
                IF ttCarStock.ValidFrom > bufCarStock.ValidFrom AND ttCarStock.ValidTo > bufCarStock.ValidTo 
                THEN 
                DO:
                    MESSAGE "last if".
                    IF ttCarStock.ValidFrom > bufCarStock.ValidTo THEN RETURN FALSE .
                    ELSE RETURN TRUE .
                END.
                RETURN TRUE.
            
        END.
        RETURN FALSE   .
    END METHOD.
    

    /*
     Deletes all car stocks that have their car agency id equal to ipcCarAgencyId
    */
    METHOD PUBLIC VOID DeleteCarStockWithCarAgency(INPUT ipcCarAgencyID AS CHARACTER):       
        DEFINE BUFFER bufCarStock FOR CarStock. 
        FOR EACH bufCarStock EXCLUSIVE-LOCK 
            WHERE bufCarStock.CarAgencyId EQ ipcCarAgencyID:
            DELETE bufCarStock.
        END. 
    END METHOD.    
    
    
    /*
     Checks if there is a car stock for the given agency
    */
    METHOD PUBLIC LOGICAL ExistsCarStockWithCarAgencyId(INPUT ipcCarAgencyId AS CHARACTER ):
        DEFINE BUFFER bufCarStock FOR CarStock.
        RETURN CAN-FIND( FIRST bufCarStock NO-LOCK WHERE bufCarStock.CarAgencyId = ipcCarAgencyId).
    END METHOD.
    
       
    DESTRUCTOR PUBLIC DACarStock ( ):

    END DESTRUCTOR.

END CLASS.