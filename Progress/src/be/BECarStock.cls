 
 /*------------------------------------------------------------------------
    File        : BECarStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:18:51 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BeGeneric.
USING src.Da.DaCarStock.
USING src.BE.BECar.
USING src.DA.DaGenericValidation.
USING src.BE.BECarAgency.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BECarStock INHERITS BEGeneric: 

    {src/include/dsCarStock.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PRIVATE VARIABLE daCarStock AS DACarStock NO-UNDO .
    DEFINE PRIVATE VARIABLE beCar AS BECar NO-UNDO .
    DEFINE PRIVATE VARIABLE beAgency AS BECarAgency NO-UNDO .
    DEFINE PRIVATE VARIABLE daGenericValidation AS DAGenericValidation NO-UNDO.
    
    
    
    CONSTRUCTOR PUBLIC BECarStock (  ):
        daCarStock = NEW DACarStock () .
        beAgency = NEW BECarAgency().
        daGenericValidation = NEW DAGenericValidation().        
        
    END CONSTRUCTOR.
    
    
     /*
      Fetches the data, after applying a specific filter.
    */
    METHOD PUBLIC VOID ReadCarStock(INPUT pcfilter AS CHARACTER , OUTPUT DATASET  dsCarStock ):
                                         
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(pcfilter, cWhere, iMaxRows, iSkipRows).
        daCarStock:ReadGeneric( INPUT iMaxRows, INPUT iSkipRows ,
                                INPUT cWhere  , OUTPUT  DATASET  dsCarStock BY-REFERENCE ).
    END METHOD.



    /*
      Updates car stocks for existing cars
    */
    METHOD PUBLIC VOID UpdateCarStock (INPUT-OUTPUT  DATASET dsCarStock):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        DEFINE VARIABLE cFinalErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        
         //checks if there is another stock created in the same period
        IF daCarStock:ExistsCarStock(INPUT DATASET  dsCarStock) THEN DO:
             UNDO , THROW NEW Progress.Lang.AppError("There is another car stock in this period.", 100).     
        END.
        ELSE DO :
            beCar = NEW BECar().
            FOR EACH ttCarStock :
                daGenericValidation:isEmpty(INPUT ttCarStock.ValidFrom, INPUT "ValidFrom", INPUT-OUTPUT cErrorMessages).
                cFinalErrorMessages = cFinalErrorMessages + cErrorMessages.

                cErrorMessages = "".
                IF ttCarStock.ValidTo <> ? THEN DO:
                  daGenericValidation:isChronological(ttCarStock.ValidFrom, ttCarStock.ValidTo, INPUT-OUTPUT cErrorMessages).
                
                END.
                daGenericValidation:isEmpty(ttCarStock.StockAmount, "StockAmount", INPUT-OUTPUT cErrorMessages).
                    cFinalErrorMessages = cFinalErrorMessages + cErrorMessages.    
                  
                //checks the existence of the car
                IF NOT beCar:ExistsWithCarId(INPUT ttCarStock.CarId) THEN 
                   cFinalErrorMessages = cFinalErrorMessages + " The car is invalid;  ".  
                   
                //checks if the car agency exists
                IF NOT beAgency:ExistsCarAgency(INPUT ttCarStock.CarAgencyId) THEN 
                    cFinalErrorMessages = cFinalErrorMessages + " The car agency does not exist;  ".   
                    
                IF cFinalErrorMessages <> "" THEN DO:
                     UNDO , THROW NEW Progress.Lang.AppError(cFinalErrorMessages, 100).
                END. 
            END.
            daCarStock:UpdateCarStock(INPUT-OUTPUT  DATASET dsCarStock BY-REFERENCE ).   
        END.
        FINALLY:
             DELETE OBJECT beCar NO-ERROR.    
        END FINALLY.
    END METHOD.
    
    
    
    /*
      Creates  new car stocks
    */
    METHOD PUBLIC VOID CreateCarStock(INPUT-OUTPUT  DATASET dsCarStock):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        DEFINE VARIABLE cFinalErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        
         //checks if there is another stock created in the same period
        IF daCarStock:ExistsCarStock(INPUT DATASET  dsCarStock) THEN DO:
             UNDO , THROW NEW Progress.Lang.AppError("There is another car stock in this period.", 100).     
        END.
        ELSE DO :
            beCar = NEW BECar().
            FOR EACH ttCarStock :
                daGenericValidation:isEmpty(INPUT ttCarStock.ValidFrom, INPUT "ValidFrom", INPUT-OUTPUT cErrorMessages).
                  cFinalErrorMessages = cFinalErrorMessages + cErrorMessages.

                cErrorMessages = "".
                
                IF ttCarStock.ValidTo <> ? THEN DO: 
                    daGenericValidation:isChronological(ttCarStock.ValidFrom, ttCarStock.ValidTo, INPUT-OUTPUT cErrorMessages).
                END.   
                
                daGenericValidation:isEmpty(ttCarStock.StockAmount, "StockAmount", INPUT-OUTPUT cErrorMessages).
                    cFinalErrorMessages = cFinalErrorMessages + cErrorMessages.    
                                  
                //checks the existence of the car
                IF NOT beCar:ExistsWithCarId(INPUT ttCarStock.CarId) THEN 
                   cFinalErrorMessages = cFinalErrorMessages + " The car is invalid;  ".  
                   
                //checks if the car agency exists
                IF NOT beAgency:ExistsCarAgency(INPUT ttCarStock.CarAgencyId) THEN 
                    cFinalErrorMessages = cFinalErrorMessages + " The car agency does not exist;  ".   
                    
                IF cFinalErrorMessages <> "" THEN DO:
                     MESSAGE "end " cFinalErrorMessages.
                     UNDO , THROW NEW Progress.Lang.AppError(cFinalErrorMessages, 100).
                END. 
            END.
            daCarStock:CreateCarStock(INPUT-OUTPUT  DATASET dsCarStock BY-REFERENCE ).   
        END.
        FINALLY:
             DELETE OBJECT beCar NO-ERROR.    
        END FINALLY.
    END METHOD.
    
    
    /*
      Deletes existing car stocks
    */
    METHOD PUBLIC VOID DeleteCarStock(INPUT-OUTPUT  DATASET dsCarStock):
       daCarStock:DeleteCarStock(INPUT-OUTPUT  DATASET dsCarStock BY-REFERENCE ). 
    END METHOD.
    
    
    METHOD PUBLIC VOID CountCarStock(INPUT pcfilter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(pcfilter, cWhere, iMaxRows, iSkipRows).
        daCarStock:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    
    /* 
     Empties the available stocks for a given car
    */
    METHOD PUBLIC VOID EmptyStockForCar(INPUT ipcCarId AS CHARACTER  ):
         MESSAGE "[delete] be carstock start".
        
        daCarStock:EmptyStockForCar(ipcCarId ).
        MESSAGE "[delete] be carstock end".
        
    END.

    METHOD PUBLIC VOID DeleteCarStockWithCarAgency(INPUT ipcCarAgencyId AS CHARACTER):
        daCarStock:DeleteCarStockWithCarAgency(INPUT ipcCarAgencyId).
    END METHOD.
        
   
    
    DESTRUCTOR PUBLIC BECarStock ( ):
        DELETE OBJECT daCarStock  NO-ERROR.
        DELETE OBJECT beAgency NO-ERROR.
    END DESTRUCTOR.

END CLASS.