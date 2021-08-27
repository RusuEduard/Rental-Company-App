@program FILE(name="SICar.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICar", URI="/SICar", schemaName="dsCar", schemaFile="").

 /*------------------------------------------------------------------------
    File        : SICar
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:22:57 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.
USING SERVER.src.BE.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SICar:

    {src/include/dsCar.i}
    
    DEFINE VARIABLE beCar AS src.BE.BECar NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SICar():

        beCar = NEW src.BE.BECar().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadCar( INPUT filter AS CHARACTER, OUTPUT DATASET dsCar):
        
       DATASET dsCar:EMPTY-DATASET (). 
       MESSAGE "DEBUG SI: Start ReadCar".  
       beCar:ReadCar(INPUT filter, OUTPUT DATASET dsCar BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadCar".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateCar(INPUT-OUTPUT DATASET dsCar):
         
         MESSAGE "DEBUG SI: Start CreateCar".  
         
         beCar:CreateCar(INPUT-OUTPUT DATASET dsCar BY-REFERENCE).
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
    METHOD PUBLIC VOID UpdateCar(INPUT-OUTPUT DATASET dsCar):
        
        MESSAGE "DEBUG SI: Start UpdateCar".  
        
        beCar:UpdateCar(INPUT-OUTPUT DATASET dsCar BY-REFERENCE).
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
    METHOD PUBLIC VOID DeleteCar(INPUT-OUTPUT DATASET dsCar):
        
        MESSAGE "DEBUG SI: Start DeleteCar". 
        
        beCar:DeleteCar(INPUT-OUTPUT DATASET dsCar BY-REFERENCE).
        CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.        
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beCar:CountCar(INPUT filter, OUTPUT numRecs).

    END METHOD.


END CLASS.