@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIUserRole", URI="/SIUserRole", schemaName="dsUserRole", schemaFile="BestCars/src/si/SIUserRole.cls").
 
/*------------------------------------------------------------------------
   File        : SIUserRole
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 00:23:15 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SIUserRole: 
    {src/include/dsUserRole.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PRIVATE VARIABLE beUserRole AS src.be.BEUserRole.
    
    CONSTRUCTOR PUBLIC SIUserRole (  ):
        SUPER ().
        THIS-OBJECT:beUserRole = NEW src.be.BEUserRole().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SIUserRole ( ):
        DELETE OBJECT THIS-OBJECT:beUserRole NO-ERROR.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID FetchData( INPUT filter AS CHARACTER, OUTPUT DATASET dsUserRole):
        MESSAGE "FILTER: " filter.
        THIS-OBJECT:beUserRole:FetchData(INPUT filter, OUTPUT DATASET dsUserRole BY-REFERENCE).
        
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beUserRole:CountUserRole(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole):
        THIS-OBJECT:beUserRole:DeleteUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        THIS-OBJECT:beUserRole:CreateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole):
        THIS-OBJECT:beUserRole:UpdateUserRole(INPUT-OUTPUT DATASET dsUserRole BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/IsUserSuperAdmin", alias="", mediaType="application/json").
    METHOD PUBLIC VOID IsUserSuperAdmin(INPUT ipcAppUserId AS CHARACTER, OUTPUT oplIsSuper AS LOGICAL):
    
        THIS-OBJECT:beUserRole:IsUserSuperAdmin(INPUT ipcAppUserId, OUTPUT oplIsSuper).
        
    END METHOD.

END CLASS.