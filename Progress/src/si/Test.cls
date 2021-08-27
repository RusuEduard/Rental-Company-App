@program FILE(name="Test.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="Test", URI="/Test", schemaName="dsTopUsers", schemaFile="BestCars/src/si/Test.cls").




 

USING Progress.Lang.*.
USING src.BE.BECarType.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.Test: 

    {src/include/dsTopUsers.i}
    
    DEFINE VARIABLE beRent AS src.be.beRent NO-UNDO.


    CONSTRUCTOR PUBLIC Test():

        beRent = NEW src.be.beRent().

    END CONSTRUCTOR.


    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID TopUsers(INPUT filter AS CHARACTER , OUTPUT  DATASET dsTopUsers):
        
        beRent:TopUsers(OUTPUT DATASET dsTopUsers BY-REFERENCE ).
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        numRecs = 10.

    END METHOD.
END CLASS.