USING Progress.Lang.*.
BLOCK-LEVEL ON ERROR UNDO, THROW.


CLASS src.be.BERent INHERITS src.be.BEGeneric : 
    {src/include/dsRent.i}
    {src/include/dsRentCar.i}
    {src/include/dsCarAgency.i}
    {src/include/dsRentalCompany.i}
    {src/include/dsTopUsers.i}
    {src/include/dsAppUser.i}
   
    DEFINE PRIVATE VARIABLE daRent AS src.DA.DARent NO-UNDO.
    
    CONSTRUCTOR PUBLIC BERent (  ):
        
        daRent = NEW src.DA.DARent().
        
    END CONSTRUCTOR.

 

    DESTRUCTOR PUBLIC BERent ( ):
    
        DELETE OBJECT daRent NO-ERROR.
    
    END DESTRUCTOR.
    
    METHOD PUBLIC LOGICAL ExistsRentWithRentId(INPUT ipcRentId AS CHARACTER):
        
        RETURN THIS-OBJECT:daRent:ExistsRentWithRentId(INPUT ipcRentId).
        
    END METHOD.
    
    METHOD PUBLIC CHARACTER GetCarAgencyIdByRentId(INPUT ipcRentId AS CHARACTER):
        
        RETURN THIS-OBJECT:daRent:GetCarAgencyIdByRentId(INPUT ipcRentId).
        
    END METHOD.
    
    METHOD PUBLIC DATE  getDateFromByRentId(INPUT ipcRentId AS CHARACTER, INPUT cCarAgencyId AS CHARACTER):
        
        RETURN THIS-OBJECT:daRent:getDateFromByRentId(INPUT ipcRentId, INPUT cCarAgencyId).
        
    END METHOD.
  
    METHOD PUBLIC DATE  getDateToByRentId(INPUT ipcRentId AS CHARACTER, INPUT cCarAgencyId AS CHARACTER):
        
        RETURN THIS-OBJECT:daRent:getDateToByRentId(INPUT ipcRentId, INPUT cCarAgencyId).
        
    END METHOD.
 
    METHOD PUBLIC VOID ReadRent(INPUT filter AS CHARACTER, OUTPUT dataset dsRent):
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
        ExtractABLFilter(INPUT filter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        
        THIS-OBJECT:daRent:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsRent BY-REFERENCE).
        
    END METHOD.
    
    METHOD PUBLIC VOID CreateRent (INPUT-OUTPUT dataset dsRent):
       
        DEFINE VARIABLE beUser        AS src.be.BEAppUser  NO-UNDO.
        DEFINE VARIABLE beCarSTock    AS src.be.BECarStock NO-UNDO.
        DEFINE VARIABLE cErrorMessage AS CHARACTER         INITIAL "" NO-UNDO.
        DEFINE VARIABLE dCurrentDate  AS DATE              NO-UNDO.
        
        dCurrentDate = TODAY.
        
        beUser = NEW src.be.BEAppUser().
        beCarStock = NEW src.be.BECarStock().
        
        FOR EACH ttRent NO-LOCK WHERE ROW-STATE(ttRent) = ROW-CREATED:
            
            IF NOT(beUser:ExistsUserWithUserId(ttRent.AppUserId)) THEN
                cErrorMessage = cErrorMessage + "Userul nu exista".
            /*            IF NOT(beCarAgency:ExistsCarAgencyWithCarAgencyId(ttRent.CarAgencyId))*/
            /*                cErrorMessage = cErrorMessage + "CarAgency cannot be empty".      */
            IF ttRent.DateFrom = ? THEN
                cErrorMessage = cErrorMessage + "DateFrom cannot be empty".

            IF ttRent.DateTo = ? THEN
                cErrorMessage = cErrorMessage + "DateTo cannot be empty".

            IF ttRent.DateFrom > ttRent.DateTo THEN
                cErrorMessage = cErrorMessage + "DateTo can not be earlier than DateFrom".
                 
        /*            IF ttRent.DateFrom < dCurrentDate THEN                                      */
        /*                 cErrorMessage = cErrorMessage + "You cannot create a rent in the past".*/
        END.
        
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        
        daRent:CreateRent(INPUT-OUTPUT dataset dsRent BY-REFERENCE).
        
        FINALLY:
            
            DELETE OBJECT beUser NO-ERROR.    
            DELETE OBJECT beCArStock NO-ERROR.  
             
        END FINALLY.
    END METHOD.
    
    
    
    METHOD PUBLIC VOID UpdateRent (INPUT-OUTPUT dataset dsRent):
        
        DEFINE VARIABLE beUser        AS src.be.BEAppUser NO-UNDO.
        DEFINE VARIABLE beRentCar     AS src.be.BERentCar NO-UNDO.
        DEFINE VARIABLE cErrorMessage AS CHARACTER        INITIAL "" NO-UNDO.
        DEFINE VARIABLE cCarAgencyId  AS CHARACTER        NO-UNDO.
        DEFINE VARIABLE dDateFrom     AS DATE             NO-UNDO.
        DEFINE VARIABLE dDateTo       AS DATE             NO-UNDO.
        
        beUser = NEW src.be.BEAppUser().
        beRentCar = NEW src.be.beRentCar().
        
        FOR EACH ttRent NO-LOCK WHERE ROW-STATE(ttRent) = ROW-MODIFIED:
            
            IF NOT(beUser:ExistsUserWithUserId(ttRent.AppUserId)) THEN
                cErrorMessage = cErrorMessage + "Userul nu exista".
                
            IF ttRent.DateFrom = ? THEN
                cErrorMessage = cErrorMessage + "DateFrom cannot be empty".
                

            IF ttRent.DateTo = ? THEN
                cErrorMessage = cErrorMessage + "DateTo cannot be empty".
                
            IF ttRent.DateFrom > ttRent.DateTo THEN
                cErrorMessage = cErrorMessage + "DateTo can not be earlier than DateFrom".
                
            cCarAgencyId = ttRent.CarAgencyId.
            dDateFrom = ttRent.DateFrom.
            dDateTo = ttRent.DateTo.
            
            IF NOT(beRentCar:VerifyNewInputs(INPUT ttRent.RentId, INPUT DATASET dsRentCar BY-REFERENCE, INPUT cCarAgencyId, INPUT dDateFrom, INPUT dDateTo)) THEN 
                cErrorMessage = cErrorMessage + "There are no available or not enough cars for the time period you selected. Please try another option or create a new rent".
             
            
        END.
        
        IF cErrorMessage <> "" THEN 
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
            
        daRent:UpdateRent(INPUT-OUTPUT dataset dsRent BY-REFERENCE).
        
        FINALLY:
            
            DELETE OBJECT beUser NO-ERROR.    
            DELETE OBJECT beRentCar NO-ERROR.  
             
        END FINALLY.
        
    END METHOD.
    
    
    
    METHOD PUBLIC VOID DeleteRent(INPUT-OUTPUT dataset dsRent):
        
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        DO TRANSACTION:
            FOR EACH bttRent NO-LOCK WHERE ROW-STATE(bttRent) = ROW-DELETED:
                IF bttRent.RentStatus = 1 THEN
                    cErrorMessage += "You can not delete a rent in progress".
            
            END.
        
            IF cErrorMessage <> "" THEN 
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
            
            daRent:DeleteRent(INPUT-OUTPUT dataset dsRent BY-REFERENCE).
        END.
        
    END METHOD.
    
    METHOD PUBLIC VOID DeleteRentWithAppUserId(INPUT-OUTPUT dataset dsRent, INPUT ipcId AS CHARACTER):
        
        readRent(INPUT "",OUTPUT DATASET dsRent).
        
        TEMP-TABLE ttRent:TRACKING-CHANGES = TRUE.
        
        FOR EACH ttRent WHERE ttRent.AppUserId = ipcId:
            
            DELETE ttRent.
            
        END.
        
        TEMP-TABLE ttRent:TRACKING-CHANGES = FALSE.
        daRent:DeleteRent(INPUT-OUTPUT DATASET dsRent BY-REFERENCE). 
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CountRent (INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER, INPUT dataset dsRent):
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daRent:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
        
    END METHOD.
    
    METHOD PUBLIC CHARACTER getCompaniesListForAnUser(INPUT ipcAppUserId AS CHARACTER):
        
        DEFINE VARIABLE beCarAgency      AS src.be.beCarAgency     NO-UNDO.
        DEFINE VARIABLE cListOfCompanies AS CHARACTER              NO-UNDO INITIAL "".
        DEFINE VARIABLE beRentalCompany  AS src.be.beRentalCompany NO-UNDO.
        
        beCarAgency = NEW src.be.beCarAgency().
        beRentalCompany = NEW src.be.beRentalCompany().
        ReadRent(INPUT SUBSTITUTE("WHERE Rent.AppUserId = '&1'", ipcAppUserId), OUTPUT DATASET dsRent BY-REFERENCE).
        
        FOR EACH ttRent NO-LOCK:
            
            beCarAgency:ReadCarAgency(INPUT SUBSTITUTE("WHERE CarAgency.CarAgencyId = '&1'",ttRent.CarAgencyId), OUTPUT DATASET dsCarAgency BY-REFERENCE).
                
            FOR EACH ttCarAgency NO-LOCK BREAK BY ttCarAgency.RentalCompanyId:
                IF FIRST-OF(ttCarAgency.RentalCompanyId) THEN 
                DO:
                   
                    beRentalCompany:readRentalCompany(INPUT SUBSTITUTE("WHERE RentalCompany.RentalCompanyId= '&1'", ttCarAgency.RentalCompanyId), OUTPUT DATASET dsRentalCompany BY-REFERENCE).
                    FOR FIRST ttRentalCompany:
                        IF(INDEX(cListOfCompanies,ttRentalCompany.Description) = 0) THEN 
                            cListOfCompanies += ttRentalCompany.Description + " ".
                    END.
                END.
                   
            END.
           
        END.
        
        FINALLY:
            
            DELETE OBJECT beRentalCompany NO-ERROR.    
            DELETE OBJECT beCarAgency NO-ERROR. 
            RETURN cListOfCompanies.  
             
        END FINALLY.
        
    END.
    
    METHOD PUBLIC INTEGER GetNumberOfRents(INPUT ipcUserId AS CHARACTER):
        
        DEFINE VARIABLE iCount AS INTEGER NO-UNDO INITIAL 0.
        ReadRent(INPUT SUBSTITUTE("WHERE Rent.AppUserId = '&1'", ipcUSerId), OUTPUT DATASET dsRent BY-REFERENCE).
        
        FOR EACH ttRent NO-LOCK:
            
            iCount += 1.
            
        END.
        
        RETURN iCount.
    END.
    
    METHOD PUBLIC VOID TopUsers(OUTPUT  DATASET dsTopUsers):
        
        DEFINE VARIABLE beRent         AS src.be.BERent    NO-UNDO. 
        DEFINE VARIABLE beAppUser      AS src.be.beAppUSer NO-UNDO.
        DEFINE VARIABLE iNumberOfRents AS INTEGER          NO-UNDO.
        
        beRent = NEW src.be.beRent().
        beAppUser = NEW src.be.BEAppUser().
        
        DATASET dsTopUsers:EMPTY-DATASET ().
        
        beAppUser:FetchData(INPUT "",OUTPUT DATASET dsAppUser BY-REFERENCE ).
        
        FOR EACH ttAppUser NO-LOCK:
             
            iNumberOfRents = beRent:GetNumberOfRents(ttAppUser.AppUserId).
            CREATE ttTopUsers.
            ASSIGN 
                ttTopUsers.NumberOfRents = iNumberOfRents
                ttTopUsers.Name          = ttAppUser.Name.
                ttTopUsers.Username = ttAppUser.Username.
                ttTopUsers.ListOfCompanies = beRent:getCompaniesListForAnUser(ttAppUser.AppUserId).
           
        END.
       
            
        OutputToFile(INPUT-OUTPUT DATASET dsTopUsers).
        
        FINALLY:
            DELETE OBJECT beRent NO-ERROR.    
            DELETE OBJECT beAppUser NO-ERROR.
        END FINALLY.

    END METHOD.  
    
    METHOD PRIVATE VOID OutputToFile(INPUT-OUTPUT DATASET dsTopUsers):
        
        DEFINE VARIABLE iContor     AS INTEGER   NO-UNDO.
        DEFINE VARIABLE cFilename   AS CHARACTER NO-UNDO .
        DEFINE VARIABLE my-datetime AS DATETIME  NO-UNDO.
        
        cFilename = SESSION:TEMP-DIRECTORY + "TopUsers.csv".
      
        DISPLAY cFileName FORMAT "x(60)".
        OUTPUT  TO  VALUE (cFilename).
        EXPORT DELIMITER ";" "Number of Rents" "UserName" "Name" "ListOfCompanies".
        
        FOR EACH ttTopUsers BY ttTopUsers.NumberOfRents DESCENDING:
            
            IF iContor < 10 THEN DO:
                EXPORT DELIMITER ";" ttTopUsers.NumberOfRents ttTopUsers.UserName ttTopUsers.Name ttTopUsers.ListOfCompanies.
                iContor =  1 + iContor.
           
            END.
            ELSE  DELETE ttTopUsers .
            
            
        END.
        OUTPUT CLOSE.
    END METHOD.
    
    
    METHOD PUBLIC VOID FetchRent(OUTPUT DATASET dsRent):
        THIS-OBJECT:daRent:FetchGeneric(OUTPUT DATASET dsRent BY-REFERENCE).
    END METHOD.
 
    METHOD PUBLIC LOGICAL ExistsActiveRentWithCarAgencyId(INPUT ipcCarAgencyId AS CHARACTER):
        RETURN daRent:ExistsActiveRentWithCarAgencyId(INPUT ipcCarAgencyId).
    END METHOD.
END CLASS.