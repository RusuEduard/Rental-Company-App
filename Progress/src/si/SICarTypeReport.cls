@program FILE(name="SICarTypeReport.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICarTypeReport", URI="/SICarTypeReport", schemaName="dsCarTypeShort", schemaFile="BestCars/src/si/SICarTypeReport.cls").
 
 /*------------------------------------------------------------------------
    File        : SICarTypeReport
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Mon Aug 09 15:25:42 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BECarType.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SICarTypeReport: 

    {src/include/dsCarType.i}
    {src/include/dsCarTypeShort.i}
    
    DEFINE VARIABLE beCarType AS BECarType NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SICarTypeReport():

        beCarType = NEW BECarType().

    END CONSTRUCTOR.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID TopCarType(INPUT filter AS CHARACTER , OUTPUT  DATASET dsCarTypeShort):
        
        beCarType:TopCarTypes(OUTPUT DATASET dsCarTypeShort BY-REFERENCE ).
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        numRecs = 10.

    END METHOD.
END CLASS.