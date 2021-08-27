 
/*------------------------------------------------------------------------
   File        : BERoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 22:57:14 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BERoleType INHERITS src.BE.BEGeneric:
    {src/include/dsRoleType.i} 

    DEFINE PRIVATE VARIABLE daRoleType  AS src.DA.DARoleType.
    DEFINE PRIVATE VARIABLE beUserRole  AS src.be.BEUserRole.
    DEFINE PRIVATE VARIABLE daValidator AS src.da.DAGenericValidation.

    CONSTRUCTOR PUBLIC BERoleType (  ):
        SUPER ().
        THIS-OBJECT:daRoleType = NEW src.da.DARoleType().  
        THIS-OBJECT:daValidator = NEW src.da.DAGenericValidation().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC BERoleType ( ):
        DELETE  OBJECT THIS-OBJECT:daRoleType NO-ERROR.
        DELETE OBJECT THIS-OBJECT:daValidator NO-ERROR.
    END DESTRUCTOR.
    
    
    METHOD PUBLIC VOID FetchData(INPUT ipcFilter AS CHARACTER, OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(INPUT ipcfilter, OUTPUT cWhere, OUTPUT iMaxRows, OUTPUT iSkipRows).
        THIS-OBJECT:daRoleType:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsRoleType BY-REFERENCE).
    END METHOD.
    
    
    METHOD PUBLIC LOGICAL ExistsWithRoleTypeId(INPUT ipcRoleTypeId AS CHARACTER):
        RETURN THIS-OBJECT:daRoleType:ExistsWithRoleTypeId(INPUT ipcRoleTypeId).
    END METHOD.
    
    
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO INITIAL "".
        
        FOR EACH ttRoleType NO-LOCK:
        
            daValidator:isEmpty(INPUT ttRoleType.Description, INPUT "Description", INPUT-OUTPUT cErrorMessage).
                
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
        
        THIS-OBJECT:daRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
    END METHOD.
    
    
    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        DEFINE VARIABLE cErrorMessage AS CHARACTER NO-UNDO INITIAL "".
        
        FOR EACH ttRoleType NO-LOCK:
        
            daValidator:isEmpty(INPUT ttRoleType.Description, INPUT "Description", INPUT-OUTPUT cErrorMessage).
                
            IF cErrorMessage NE "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
        
        THIS-OBJECT:daRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType). 
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        THIS-OBJECT:beUserRole = NEW src.be.BEUserRole().
        
        FOR EACH bttRoleType NO-LOCK
            WHERE ROW-STATE(bttRoleType) EQ ROW-DELETED:
            THIS-OBJECT:beUserRole:DeleteRoleTypeId(INPUT bttRoleType.RoleTypeId).
        END.
        
        THIS-OBJECT:daRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
        FINALLY:
            DELETE OBJECT THIS-OBJECT:beUserRole NO-ERROR.    
        END FINALLY.
    END METHOD.
    
    
    METHOD PUBLIC VOID CountRoleType(INPUT filter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere    AS CHARACTER NO-UNDO.
        DEFINE VARIABLE iMaxRows  AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER   NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        THIS-OBJECT:daRoleType:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.


    METHOD PUBLIC VOID GetRoleTypeDescription(INPUT ipcRoleTypeId AS CHARACTER, OUTPUT opcDescription AS CHARACTER):
        THIS-OBJECT:daRoleType:GetRoleTypeDescription(INPUT ipcRoleTypeId, OUTPUT opcDescription).
    END METHOD.
    
END CLASS.