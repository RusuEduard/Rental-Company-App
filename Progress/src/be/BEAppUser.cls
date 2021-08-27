 
/*------------------------------------------------------------------------
   File        : BEAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 21:35:11 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

/*
INCOMPLETE METHODS:
    DeleteAppUser
*/

CLASS src.be.BEAppUser INHERITS src.BE.BEGeneric:
    {src/include/dsAppUser.i}
    {src/include/dsRent.i}
    
    DEFINE PRIVATE VARIABLE daAppUser   AS src.da.DAAppUser           NO-UNDO.
    DEFINE PRIVATE VARIABLE beUserRole  AS src.be.BEUserRole          NO-UNDO.
    DEFINE PRIVATE VARIABLE beRent      AS src.be.BERent              NO-UNDO.
    DEFINE PRIVATE VARIABLE daValidator AS src.da.DAGenericValidation NO-UNDO.
    
    CONSTRUCTOR PUBLIC BEAppUser():
        THIS-OBJECT:daAppUser = NEW src.da.DAAppUser().
        THIS-OBJECT:beRent = NEW src.be.BERent().
        THIS-OBJECT:daValidator = NEW src.da.DAGenericValidation().
    END.
    
    DESTRUCTOR PUBLIC BEAppUser():
        DELETE OBJECT THIS-OBJECT:daAppUser NO-ERROR.
        DELETE OBJECT THIS-OBJECT:beRent NO-ERROR.
        DELETE OBJECT THIS-OBJECT:daValidator NO-ERROR.
    END DESTRUCTOR.
    
    
    METHOD PUBLIC LOGICAL ExistsUserWithUserId(INPUT ipcAppUserId AS CHARACTER):
        RETURN THIS-OBJECT:daAppUser:ExistsUserWithUserId(INPUT ipcAppUserId).
    END METHOD.
    
    
    METHOD PUBLIC VOID FetchData(INPUT ipcFilter AS CHARACTER, OUTPUT DATASET dsAppUser):
        
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(INPUT ipcfilter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        MESSAGE "DEBUG: cWhere is BEAppUser: " cWhere
            VIEW-AS ALERT-BOX.
        THIS-OBJECT:daAppUser:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsAppUser BY-REFERENCE).
        
    END METHOD. 

    
    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO INITIAL "".
        
        FOR EACH ttAppUser NO-LOCK:
            
            daValidator:isEmpty(INPUT ttAppUser.Name, INPUT "Name", INPUT-OUTPUT cErrorMessage).
            
            daValidator:isEmpty(INPUT ttAppUser.Password, INPUT "Password", INPUT-OUTPUT cErrorMessage).
            
            daValidator:isEmpty(INPUT ttAppUser.UserName, INPUT "Username", INPUT-OUTPUT cErrorMessage).
            
            LOG-MANAGER:WRITE-MESSAGE(SUBSTITUTE("Error message &1", cErrorMessage)).
            IF THIS-OBJECT:daAppUser:ExistsUserWithUsername(INPUT ttAppUser.UserName) THEN
                cErrorMessage = cErrorMessage + "This username is already taken!~n".
                
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
        
        THIS-OBJECT:daAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
            
    END METHOD.
    
    
    METHOD PRIVATE VOID existsActiveRentForUser(INPUT ipcAppUserId AS CHARACTER, OUTPUT oplExists AS LOGICAL):

        DEFINE VARIABLE lExists AS LOGICAL NO-UNDO.
        
        THIS-OBJECT:beRent:FetchRent(OUTPUT DATASET dsRent BY-REFERENCE).
        
        FIND FIRST ttRent NO-LOCK WHERE ttRent.AppUserId EQ ipcAppUserId AND ttRent.DateFrom LT TODAY AND ttRent.DateTo GT TODAY NO-ERROR.
        
        oplExists = AVAILABLE(ttRent).
        
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE lExists AS LOGICAL NO-UNDO.
        THIS-OBJECT:beUserRole = NEW src.BE.BEUserRole().
        
        //delete all UserRole entries that have AppUserId eq to the id of the record to be deleted.
        FOR EACH bttAppUser NO-LOCK WHERE ROW-STATE(bttAppUser) EQ ROW-DELETED:
            existsActiveRentForUser(INPUT bttAppUser.AppUserId,OUTPUT lExists).
            
            IF lExists THEN 
            DO: 
                UNDO, THROW NEW Progress.Lang.AppError("This user has an active rent!~n", 100).
            END.
            ELSE 
            DO:
                THIS-OBJECT:beUserRole:DeleteAppUserId(INPUT bttAppUser.AppUserId).
                THIS-OBJECT:beRent:DeleteRentWithAppUserId(INPUT-OUTPUT DATASET dsRent BY-REFERENCE, INPUT bttAppUser.AppUserId).
            END.
        END.    
        
        THIS-OBJECT:daAppUser:DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
        FINALLY:
            DELETE OBJECT THIS-OBJECT:beUserRole NO-ERROR.    
        END FINALLY.
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO.
        
        FOR EACH ttAppUser NO-LOCK:
            IF ttAppUser.NAME EQ "" OR ttAppUser.NAME EQ ? THEN
                cErrorMessage = cErrorMessage + "Name cannot be empty!~n".
                
            IF ttAppUser.Password EQ "" OR ttAppUser.Password EQ ? THEN
                cErrorMessage = cErrorMessage + "Password cannot be empty!~n".
                
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
        
        THIS-OBJECT:daAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CountAppUsers(INPUT filter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        THIS-OBJECT:daAppUser:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    
    METHOD PUBLIC VOID GetUserByUsername(INPUT ipcUserName AS CHARACTER, OUTPUT DATASET dsAppUser):
    
        IF NOT THIS-OBJECT:daAppUser:ExistsUserWithUsername(INPUT ipcUserName) THEN
            UNDO, THROW NEW Progress.Lang.AppError("There is no account associated with this username!~n", 100).
        
        THIS-OBJECT:daAppUser:GetUserByUserName(INPUT ipcUserName,  OUTPUT DATASET dsAppUser BY-REFERENCE).
        
    END METHOD.    

    METHOD PUBLIC VOID GetUserByUsernameAndPassword(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):
        IF NOT THIS-OBJECT:daAppUser:ExistsUserWithUsernameAndPassword(INPUT ipcUserName, INPUT ipcPassword) THEN
            UNDO, THROW NEW Progress.Lang.AppError("There is no account associated with this username and password!~n", 100).
        daAppUser:GetUserByUserNameAndPassword(INPUT ipcUserName, INPUT ipcPassword, OUTPUT DATASET dsAppUser BY-REFERENCE).
    END METHOD.     
END CLASS.