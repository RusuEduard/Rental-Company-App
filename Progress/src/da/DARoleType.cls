 
/*------------------------------------------------------------------------
   File        : DARoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 19:58:24 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DARoleType INHERITS src.da.DAGeneric:
    {src/include/dsRoleType.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DARoleType(  ):
        SUPER ().
        THIS-OBJECT:TableName = "RoleType".
        THIS-OBJECT:TempTableName = "ttRoleType".
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DARoleType( ):

    END DESTRUCTOR.
    
    
    METHOD PUBLIC LOGICAL ExistsWithRoleTypeId(INPUT ipcRoleTypeId AS CHARACTER):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        FIND FIRST bufRoleType NO-LOCK WHERE bufRoleType.RoleTypeId EQ ipcRoleTypeId NO-ERROR.
        
        RETURN AVAILABLE(bufRoleType).
    END METHOD.
    
    

    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        DO TRANSACTION:
            FOR EACH bttRoleType NO-LOCK WHERE ROW-STATE(bttRoleType) EQ ROW-DELETED:
            
                FOR FIRST bufRoleType EXCLUSIVE-LOCK WHERE bufRoleType.RoleTypeId EQ bttRoleType.RoleTypeId:
                    DELETE bufRoleType.
                END.
            END.
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        DO TRANSACTION:
            FOR EACH ttRoleType NO-LOCK:
                
                CREATE bufRoleType.
                BUFFER-COPY ttRoleType EXCEPT ttRoleType.RoleTypeId TO bufRoleType.
                ASSIGN
                    bufRoleType.RoleTypeId = SUBSTRING(BASE64-ENCODE(GENERATE-UUID), 1, 22).
            END.
        END.
        
    END METHOD.
    
    
    METHOD PUBLIC VOID GetRoleTypeDescription(INPUT ipcRoleTypeId AS CHARACTER, OUTPUT opcDescription AS CHARACTER):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        FOR FIRST bufRoleType NO-LOCK 
            WHERE bufRoleType.RoleTypeId EQ ipcRoleTypeId:
            opcDescription = bufRoleType.Description.
        END.
    END METHOD.
    

    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE BUFFER bufRoleType FOR RoleType.
        
        DO TRANSACTION:
            FOR EACH ttRoleType NO-LOCK WHERE ROW-STATE(ttRoleType) EQ ROW-MODIFIED:
            
                FIND FIRST bttRoleType WHERE ROWID(bttRoleType) EQ BUFFER ttRoleType:BEFORE-ROWID NO-ERROR.
            
                IF AVAILABLE bttRoleType THEN 
                DO:
                    FOR FIRST bufRoleType EXCLUSIVE-LOCK 
                        WHERE bufRoleType.RoleTypeId EQ bttRoleType.RoleTypeId:
                        ASSIGN
                            bufRoleType.Description = ttRoleType.DESCRIPTION.
                    END.

                END.
        
            END.
        END.
    END METHOD. 

END CLASS.