@program FILE(name="SICarType.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICarType", URI="/SICarType", schemaName="dsCarType", schemaFile="BestCars/src/si/SICarType.cls").

 /*------------------------------------------------------------------------
    File        : SICarType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:20:27 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.
USING src.BE.BECarType.


BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SICarType:

    {src/include/dsCarType.i}
    {src/include/dsCarTypeShort.i}
    
    DEFINE VARIABLE beCarType AS BECarType NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SICarType():

        beCarType = NEW BECarType().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadCarType( INPUT filter AS CHARACTER, OUTPUT DATASET dsCarType):
        
       DATASET dsCarType:EMPTY-DATASET (). 
       MESSAGE "DEBUG SI: Start ReadCarType".  
       beCarType:ReadCarType(INPUT filter, OUTPUT DATASET dsCarType BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadCarType".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateCarType(INPUT-OUTPUT DATASET dsCarType):
         
         MESSAGE "DEBUG SI: Start CreateCarType".  
         
         beCarType:CreateCarType(INPUT-OUTPUT DATASET dsCarType BY-REFERENCE).
         CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
         END CATCH.  
         
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateCarType(INPUT-OUTPUT DATASET dsCarType):
        
        MESSAGE "DEBUG SI: Start UpdateCarType".  
        
        beCarType:UpdateCarType(INPUT-OUTPUT DATASET dsCarType BY-REFERENCE).
        CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.  
        
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteCarType(INPUT-OUTPUT DATASET dsCarType):
        
        MESSAGE "DEBUG SI: Start DeleteCarType". 
        
        beCarType:DeleteCarType(INPUT-OUTPUT DATASET dsCarType BY-REFERENCE).
        CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.  
        
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beCarType:CountCarType(INPUT filter, OUTPUT numRecs).

    END METHOD.
   
   
   


END CLASS.