 
/*------------------------------------------------------------------------
   File        : BECompanyByUserNum
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 16 22:44:06 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.be.BECompanyByUserNum: 
    {src/include/dsCompanyByUserNum.i}
    {src/include/dsCarAgency.i}
    {src/include/dsRentalCompany.i}

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    DEFINE PRIVATE VARIABLE beUserRole      AS src.be.beUserRole.
    DEFINE PRIVATE VARIABLE beRentalCompany AS src.be.beRentalCompany.
    DEFINE PRIVATE VARIABLE beCarAgency     AS src.be.beCarAgency.
    
    CONSTRUCTOR PUBLIC BECompanyByUserNum (  ):
        SUPER ().
        THIS-OBJECT:beCarAgency = NEW src.BE.BECarAgency().
        THIS-OBJECT:beUserRole = NEW src.BE.BEUserRole().
        THIS-OBJECT:beRentalCompany = NEW src.BE.BERentalCompany().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BECompanyByUserNum ( ):
        DELETE OBJECT THIS-OBJECT:beCarAgency NO-ERROR.
        DELETE OBJECT THIS-OBJECT:beUserRole NO-ERROR.
        DELETE OBJECT THIS-OBJECT:beRentalCompany NO-ERROR.
    END DESTRUCTOR.
    
    
    METHOD PRIVATE VOID countAgancies(INPUT ipcRentalCompanyId AS CHARACTER, OUTPUT opiNumOfAgancies AS INTEGER):
        DEFINE VARIABLE iCount AS INTEGER NO-UNDO INITIAL 0.
        
        THIS-OBJECT:beCarAgency:GetData(OUTPUT DATASET dsCarAgency BY-REFERENCE).
        
        FOR EACH ttCarAgency NO-LOCK WHERE ttCarAgency.RentalCompanyId EQ ipcRentalCompanyId:
            iCount = iCount + 1.
        END.
        
        opiNumOfAgancies = iCount.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID TopTenCompanies(OUTPUT DATASET dsCompanyByUserNum):
        
        DEFINE VARIABLE cFilter        AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iCountUsers    AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iCountAgancies AS INTEGER   NO-UNDO.
        
        DATASET dsCarAgency:EMPTY-DATASET ().
        DATASET dsCompanyByUserNum:EMPTY-DATASET ().
        DATASET dsRentalCompany:EMPTY-DATASET ().
        THIS-OBJECT:beRentalCompany:GetData(OUTPUT DATASET dsRentalCompany BY-REFERENCE).
        
        FOR EACH ttRentalCompany NO-LOCK
            WHERE ttRentalCompany.RentalCompanyId NE "All":
            THIS-OBJECT:beUserRole:CountUsersForCompany(INPUT ttRentalCompany.RentalCompanyId, OUTPUT iCountUsers).
            countAgancies(INPUT ttRentalCompany.RentalCompanyId, OUTPUT iCountAgancies).
            CREATE ttCompanyByUserNum.
            ASSIGN
                ttCompanyByUserNum.CompanyName      = ttRentalCompany.Description
                ttCompanyByUserNum.NumberOfUsers    = iCountUsers
                ttCompanyByUserNum.NumberOfAgencies = iCountAgancies.
        END.
        
        OutputToFile(INPUT DATASET dsCompanyByUserNum BY-REFERENCE).
        
    END METHOD.
    
    
    METHOD PRIVATE VOID OutputToFile(INPUT DATASET dsCompanyByUserNum):
        
        DEFINE VARIABLE iContor     AS INTEGER   NO-UNDO.
        DEFINE VARIABLE cFilename   AS CHARACTER NO-UNDO .
        DEFINE VARIABLE my-datetime AS DATETIME  NO-UNDO.

        my-datetime = DATETIME(TODAY, MTIME).

        cFilename = SESSION:TEMP-DIRECTORY + "CompaniesByUsers.csv".
        LOG-MANAGER :WRITE-MESSAGE (cFilename). 
   
        OUTPUT  TO  VALUE (cFilename).
        EXPORT DELIMITER ";" "Company name" "Number of users" "Number of agencies".
        
        FOR EACH ttCompanyByUserNum NO-LOCK:
            
            IF iContor < 10 THEN 
            DO:
                EXPORT DELIMITER ";" ttCompanyByUserNum.CompanyName ttCompanyByUserNum.NumberOfUsers ttCompanyByUserNum.NumberOfAgencies.
                iContor =  1 + iContor.
            END.
            ELSE  DELETE ttCompanyByUserNum .
            
            
        END.
        OUTPUT CLOSE.
    END METHOD.

END CLASS.