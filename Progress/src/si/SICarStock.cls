@program FILE(name="SICarStock.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICarStock", URI="/SICarStock", schemaName="dsCarStock", schemaFile="").

 /*------------------------------------------------------------------------
    File        : SICarStock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:23:24 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.
USING src.BE.BECarStock.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.
USING SERVER.src.BE.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SICarStock:

    {src/include/dsCarStock.i}
    
    DEFINE VARIABLE beCarStock AS BECarStock NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SICarStock():

        beCarStock = NEW BECarStock().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadCarStock( INPUT filter AS CHARACTER, OUTPUT DATASET dsCarStock):
        
       DATASET dsCarStock:EMPTY-DATASET (). 
       MESSAGE "DEBUG SI: Start ReadCarStock".  
       beCarStock:ReadCarStock(INPUT filter, OUTPUT DATASET dsCarStock BY-REFERENCE).
       
       MESSAGE "DEBUG SI: End ReadCarStock".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateCarStock(INPUT-OUTPUT DATASET dsCarStock):
         
         MESSAGE "DEBUG SI: Start CreateCarStock".  
         
         beCarStock:CreateCarStock(INPUT-OUTPUT DATASET dsCarStock BY-REFERENCE).
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
    METHOD PUBLIC VOID UpdateCarStock(INPUT-OUTPUT DATASET dsCarStock):
        
        MESSAGE "DEBUG SI: Start UpdateCarStock".  
        
        beCarStock:UpdateCarStock(INPUT-OUTPUT DATASET dsCarStock BY-REFERENCE).
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
    METHOD PUBLIC VOID DeleteCarStock(INPUT-OUTPUT DATASET dsCarStock):
        
        MESSAGE "DEBUG SI: Start DeleteCarStock". 
        
        beCarStock:DeleteCarStock(INPUT-OUTPUT DATASET dsCarStock BY-REFERENCE).
        CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Progress.Lang.AppError(err:GetMessage(1), 100).
        END CATCH.  
        
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        beCarStock:CountCarStock(INPUT filter, OUTPUT numRecs).

    END METHOD.


END CLASS.