@program FILE(name="SICarAgency.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICarAgency", URI="/SICarAgency", schemaName="dsCarAgency", schemaFile="").

USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.
USING SERVER.src.BE.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SICarAgency:

    {src/include/dsCarAgency.i}
    
    DEFINE VARIABLE beCarAgency AS src.BE.BECarAgency NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SICarAgency():

        beCarAgency = NEW src.BE.BECarAgency().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadCarAgency( INPUT filter AS CHARACTER, OUTPUT DATASET dsCarAgency):
        
       DATASET dsCarAgency:EMPTY-DATASET(). 
       MESSAGE "DEBUG SI: Start ReadCarAgency".  
       beCarAgency:ReadCarAgency(INPUT filter, OUTPUT DATASET dsCarAgency BY-REFERENCE).
       MESSAGE "DEBUG SI: End ReadCarAgency".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateCarAgency(INPUT-OUTPUT DATASET dsCarAgency):
         
         MESSAGE "DEBUG SI: Start CreateCarAgency".  
         beCarAgency:CreateCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).
         MESSAGE "DEBUG SI: End CreateCarAgency".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateCarAgency(INPUT-OUTPUT DATASET dsCarAgency):
        
        MESSAGE "DEBUG SI: Start UpdateCarAgency".  
        beCarAgency:UpdateCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).
        MESSAGE "DEBUG SI: End UpdateCarAgency". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteCarAgency(INPUT-OUTPUT DATASET dsCarAgency):
        
        MESSAGE "DEBUG SI: Start DeleteCarAgency". 
        beCarAgency:DeleteCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).
        MESSAGE "DEBUG SI: End DeleteCarAgency".
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        beCarAgency:CountCarAgency(INPUT filter, OUTPUT numRecs).
    END METHOD.

END CLASS.
