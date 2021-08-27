 
 /*------------------------------------------------------------------------
    File        : DARent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 02 19:54:00 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DARent INHERITS src.DA.DAGeneric:
    {src/include/dsRent.i}
    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DARent ( ):
        TableName = "Rent".
        TempTableName = "ttRent".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DARent ( ):

    END DESTRUCTOR.
     METHOD PUBLIC VOID DeleteRentWithAppUserId(INPUT-OUTPUT dataset dsRent, INPUT ipcId AS CHARACTER):
        
        
    END METHOD.
    METHOD PUBLIC LOGICAL ExistsRentWithRentId(INPUT ipcRentId AS CHARACTER):
        DEFINE BUFFER bufRent FOR Rent.
        
        FIND FIRST bufRent NO-LOCK WHERE bufRent.RentId EQ ipcRentId NO-ERROR.
        
        RETURN AVAILABLE(bufRent).
    END METHOD.
    
     METHOD PUBLIC CHARACTER  GetCarAgencyIdByRentId(INPUT ipcRentId AS CHARACTER):
         
        DEFINE BUFFER bufRent FOR Rent.
        
        FIND FIRST Rent NO-LOCK WHERE Rent.RentId EQ ipcRentId NO-ERROR.
        IF AVAILABLE(Rent) THEN
            RETURN Rent.CarAgencyId.
        
    END METHOD.
   
    METHOD PUBLIC DATE  getDateFromByRentId(INPUT ipcRentId AS CHARACTER, INPUT cCarAgencyId AS CHARACTER):
        DEFINE BUFFER bufRent FOR Rent.
        
        FIND FIRST Rent NO-LOCK WHERE Rent.RentId EQ ipcRentId AND Rent.CarAgencyId EQ cCarAgencyId NO-ERROR.
        IF AVAILABLE(Rent) THEN 
        RETURN Rent.DateFrom.
    END METHOD.
    
    METHOD PUBLIC DATE  getDateToByRentId(INPUT ipcRentId AS CHARACTER, INPUT cCarAgencyId AS CHARACTER):
        DEFINE BUFFER bufRent FOR Rent.
        
        FIND FIRST Rent NO-LOCK WHERE Rent.RentId EQ ipcRentId AND Rent.CarAgencyId EQ cCarAgencyId NO-ERROR.
        IF AVAILABLE(Rent) THEN
        RETURN Rent.DateTo.
    END METHOD.
   
    
    METHOD PUBLIC VOID CreateRent (INPUT-OUTPUT dataset dsRent):
        DEFINE BUFFER bufRent FOR Rent.
        DEFINE VARIABLE dCurrentDate AS DATE NO-UNDO.
        dCurrentDate = TODAY.
        FOR EACH ttRent NO-LOCK
            WHERE ROW-STATE(ttRent) = ROW-CREATED:
            CREATE bufRent.
            BUFFER-COPY ttRent EXCEPT RentId RentStatus TO bufRent.
            ASSIGN
                bufRent.RentId = GUID.
            IF dCurrentDate < ttRent.DateFrom THEN
                ASSIGN
                    bufRent.RentStatus = 2.
            ELSE IF dCurrentDate > ttRent.DateTo THEN
                ASSIGN
                    bufRent.RentStatus = 0.
            ELSE 
                ASSIGN
                    bufRent.RentStatus = 1.
        END.
    END METHOD.
    
    METHOD PUBLIC VOID UpdateRent(INPUT-OUTPUT DATASET dsRent):
        DEFINE VARIABLE dCurrentDate AS DATE NO-UNDO.
        DEFINE BUFFER bufRent FOR Rent.
        dCurrentDate = TODAY.
        FOR EACH ttRent NO-LOCK
            WHERE ROW-STATE(ttRent) = ROW-MODIFIED:
            FIND FIRST bufRent EXCLUSIVE-LOCK
                WHERE bufRent.RentId = ttRent.RentId NO-ERROR.
            IF AVAILABLE bufRent THEN DO:
                BUFFER-COPY ttRent EXCEPT  RentId RentStatus TO bufRent.

            IF dCurrentDate < ttRent.DateFrom THEN
                ASSIGN
                    bufRent.RentStatus = 2.
            ELSE IF dCurrentDate > ttRent.DateTo THEN
                ASSIGN
                    bufRent.RentStatus = 0.
            ELSE 
                ASSIGN
                    bufRent.RentStatus = 1.
            END.
            
            ELSE
                UNDO,THROW NEW Progress.Lang.AppError("Rent not found", 100).
        END.
    END METHOD.

    METHOD PUBLIC VOID DeleteRent(INPUT-OUTPUT dataset dsRent):
        DEFINE BUFFER bufRent FOR Rent.
        DEFINE BUFFER bufRentCar FOR RentCar.
        FOR EACH bttRent NO-LOCK
            WHERE ROW-STATE(bttRent) = ROW-DELETED:
            FIND FIRST bufRent EXCLUSIVE-LOCK WHERE bufRent.RentId = bttRent.RentId NO-ERROR.
            IF AVAILABLE bufRent THEN DO:
                FOR EACH bufRentCar WHERE bufRentCar.RentId = bufRent.RentId:
                    DELETE bufRentCar.
                END.
                DELETE bufRent.
            END.
            ELSE
                UNDO, THROW NEW Progress.Lang.AppError("Rent not found", 100).

        END.
    END METHOD.
    
    METHOD PUBLIC VOID FetchAllRents(OUTPUT DATASET dsRent):
        DEFINE BUFFER bufRent FOR Rent.
        DATASET dsRent:EMPTY-DATASET().
        FOR EACH bufRent NO-LOCK:
            CREATE ttRent.
            BUFFER-COPY bufRent TO ttRent.
        END.
    END METHOD.

    METHOD PUBLIC LOGICAL ExistsActiveRentWithCarAgencyId(INPUT ipcCarAgencyId AS CHARACTER):
        DEFINE BUFFER bufRent FOR Rent.
        FIND FIRST bufRent NO-LOCK WHERE (bufRent.CarAgencyId EQ ipcCarAgencyId AND bufRent.RentStatus = 1)  NO-ERROR.
        RETURN AVAILABLE(bufRent).
    END METHOD.    
    

END CLASS.