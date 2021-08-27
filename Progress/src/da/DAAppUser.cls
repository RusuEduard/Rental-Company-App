 
/*------------------------------------------------------------------------
   File        : DAAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 18:49:56 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DAAppUser INHERITS src.da.DAGeneric: 
    {src/include/dsAppUser.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DAAppUser(  ):
        SUPER ().
        THIS-OBJECT:TableName = "AppUser".
        THIS-OBJECT:TempTableName = "ttAppUser".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DAAppUser( ):

    END DESTRUCTOR.
    
    
    METHOD PUBLIC LOGICAL ExistsUserWithUsername(INPUT ipcUserName AS CHARACTER):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FIND FIRST bufAppUser NO-LOCK WHERE bufAppUser.UserName EQ ipcUserName NO-ERROR.
        
        RETURN AVAILABLE(bufAppUser).
    END METHOD.
    
    
    METHOD PUBLIC LOGICAL ExistsUserWithUsernameAndPassword(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FIND FIRST bufAppUser NO-LOCK WHERE (bufAppUser.UserName EQ ipcUserName) AND (bufAppUser.Password EQ ipcPassword) NO-ERROR.
        
        RETURN AVAILABLE(bufAppUser).
    END METHOD.
    
    
    METHOD PUBLIC LOGICAL ExistsUserWithUserId(INPUT ipcAppUserId AS CHARACTER):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FIND FIRST bufAppUser NO-LOCK WHERE bufAppUser.AppUserId EQ ipcAppUserId NO-ERROR.
        
        RETURN AVAILABLE(bufAppUser).
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        DO TRANSACTION:
            FOR EACH bttAppUser NO-LOCK WHERE ROW-STATE(bttAppUser) EQ ROW-DELETED:
            
                FOR FIRST bufAppUser EXCLUSIVE-LOCK WHERE bufAppUser.AppUserId EQ bttAppUser.AppUserId:
                    DELETE bufAppUser.
                END.
            END.            
        END.
        
    END METHOD.
    

    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        DO TRANSACTION:
            FOR EACH ttAppUser NO-LOCK 
                WHERE ROW-STATE(ttAppUser) = ROW-CREATED:
                
                CREATE bufAppUser.
                BUFFER-COPY ttAppUser EXCEPT ttAppUser.AppUserId TO bufAppUser.
                ASSIGN
                    bufAppUser.AppUserId = SUBSTRING(BASE64-ENCODE(GENERATE-UUID), 1, 22).
            END.
        END.
    END METHOD.
    

    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        DO TRANSACTION:
            FOR EACH ttAppUser NO-LOCK WHERE ROW-STATE(ttAppUser) EQ ROW-MODIFIED:
            
                FIND FIRST bttAppUser WHERE ROWID(bttAppUser) EQ BUFFER ttAppUser:BEFORE-ROWID NO-ERROR.
            
                IF AVAILABLE bttAppUser THEN 
                DO:
                    FOR FIRST bufAppUser EXCLUSIVE-LOCK 
                        WHERE bufAppUser.AppUserId EQ bttAppUser.AppUserId:
                        ASSIGN
                            bufAppUser.Name     = ttAppUser.Name
                            bufAppUser.Password = ttAppUser.Password.
                    END.

                END.
            END.
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID GetUserByUserName(INPUT ipcUserName AS CHARACTER, OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FOR FIRST bufAppUser NO-LOCK
            WHERE bufAppUser.UserName EQ ipcUserName:
            CREATE ttAppUser.
            BUFFER-COPY bufAppUser TO ttAppUser.
        END.
    END METHOD.
    

    METHOD PUBLIC VOID GetUserByUserNameAndPassword(INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):
        DEFINE BUFFER bufAppUser FOR AppUser.
        
        FOR FIRST bufAppUser NO-LOCK
            WHERE (bufAppUser.UserName EQ ipcUserName) AND (bufAppUser.Password EQ ipcPassword):
            CREATE ttAppUser.
            BUFFER-COPY bufAppUser TO ttAppUser.
        END.
    END METHOD.    
    
END CLASS.