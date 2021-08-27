USING Progress.Lang.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.

 
CLASS src.BE.BERentCar INHERITS src.be.BEGeneric: 
    {src/include/dsRentCar.i}
    {src/include/dsRent.i}
    {src/include/dsCarStock.i}
   
    DEFINE PRIVATE VARIABLE daRentCar AS src.DA.DARentCar NO-UNDO.
    
    CONSTRUCTOR PUBLIC BERentCar (  ):
        
        daRentCar = NEW src.DA.DARentCar().
        
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BERentCar ( ):
    
        DELETE OBJECT daRentCar NO-ERROR.
    
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID ReadRentCar(INPUT filter AS CHARACTER, OUTPUT dataset dsRentCar):
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        THIS-OBJECT:daRentCar:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsRentCar BY-REFERENCE).
        
    END METHOD.
    
    METHOD PUBLIC VOID CreateRentCar (INPUT-OUTPUT dataset dsRentCar):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER         INITIAL "" NO-UNDO.
        
        DEFINE VARIABLE beCar         AS src.be.beCar      NO-UNDO.
        DEFINE VARIABLE beRent        AS src.be.beRent     NO-UNDO.
        DEFINE VARIABLE beCarStock    AS src.be.beCarStock NO-UNDO.
        
        DEFINE VARIABLE dValidFrom    AS DATE              NO-UNDO.
        DEFINE VARIABLE dValidTo      AS DATE              NO-UNDO.
        
        DEFINE VARIABLE iStockAmount  AS INTEGER           NO-UNDO.
        DEFINE VARIABLE iCount        AS INTEGER           NO-UNDO.
        
        DEFINE VARIABLE dDateFrom     AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateTo       AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateFrom1    AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateTo1      AS DATE              NO-UNDO.
        
        DEFINE VARIABLE cRentId       AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cCarAgencyId  AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cCarAgencyId1 AS CHARACTER NO-UNDO.
      
        DEFINE BUFFER bufRentCar FOR RentCar.
         
        beCarStock = NEW src.be.BECarStock().
        beCar = NEW src.be.BECar().
        beRent = NEW src.be.BERent().
      
      
        FOR EACH ttRentCar NO-LOCK WHERE ROW-STATE(ttRentCar) = ROW-CREATED:
            
            IF ttRentCar.CarId = ? OR ttRentCar.CarId = "" THEN 
                cErrorMessage = cErrorMessage + "CarId cannot be empty".
                
            IF ttRentCar.RentId = ? OR ttRentCar.RentId = "" THEN 
                cErrorMessage = cErrorMessage + "RentId cannot be empty".
                
            /*            IF NOT(beCar:ExistsWithCarId(ttRentCar.CarId)) THEN   */
            /*               cErrorMessage = cErrorMessage + "Masina nu exista".*/
            
            IF NOT(beRent:ExistsRentWithRentId(ttRentCar.RentId)) THEN
                cErrorMessage = cErrorMessage + "Nu exista Rent corespunzator".
            
            cCarAgencyId = beRent:GetCarAgencyIdByRentId (INPUT ttRentCar.RentId).
            dDateFrom    = beRent:getDateFromByRentId    (INPUT ttRentCar.RentId,INPUT cCarAgencyId).
            dDateTo      = beRent:getDateToByRentId      (INPUT ttRentCar.RentId, INPUT cCarAgencyId).
            
            beCarStock:ReadCarStock(INPUT SUBSTITUTE("WHERE CarStock.CarId = '&1' AND CarStock.CarAgencyId = '&2'",ttRentCar.CarId,cCarAgencyId), 
                                    OUTPUT DATASET dsCarStock BY-REFERENCE).
            
            FIND FIRST ttCarStock NO-LOCK WHERE ( ttCarStock.ValidTo = ? AND ttCarStock.ValidFrom <= dDateFrom) OR 
                (ttCarStock.ValidTo <> ?  AND ttCarStock.ValidFrom <= dDateFrom AND ttCarSTock.ValidTo >= dDateTo) NO-ERROR.
                 
            IF NOT AVAILABLE(ttCarStock) THEN
                cErrorMessage = cErrorMessage + "In perioada selectata nu exista stock".
            ELSE 
            DO:
                iStockAmount = ttCarStock.StockAmount.
                
                iCount = getNrProblematicRents(INPUT ttCarStock.CarId,INPUT cCarAgencyId, INPUT dDateFrom, INPUT dDateTo).
                
/*                FOR EACH bufRentCar WHERE bufRentCar.CarId = ttCarStock.CarId:                                  */
/*                                                                                                                */
/*                    cCarAgencyId1 = beRent:GetCarAgencyIdByRentId(INPUT bufRentCar.RentId).                     */
/*                                                                                                                */
/*                    IF cCarAgencyId1 = cCarAgencyId THEN                                                        */
/*                    DO:                                                                                         */
/*                                                                                                                */
/*                        dDateFrom1 = beRent:getDateFromByRentId  (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                        dDateTo1   = beRent:getDateToByRentId    (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                                                                                                                */
/*                        IF NOT (dDateTo1 < dDateFrom OR dDateFrom1 > dDateTo) THEN                              */
/*                            iCount += 1.                                                                        */
/*                    END.                                                                                        */
/*                END.                                                                                            */
                
                IF iCount >= iStockAmount THEN 
                    cErrorMessage = cErrorMessage + "Nu exista nicio masina disponibila pentru perioada selectata".
            END.
      
        END.
        
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        
        daRentCar:CreateRentCar(INPUT-OUTPUT dataset dsRentCar BY-REFERENCE).
        FINALLY:
            
                DELETE OBJECT beCarStock NO-ERROR.
                DELETE OBJECT beCar      NO-ERROR.
                DELETE OBJECT beRent     NO-ERROR.
                    
        END FINALLY.
    END METHOD.
    
    
    
    METHOD PUBLIC VOID UpdateRentCar (INPUT-OUTPUT dataset dsRentCar):
        DEFINE VARIABLE cErrorMessage AS CHARACTER         INITIAL "" NO-UNDO.
        
        DEFINE VARIABLE beCar         AS src.be.beCar      NO-UNDO.
        DEFINE VARIABLE beRent        AS src.be.beRent     NO-UNDO.
        DEFINE VARIABLE beCarStock    AS src.be.beCarStock NO-UNDO.
        
        DEFINE VARIABLE dValidFrom    AS DATE              NO-UNDO.
        DEFINE VARIABLE dValidTo      AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateFrom     AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateTo       AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateFrom1    AS DATE              NO-UNDO.
        DEFINE VARIABLE dDateTo1      AS DATE              NO-UNDO.
        
        DEFINE VARIABLE iStockAmount  AS INTEGER           NO-UNDO.
        DEFINE VARIABLE iCount        AS INTEGER           NO-UNDO.
        
        DEFINE VARIABLE cRentId       AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cCarAgencyId  AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cCarAgencyId1 AS CHARACTER         NO-UNDO. 
        
        DEFINE BUFFER bufRentCar FOR RentCar.
       
      
        beCarStock = NEW src.be.BECarStock().
        beCar      = NEW src.be.BECar().
        beRent     = NEW src.be.BERent().
        
        FOR EACH ttRentCar NO-LOCK WHERE ROW-STATE(ttRentCar) = ROW-MODIFIED:
                    
            IF ttRentCar.CarId = ? OR ttRentCar.CarId = "" THEN 
                cErrorMessage = cErrorMessage + "CarId cannot be empty".
                
            IF ttRentCar.RentId = ? OR ttRentCar.RentId = "" THEN 
                cErrorMessage = cErrorMessage + "RentId cannot be empty".
                
            /*            IF NOT(beCar:ExistsWithCarId(ttRentCar.CarId)) THEN   */
            /*               cErrorMessage = cErrorMessage + "Masina nu exista".*/
            
            IF NOT(beRent:ExistsRentWithRentId(ttRentCar.RentId)) THEN
                cErrorMessage = cErrorMessage + "Nu exista Rent corespunzator".
            
            cCarAgencyId = beRent:GetCarAgencyIdByRentId   (INPUT ttRentCar.RentId).
            dDateFrom    = beRent:getDateFromByRentId      (INPUT ttRentCar.RentId, INPUT cCarAgencyId).
            dDateTo      = beRent:getDateToByRentId        (INPUT ttRentCar.RentId, INPUT cCarAgencyId).
            
            beCarStock:ReadCarStock(INPUT SUBSTITUTE("WHERE CarStock.CarId = '&1' AND CarStock.CarAgencyId = '&2'",ttRentCar.CarId,cCarAgencyId), 
                                    OUTPUT DATASET dsCarStock BY-REFERENCE).
            
            FIND FIRST ttCarStock NO-LOCK WHERE ( ttCarStock.ValidTo = ? AND ttCarStock.ValidFrom <= dDateFrom) OR 
                (ttCarStock.ValidTo <> ?  AND ttCarStock.ValidFrom <= dDateFrom AND ttCarSTock.ValidTo >= dDateTo) NO-ERROR.
                 
            IF NOT AVAILABLE(ttCarStock) THEN
                cErrorMessage = cErrorMessage + "In perioada selectata nu exista stock".
            ELSE 
            DO:
                iStockAmount = ttCarStock.StockAmount.
                iCount = getNrProblematicRents(INPUT ttCarStock.CarId,INPUT cCarAgencyId, INPUT dDateFrom, INPUT dDateTo).
                
/*                                                                                                                */
/*                FOR EACH bufRentCar WHERE bufRentCar.CarId = ttCarStock.CarId:                                  */
/*                    cCarAgencyId1 = beRent:GetCarAgencyIdByRentId(INPUT bufRentCar.RentId).                     */
/*                    IF cCarAgencyId1 = cCarAgencyId THEN                                                        */
/*                    DO:                                                                                         */
/*                        dDateFrom1 = beRent:getDateFromByRentId  (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                        dDateTo1   = beRent:getDateToByRentId    (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                                                                                                                */
/*                        IF NOT (dDateTo1 < dDateFrom OR dDateFrom1 > dDateTo) THEN                              */
/*                            iCount += 1.                                                                        */
/*                    END.                                                                                        */
/*                END.                                                                                            */
                IF iCount - 1  >= iStockAmount THEN 
                    cErrorMessage = cErrorMessage + "Nu exista nicio masina disponibila pentru perioada selectata".
            END.
        
        END.
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
            
        daRentCar:UpdateRentCar(INPUT-OUTPUT dataset dsRentCar BY-REFERENCE).
        
        FINALLY:
                DELETE OBJECT beCarStock NO-ERROR.
                DELETE OBJECT beCar      NO-ERROR.
                DELETE OBJECT beRent     NO-ERROR.    
        END FINALLY.
        
    END METHOD.
    METHOD PUBLIC LOGICAL VerifyNewInputs(INPUT cRentId AS CHARACTER, INPUT DATASET dsRentCar, INPUT cCarAgencyId AS CHARACTER, INPUT dDateFrom AS DATE,INPUT dDateTo AS DATE):
        
        DEFINE VARIABLE beCar        AS src.be.beCar      NO-UNDO.
        DEFINE VARIABLE beRent       AS src.be.beRent     NO-UNDO.
        DEFINE VARIABLE beCarStock   AS src.be.beCarStock NO-UNDO.
        
        DEFINE VARIABLE dValidFrom   AS DATE    NO-UNDO.
        DEFINE VARIABLE dValidTo     AS DATE    NO-UNDO.
        DEFINE VARIABLE dDateFrom1   AS DATE    NO-UNDO.
        DEFINE VARIABLE dDateTo1     AS DATE    NO-UNDO.
        
        DEFINE VARIABLE iStockAmount AS INTEGER NO-UNDO.
        DEFINE VARIABLE iCount       AS INTEGER NO-UNDO.
          
        DEFINE VARIABLE cCarAgencyId1 AS CHARACTER NO-UNDO.
        
        DEFINE BUFFER bufRentCar FOR RentCar.
        
        
        beCarStock = NEW src.be.BECarStock().
        beCar      = NEW src.be.BECar().
        beRent     = NEW src.be.BERent().
        
        readRentCar(INPUT SUBSTITUTE("WHERE RentCar.RentId = '&1'",cRentId), OUTPUT DATASET dsRentCar).
        
        FOR EACH ttRentCar NO-LOCK:

            beCarStock:ReadCarStock(INPUT SUBSTITUTE("WHERE CarStock.CarId = '&1' AND CarStock.CarAgencyId = '&2'",ttRentCar.CarId,cCarAgencyId), 
                                    OUTPUT DATASET dsCarStock BY-REFERENCE).
            
            FIND FIRST ttCarStock NO-LOCK WHERE (ttCarStock.ValidTo = ? AND ttCarStock.ValidFrom <= dDateFrom) OR 
                (ttCarStock.ValidTo <> ?  AND ttCarStock.ValidFrom <= dDateFrom AND ttCarSTock.ValidTo >= dDateTo) NO-ERROR.
                 
            IF NOT AVAILABLE(ttCarStock) THEN
                RETURN FALSE.
            ELSE 
            DO:
                iStockAmount = ttCarStock.StockAmount.
                iCount = getNrProblematicRents(INPUT ttCarStock.CarId,INPUT cCarAgencyId, INPUT dDateFrom, INPUT dDateTo).
/*                FOR EACH bufRentCar WHERE bufRentCar.CarId = ttCarStock.CarId:                                  */
/*                                                                                                                */
/*                    cCarAgencyId1 = beRent:GetCarAgencyIdByRentId(INPUT bufRentCar.RentId).                     */
/*                                                                                                                */
/*                    IF cCarAgencyId1 = cCarAgencyId THEN                                                        */
/*                    DO:                                                                                         */
/*                        dDateFrom1 = beRent:getDateFromByRentId  (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                        dDateTo1   = beRent:getDateToByRentId    (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).*/
/*                                                                                                                */
/*                        IF NOT (dDateTo1 < dDateFrom OR dDateFrom1 > dDateTo) THEN                              */
/*                            iCount += 1.                                                                        */
/*                    END.                                                                                        */
/*                END.                                                                                            */
                IF iCount - 1 >= iStockAmount THEN 
                    RETURN FALSE.
            END.
        
        END.
        
        RETURN TRUE.
        
        FINALLY:
            
                DELETE OBJECT beCarStock NO-ERROR.
                DELETE OBJECT beCar      NO-ERROR.
                DELETE OBJECT beRent     NO-ERROR.   
                 
        END FINALLY.
    END.
    
    
    METHOD PUBLIC VOID DeleteRentCar(INPUT-OUTPUT dataset dsRentCar):
        
        daRentCar:DeleteRentCar(INPUT-OUTPUT dataset dsRentCar BY-REFERENCE).
        
    END METHOD.
    
    METHOD PUBLIC LOGICAL  ExistsRentForCar(INPUT ipcCarId AS CHARACTER ):
        
        RETURN daRentCar:ExistsRentForCar(ipcCarId).
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CountRentCar (INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT dataset dsRentCar):
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daRentCar:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.

    METHOD PUBLIC INTEGER getNrProblematicRents(INPUT ipcCarIdFromCarStock AS CHARACTER,INPUT ipcCarAgencyId AS CHARACTER, INPUT ipdDateFrom AS DATE, INPUT ipdDateTo AS DATE):
        
        RETURN daRentCar:getNrProblematicRents(INPUT ipcCarIdFromCarStock,INPUT ipcCarAgencyId, INPUT ipdDateFrom, INPUT ipdDateTo).
        
    END.
        METHOD PUBLIC INTEGER GetNumberOfRentsOfACar(INPUT ipcCarId AS CHARACTER ):
        RETURN daRentCar:GetNumberOfRentsOfACar(INPUT ipcCarId).
    END METHOD. 

END CLASS.