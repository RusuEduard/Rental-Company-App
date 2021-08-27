@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRoleType", URI="/SIRoleType", schemaName="dsRoleType", schemaFile="").
 
/*------------------------------------------------------------------------
   File        : SIRoleType
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Wed Aug 04 00:12:47 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SIRoleType:
    {src/include/dsRoleType.i} 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PRIVATE VARIABLE beRoleType AS src.be.BERoleType.
    
    CONSTRUCTOR PUBLIC SIRoleType (  ):
        SUPER ().
        THIS-OBJECT:beRoleType = NEW src.be.BERoleType().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SIRoleType ( ):
        DELETE OBJECT THIS-OBJECT:beRoleType NO-ERROR.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID FetchData( INPUT filter AS CHARACTER, OUTPUT DATASET dsRoleType):
        THIS-OBJECT:beRoleType:FetchData(INPUT filter, OUTPUT DATASET dsRoleType BY-REFERENCE).
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        THIS-OBJECT:beRoleType:CreateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType):
        THIS-OBJECT:beRoleType:UpdateRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
            
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType):
        THIS-OBJECT:beRoleType:DeleteRoleType(INPUT-OUTPUT DATASET dsRoleType BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        THIS-OBJECT:beRoleType:CountRoleType(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
END CLASS.