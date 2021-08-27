@program FILE(name="SIAppUser.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIAppUser", URI="/SIAppUser", schemaName="dsAppUser", schemaFile="BestCars/src/si/SIAppUser.cls").
 
/*------------------------------------------------------------------------
   File        : SIAppUser
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Tue Aug 03 23:52:58 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SIAppUser:
    {src/include/dsAppUser.i}
    
    DEFINE PRIVATE VARIABLE beAppUser AS src.be.BEAppUser.
    
    CONSTRUCTOR PUBLIC SIAppUser():
        SUPER().
        THIS-OBJECT:beAppUser = NEW src.be.BEAppUser().
    END.
    
    DESTRUCTOR PUBLIC SIAppUser():
        DELETE OBJECT THIS-OBJECT:beAppUser.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadCar( INPUT filter AS CHARACTER, OUTPUT DATASET dsAppUser):

       DATASET dsAppUser:EMPTY-DATASET().
       MESSAGE "DEBUG SI: Start ReadAppUser".
       MESSAGE "filter: " filter.
       beAppUser:FetchData(INPUT filter, OUTPUT DATASET dsAppUser BY-REFERENCE).

       MESSAGE "DEBUG SI: End ReadAppUser".

    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateAppUser(INPUT-OUTPUT DATASET dsAppUser):
        
        THIS-OBJECT:beAppUser:CreateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
        
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser):
    
        THIS-OBJECT:beAppUser:UpdateAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).

        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
            
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteAppUsers(INPUT-OUTPUT DATASET dsAppUser):
    
        THIS-OBJECT:beAppUser:DeleteAppUser(INPUT-OUTPUT DATASET dsAppUser BY-REFERENCE).
        
        CATCH err AS Progress.Lang.Error :
            MESSAGE err:GetMessage(1)
                VIEW-AS ALERT-BOX.
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.
        
    END METHOD.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        THIS-OBJECT:beAppUser:CountAppUsers(INPUT filter, OUTPUT numRecs).

    END METHOD.
    
  

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/GetUserByUsernameAndPassword", alias="", mediaType="application/json").
    METHOD PUBLIC VOID GetUserByUsernameAndPassword( INPUT ipcUserName AS CHARACTER, INPUT ipcPassword AS CHARACTER, OUTPUT DATASET dsAppUser):
        
        DATASET dsAppUser:EMPTY-DATASET(). 
        THIS-OBJECT:beAppUser:GetUserByUsernameAndPassword(INPUT ipcUserName, INPUT ipcPassword, OUTPUT DATASET dsAppUser BY-REFERENCE).
        
    END METHOD.

    
    
END CLASS.