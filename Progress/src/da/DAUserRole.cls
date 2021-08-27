 
/*------------------------------------------------------------------------
   File        : DAUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 20:10:14 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DAUserRole INHERITS src.DA.DAGeneric:
    {src/include/dsUserRole.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DAUserRole(  ):
        SUPER ().
        THIS-OBJECT:TableName = "UserRole".
        THIS-OBJECT:TempTableName = "ttUserRole".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DAUserRole( ):

    END DESTRUCTOR.
    
    
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        DO TRANSACTION:
            FOR EACH bttUserRole NO-LOCK WHERE ROW-STATE(bttUserRole) EQ ROW-DELETED:
            
                FOR FIRST bufUserRole EXCLUSIVE-LOCK WHERE bufUserRole.UserRoleId EQ bttUserRole.UserRoleId:
                    DELETE bufUserRole.
                END.
            END.            
        END.
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteAppUserId(INPUT ipcAppUserId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        DO TRANSACTION:
            FOR EACH bufUserRole EXCLUSIVE-LOCK 
                WHERE bufUserRole.AppUserId EQ ipcAppUserId:
                DELETE bufUserRole.
            END. 
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteRoleTypeId(INPUT ipcRoleTypeId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        DO TRANSACTION:
            FOR EACH bufUserRole EXCLUSIVE-LOCK
                WHERE bufUserRole.RoleTypeId EQ ipcRoleTypeId:
                DELETE bufUserRole.
            END.
        END.
    END METHOD.
    
    METHOD PUBLIC VOID DeleteUserRoleWithRentalCompanyId(INPUT ipcRentalCompanyId AS CHARACTER):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        FOR EACH bufUserRole EXCLUSIVE-LOCK
            WHERE bufUserRole.RentalCompanyId EQ ipcRentalCompanyId:
            DELETE bufUserRole.
        END.
    END METHOD.
    
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        DO TRANSACTION:
            FOR EACH ttUserRole NO-LOCK 
                WHERE ROW-STATE(ttUserRole) = ROW-CREATED:
                
                CREATE bufUserRole.
                BUFFER-COPY ttUserRole EXCEPT ttUserRole.UserRoleId TO bufUserRole.
                ASSIGN
                    bufUserRole.UserRoleId = SUBSTRING(BASE64-ENCODE(GENERATE-UUID), 1, 22).
            END.
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID ExistsAccount(INPUT ipcAppUserId AS CHARACTER, INPUT ipcRentalCompanyId AS CHARACTER, OUTPUT oplExists AS LOGICAL):
        DEFINE BUFFER bufUserRole FOR UserRole.
        FIND FIRST bufUserRole NO-LOCK WHERE bufUserRole.AppUserId EQ ipcAppUserId AND bufUserRole.RentalCompanyId EQ ipcRentalCompanyId NO-ERROR.
    
        oplExists = AVAILABLE(bufUserRole).    
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
    
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        DO TRANSACTION:
            FOR EACH ttUserRole NO-LOCK WHERE ROW-STATE(ttUserRole) EQ ROW-MODIFIED:
            
                FIND FIRST bttUserRole WHERE ROWID(bttUserRole) EQ BUFFER ttUserRole:BEFORE-ROWID NO-ERROR.
            
                IF AVAILABLE bttUserRole THEN 
                DO:
                    FOR FIRST bufUserRole EXCLUSIVE-LOCK 
                        WHERE bufUserRole.UserRoleId EQ bttUserRole.UserRoleId:
                        ASSIGN
                            bufUserRole.RoleTypeId      = ttUserRole.RoleTypeId
                            bufUserRole.RentalCompanyId = ttUserRole.RentalCompanyId.
                    END.

                END.
            END.
        END.
    
    END METHOD.
    
    
    METHOD PUBLIC VOID IsUserSuperAdmin(INPUT ipcAppUserId AS CHARACTER, OUTPUT oplIsSuperadmin AS LOGICAL):
        
        DEFINE BUFFER bufUserRole FOR UserRole.
        
        oplIsSuperadmin = FALSE.
        
        FOR FIRST bufUserRole NO-LOCK WHERE bufUserRole.AppUserId EQ ipcAppUserId:
            IF bufUserRole.RentalCompanyId EQ "All" THEN
                oplIsSuperadmin = TRUE.
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CountUsersForCompany(INPUT ipcRentalCompanyId AS CHARACTER, OUTPUT opiUsersCount AS INTEGER):
    
        DEFINE BUFFER bufUserRole FOR UserRole.
        DEFINE VARIABLE iUsersCount AS INTEGER NO-UNDO INITIAL 0.

        FOR EACH bufUserRole NO-LOCK 
            WHERE bufUserRole.RentalCompanyId EQ ipcRentalCompanyId:
            
            iUsersCount = iUsersCount + 1.
                  
        END.
        
        opiUsersCount = iUsersCount.
    END METHOD.
    
    
END CLASS. 