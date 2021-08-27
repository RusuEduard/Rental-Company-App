 
 /*------------------------------------------------------------------------
    File        : DARentCar
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 19:54:12 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DARentCar INHERITS src.DA.DAGeneric:
    {src/include/dsRentCar.i}
    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DARentCar ( ):
        TableName = "RentCar".
        TempTableName = "ttRentCar".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DARentCar ( ):

    END DESTRUCTOR.
    
    METHOD PUBLIC VOID CreateRentCar (INPUT-OUTPUT dataset dsRentCar):
        DEFINE BUFFER bufRentCar FOR RentCar.
        FOR EACH ttRentCar NO-LOCK
            WHERE ROW-STATE(ttRentCar) = ROW-CREATED:
            CREATE bufRentCar.
            BUFFER-COPY ttRentCar EXCEPT RentCarId TO bufRentCar.
            ASSIGN
                bufRentCar.RentCarId = GUID.
        END.
    END METHOD.
    
    METHOD PUBLIC VOID UpdateRentCar(INPUT-OUTPUT dataset dsRentCar):
        DEFINE BUFFER bufRentCar FOR RentCar.
        FOR EACH ttRentCar NO-LOCK
            WHERE ROW-STATE(ttRentCar) = ROW-MODIFIED:
            FIND FIRST bufRentCar EXCLUSIVE-LOCK
                WHERE bufRentCar.RentCarId = ttRentCar.RentCarId NO-ERROR.
            IF AVAILABLE bufRentCar THEN
                BUFFER-COPY ttRentCar EXCEPT RentCarId TO bufRentCar.
            ELSE
                UNDO,THROW NEW Progress.Lang.AppError("cannot find the customer", 100).
        END.
    END METHOD.

    METHOD PUBLIC VOID DeleteRentCar(INPUT-OUTPUT dataset dsRentCar):
        DEFINE BUFFER bufRentCar FOR RentCar.
        FOR EACH bttRentCar NO-LOCK
            WHERE ROW-STATE(bttRentCar) = ROW-DELETED:
            FIND FIRST bufRentCar EXCLUSIVE-LOCK WHERE bufRentCar.RentCarId = bttRentCar.RentCarId NO-ERROR.
            IF AVAILABLE (bufRentCar) THEN
                DELETE bufRentCar.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("cannot find the customer", 100).

        END.
    END METHOD.
    
    METHOD PUBLIC VOID FetchAllRentCar(OUTPUT DATASET dsRentCar):
        DEFINE BUFFER bufRentCar FOR RentCar.
        DATASET dsRentCar:EMPTY-DATASET().
        FOR EACH bufRentCar NO-LOCK:
            CREATE ttRentCar.
            BUFFER-COPY bufRentCar TO ttRentCar.
        END.
    END METHOD.

    METHOD PUBLIC LOGICAL  ExistsRentForCar(INPUT ipcCarId AS CHARACTER ):
        DEFINE BUFFER bufRentCar FOR RentCar.
        RETURN CAN-FIND (FIRST bufRentCar NO-LOCK WHERE bufRentCar.CarId = ipcCarId).
    END.
    
    METHOD PUBLIC INTEGER getNrProblematicRents(INPUT ipcCarIdFromCarStock AS CHARACTER,INPUT ipcCarAgencyId AS CHARACTER, INPUT ipdDateFrom AS DATE, INPUT ipdDateTo AS DATE):
        
        DEFINE BUFFER bufRentCar FOR RentCar.
        DEFINE VARIABLE cCarAgencyId1 AS CHARACTER NO-UNDO.
        DEFINE VARIABLE beRent AS src.be.beRent NO-UNDO.
        DEFINE VARIABLE dDateFrom1 AS DATE NO-UNDO.
        DEFINE VARIABLE dDateTo1 AS DATE NO-UNDO.
        DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
        beRent = NEW src.be.beRent().
        FOR EACH bufRentCar WHERE bufRentCar.CarId = ipcCarIdFromCarStock:
            
            cCarAgencyId1 = beRent:GetCarAgencyIdByRentId(INPUT bufRentCar.RentId).
            IF cCarAgencyId1 = ipcCarAgencyId THEN
            DO:
                dDateFrom1 = beRent:getDateFromByRentId  (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).
                dDateTo1   = beRent:getDateToByRentId    (INPUT bufRentCar.RentId, INPUT cCarAgencyId1).

                IF NOT (dDateTo1 < ipdDateFrom OR dDateFrom1 > ipdDateTo) THEN
                    iCount += 1.
            END.
        END.
        
        RETURN iCount.
        
    END METHOD.

    METHOD PUBLIC INTEGER GetNumberOfRentsOfACar(INPUT ipcCarId AS CHARACTER ):
        DEFINE BUFFER   bufRentCar FOR RentCar.
        DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
        
        FOR EACH bufRentCar NO-LOCK WHERE bufRentCar.CarId = ipcCarId:
            iCnt = 1 + iCnt.
        END.
        
        RETURN iCnt.
    END METHOD.
END CLASS.