 
 /*------------------------------------------------------------------------
    File        : BECar
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:16:49 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BeGeneric.
USING src.Da.DaCar.
USING src.BE.BECarStock.
USING src.BE.BECarType.
USING src.BE.BeRentCar.
USING src.DA.DaGenericValidation.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BECar INHERITS BEGeneric: 

    {src/include/dsCar.i}
    {src/include/dsCarStock.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PRIVATE VARIABLE daCar AS DACar NO-UNDO .
    DEFINE PRIVATE VARIABLE beCarStock AS BECarStock NO-UNDO .
    DEFINE PRIVATE VARIABLE beCarType AS BECarType NO-UNDO .
    DEFINE PRIVATE VARIABLE beRentCar AS BERentCar NO-UNDO.
    DEFINE PRIVATE VARIABLE daGenericValidation AS DAGenericValidation NO-UNDO.

    
    CONSTRUCTOR PUBLIC BECar (  ):
        daCar = NEW DACar () .
        beCarStock = NEW BECarStock().
        beRentCar = NEW BERentCar().
        beCarType = NEW BECarType ().
        daGenericValidation = NEW DAGenericValidation().        
        
    END CONSTRUCTOR.
    
    
    /*
       Fetches all the data in a given dataset.
    */
    METHOD PUBLIC VOID GetData(OUTPUT DATASET dsCar):
      daCar:FetchGeneric(OUTPUT DATASET dsCar BY-REFERENCE  ).
    END METHOD.
    
    
    
    /*
      Fetches the data, after applying a specific filter.
    */
    METHOD PUBLIC VOID ReadCar(INPUT ipcfilter AS CHARACTER , OUTPUT DATASET  dsCar ):
                                         
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(ipcfilter, cWhere, iMaxRows, iSkipRows).
        daCar:ReadGeneric( INPUT iMaxRows, INPUT iSkipRows ,
                                           INPUT cWhere  , OUTPUT  DATASET  dsCar BY-REFERENCE ).
    END METHOD.



    /*
      Creates new cars
    */
    METHOD PUBLIC VOID CreateCar (INPUT-OUTPUT  DATASET dsCar):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        DEFINE VARIABLE cFinalMessages AS CHARACTER INITIAL "" NO-UNDO.
        
        FOR EACH ttCar :
            
          daGenericValidation:isEmpty(INPUT ttCar.Manufacturer, INPUT "Manufacturer", INPUT-OUTPUT cErrorMessages).
          cFinalMessages = cFinalMessages + cErrorMessages.
          daGenericValidation:isEmpty(INPUT ttCar.Model, INPUT "Model", INPUT-OUTPUT cErrorMessages).
          cFinalMessages = cFinalMessages + cErrorMessages.
             
          //checks if the given car type exists
          IF NOT beCarType:ExistsWithCarTypeId(ttCar.CarTypeId) THEN
              cFinalMessages = cFinalMessages + " The car type is invalid; ".
              
          //checks if there is no other car with the same model, manufacturer and car type id
          IF ExistsWithModelAndManufacturer(ttCar.Model, ttCar.Manufacturer, ttCar.CarTypeId) THEN 
              cFinalMessages = cFinalMessages + " There is another car with this exact model, manufacturer"+ 
                                                  " and car type; ".
              
          IF cFinalMessages <> "" THEN DO:
              UNDO , THROW NEW Progress.Lang.AppError(cFinalMessages, 100).
          END.
                     
        END.
        daCar:CreateCar(INPUT-OUTPUT  DATASET dsCar BY-REFERENCE ). 
    END METHOD.
    
    
    
    /*
     Updates existing cars
    */
    METHOD PUBLIC VOID UpdateCar(INPUT-OUTPUT  DATASET dsCar):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        DEFINE VARIABLE cFinalMessages AS CHARACTER INITIAL "" NO-UNDO .
        
        FOR EACH ttCar :
            
          daGenericValidation:isEmpty(INPUT ttCar.Manufacturer, INPUT "Manufacturer", INPUT-OUTPUT cErrorMessages).
          cFinalMessages = cFinalMessages + cErrorMessages.
          daGenericValidation:isEmpty(INPUT ttCar.Model, INPUT "Model", INPUT-OUTPUT cErrorMessages).
          cFinalMessages = cFinalMessages + cErrorMessages.
             
          //checks if the given car type exists
          IF NOT beCarType:ExistsWithCarTypeId(ttCar.CarTypeId) THEN
              cFinalMessages = cFinalMessages + " The car type is invalid; ".
              
          //checks if there is no other car with the same model, manufacturer and car type id
          IF ExistsWithModelAndManufacturer(ttCar.Model, ttCar.Manufacturer, ttCar.CarTypeId) THEN 
              cFinalMessages = cFinalMessages + " There is another car with this exact model, manufacturer"+ 
                                                  "and car type; ".
                      
          IF cFinalMessages <> "" THEN DO:
              UNDO , THROW NEW Progress.Lang.AppError(cFinalMessages, 100).
          END.       
        END.
        
        daCar:UpdateCar(INPUT-OUTPUT  DATASET dsCar BY-REFERENCE ). 
    END METHOD.
    
    
    /*
      Deletes  existing cars. (it also deletes all of the available stocks regarding each car)      
    */
    METHOD PUBLIC VOID DeleteCar(INPUT-OUTPUT  DATASET dsCar):
        
       MESSAGE "[delete] be car start".
       DO TRANSACTION:
           
           FOR EACH bttCar WHERE ROW-STATE(bttCar) = ROW-DELETED:
               IF beRentCar:ExistsRentForCar(bttCar.CarId) THEN DO:
                  UNDO , THROW NEW Progress.Lang.AppError("This car is rented.", 100). 
               END.
               
               ELSE DO:
                   beCarStock:EmptyStockForCar(bttCar.CarId).
               END.
           END.
    
           daCar:DeleteCar(INPUT-OUTPUT  DATASET dsCar BY-REFERENCE ). 
       END.
       MESSAGE "[delete] be car end".
       
        
    END METHOD.
    
    
   /*
    Returns the number of cars that have a given type
    */
    METHOD PUBLIC INTEGER GetNumberOfCarsWithType(INPUT ipcCarType AS CHARACTER ):
        RETURN daCar:GetNumberOfCarsWithType(ipcCarType).
    END METHOD.
    
   
    /*
      Checks if there is a car with the given CarId
    */ 
    METHOD PUBLIC LOGICAL ExistsWithCarId(INPUT ipcCarId AS CHARACTER ):
        RETURN daCar:ExistsWithCarId(ipcCarId).
    END METHOD.
    
    
    
    /*
      Deletes all cars (and their stocks) that have a given type
    */
    METHOD PUBLIC VOID EmptyCarsWithType(INPUT ipcCarTypeId AS CHARACTER  ):
        
        MESSAGE "[be car]empty car start".
        daCar:FetchCarsWithType(INPUT ipcCarTypeId, OUTPUT DATASET dsCar BY-REFERENCE ).
        DO TRANSACTION:
            FOR EACH ttCar:
                IF beRentCar:ExistsRentForCar(ttCar.CarId) THEN DO:
                   UNDO , THROW NEW Progress.Lang.AppError("This car is rented.", 100). 
                END.
                beCarStock:EmptyStockForCar(ttCar.CarId).
            END.
            daCar:EmptyCarsWithType(ipcCarTypeId).
        END.
        MESSAGE "[be car]empty car end".
    END METHOD.
    
    
    
    /*
      Gets the number of cars that fulfill a criteria
    */
    METHOD PUBLIC VOID CountCar(INPUT pcfilter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(pcfilter, cWhere, iMaxRows, iSkipRows).
        daCar:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    
    /*
      Checks if there is another car with the given model and manufacturer
    */
    METHOD PUBLIC LOGICAL ExistsWithModelAndManufacturer(INPUT ipcModel AS CHARACTER, 
                   INPUT ipcManufacturer AS CHARACTER, INPUT ipcCarType AS CHARACTER ):
        
      RETURN daCar:ExistsWithModelAndManufacturer(ipcModel, ipcManufacturer, ipcCarType).
    END METHOD.
    
    
    

    
    DESTRUCTOR PUBLIC BECar ( ):
        DELETE OBJECT daCar  NO-ERROR.
        DELETE OBJECT beCarType NO-ERROR.
        DELETE OBJECT beCarStock NO-ERROR.
    END DESTRUCTOR.

END CLASS.