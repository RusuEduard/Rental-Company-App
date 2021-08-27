 
/*------------------------------------------------------------------------
   File        : BEUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 22:41:15 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.


CLASS src.BE.BEUserRole INHERITS src.BE.BEGeneric:
    {src/include/dsUserRole.i} 
    {src/include/dsRentalCompany.i}

    DEFINE PRIVATE VARIABLE daUserRole      AS src.da.DAUserRole.
    DEFINE PRIVATE VARIABLE beAppUser       AS src.be.BEAppUser.
    DEFINE PRIVATE VARIABLE beRoleType      AS src.be.BERoleType.
    DEFINE PRIVATE VARIABLE beRentalCompany AS src.BE.BERentalCompany.
    
    
    CONSTRUCTOR PUBLIC BEUserRole (  ):
        SUPER ().
        THIS-OBJECT:daUserRole = NEW src.da.DAUserRole().    
    END CONSTRUCTOR.


    DESTRUCTOR PUBLIC BEUserRole ( ):
        DELETE OBJECT THIS-OBJECT:daUserRole.
    END DESTRUCTOR.
    
    
    METHOD PUBLIC VOID FetchData(INPUT ipcFilter AS CHARACTER, OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(INPUT ipcfilter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        THIS-OBJECT:daUserRole:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsUserRole BY-REFERENCE).
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteAppUserId(INPUT ipcAppUserId AS CHARACTER):
        THIS-OBJECT:daUserRole:DeleteAppUserId(INPUT ipcAppUserId).
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteRoleTypeId(INPUT ipcRoleTypeId AS CHARACTER):
        THIS-OBJECT:daUserRole:DeleteRoleTypeId(INPUT ipcRoleTypeId).
    END METHOD.
    
    METHOD PUBLIC VOID DeleteUserRoleWithRentalCompanyId(INPUT ipcRentalCompanyId AS CHARACTER):
        THIS-OBJECT:daUserRole:DeleteUserRoleWithRentalCompanyId(INPUT ipcRentalCompanyId).
    END METHOD.
        
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO INITIAL "".
        THIS-OBJECT:beAppUser = NEW src.be.BEAppUser().
        THIS-OBJECT:beRoleType = NEW src.be.BERoleType().
        THIS-OBJECT:beRentalCompany = NEW src.BE.BERentalCompany().
        DEFINE VARIABLE lIsUserSuper     AS LOGICAL   NO-UNDO.
        DEFINE VARIABLE cRoleDescription AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lAccountExists   AS LOGICAL   NO-UNDO.
        
        FOR EACH ttUserRole NO-LOCK:
            
            IF NOT THIS-OBJECT:beAppUser:ExistsUserWithUserId(INPUT ttUserRole.AppUserId) THEN
                cErrorMessage = cErrorMessage + "There is no AppUser with given AppUserId!~n".
                
            IF NOT THIS-OBJECT:beRoleType:ExistsWithRoleTypeId(INPUT ttUserRole.RoleTypeId) THEN
                cErrorMessage = cErrorMessage + "There is no RoleType with given RoleTypeId!~n".                

            THIS-OBJECT:beRentalCompany:GetData(OUTPUT DATASET dsRentalCompany BY-REFERENCE).
            FIND FIRST ttRentalCompany NO-LOCK WHERE ttRentalCompany.RentalCompanyId EQ ttUserRole.RentalCompanyId NO-ERROR.
            
            IF NOT AVAILABLE(ttRentalCompany) THEN
                cErrorMessage = cErrorMessage + "There is no Rental Company with given RoleCompanyId!~n".
            
            THIS-OBJECT:beRoleType:GetRoleTypeDescription(INPUT ttUserRole.RoleTypeId, OUTPUT cRoleDescription).
            IF  ttUserRole.RentalCompanyId EQ "All" AND cRoleDescription NE "superadmin" THEN
                cErrorMessage = cErrorMessage + "Only a superadmin has access to all Companies!~n".
                
            THIS-OBJECT:daUserRole:ExistsAccount(INPUT ttUserRole.AppUserId, INPUT ttUserRole.RentalCompanyId, OUTPUT lAccountExists).
            IF lAccountExists THEN
                cErrorMessage = cErrorMessage + "An account between the user and the company already exists!~n".
                
            IsUserSuperAdmin(INPUT ttUserRole.AppUserId, OUTPUT lIsUserSuper).
            IF lIsUserSuper THEN
                cErrorMessage = cErrorMessage + "The user is already a super admin!~n".  
            
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
        
        THIS-OBJECT:daUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
        FINALLY:
            DELETE OBJECT THIS-OBJECT:beAppUser NO-ERROR.
            DELETE OBJECT THIS-OBJECT:beRoleType NO-ERROR.
            DELETE OBJECT THIS-OBJECT:beRentalCompany NO-ERROR.
            DATASET dsRentalCompany:EMPTY-DATASET ().   
        END FINALLY.
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        THIS-OBJECT:daUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO INITIAL "".
        THIS-OBJECT:beRoleType = NEW src.be.BERoleType().
        THIS-OBJECT:beRentalCompany = NEW src.BE.BERentalCompany().
        DEFINE VARIABLE lIsUserSuper     AS LOGICAL   NO-UNDO.
        DEFINE VARIABLE cRoleDescription AS CHARACTER NO-UNDO.
        DEFINE VARIABLE lAccountExists   AS LOGICAL   NO-UNDO.
        
        FOR EACH ttUserRole NO-LOCK WHERE ROW-STATE(ttUserRole) EQ ROW-MODIFIED:
        
            IF NOT THIS-OBJECT:beRoleType:ExistsWithRoleTypeId(ttUserRole.RoleTypeId) THEN
                cErrorMessage = cErrorMessage + "Invalid update! There is no role type with given RoleTypeId!~n".
            
            THIS-OBJECT:beRentalCompany:GetData(OUTPUT DATASET dsRentalCompany BY-REFERENCE).
            FIND FIRST ttRentalCompany NO-LOCK WHERE ttRentalCompany.RentalCompanyId EQ ttUserRole.RentalCompanyId NO-ERROR.
            
            IF NOT AVAILABLE(ttRentalCompany) THEN
                cErrorMessage = cErrorMessage + "There is no Rental Company with given RoleCompanyId!~n". 
                
            THIS-OBJECT:beRoleType:GetRoleTypeDescription(INPUT ttUserRole.RoleTypeId, OUTPUT cRoleDescription).
            IF  ttUserRole.RentalCompanyId EQ "All" AND cRoleDescription NE "superadmin" THEN
                cErrorMessage = cErrorMessage + "Only a superadmin has access to all Companies!~n".
            
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        
        END.
        
        THIS-OBJECT:daUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole).
        
        FINALLY:
            DELETE OBJECT THIS-OBJECT:beRoleType NO-ERROR.
            DELETE OBJECT THIS-OBJECT:beRentalCompany NO-ERROR.
            DATASET dsRentalCompany:EMPTY-DATASET ().    
        END FINALLY.
    END METHOD.
    
    
    METHOD PUBLIC VOID CountUserRole(INPUT filter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        THIS-OBJECT:daUserRole:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    
    METHOD PUBLIC VOID IsUserSuperAdmin(INPUT ipcAppUserId AS CHARACTER, OUTPUT oplIsSuper AS LOGICAL):
        
        THIS-OBJECT:daUserRole:IsUserSuperAdmin(INPUT ipcAppUserId, OUTPUT oplIsSuper).
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CountUsersForCompany(INPUT ipcRentalCompanyId AS CHARACTER, OUTPUT opiUsersCount AS INTEGER):
    
        THIS-OBJECT:daUserRole:CountUsersForCompany(INPUT ipcRentalCompanyId, OUTPUT opiUsersCount).
    
    END METHOD.   

END CLASS.