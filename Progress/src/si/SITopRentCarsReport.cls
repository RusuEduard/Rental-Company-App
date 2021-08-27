@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SITopRentCarsReport", URI="/SITopRentCarsReport", schemaName="dsTopRentCars", schemaFile="").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SITopRentCarsReport: 

    {src/include/dsTopRentCars.i}
    
    DEFINE VARIABLE beCarAgency AS src.be.beCarAgency NO-UNDO.

    CONSTRUCTOR PUBLIC SITopRentCarsReport():
        beCarAgency = NEW src.be.beCarAgency().
    END CONSTRUCTOR.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID TopCarType(INPUT filter AS CHARACTER , OUTPUT  DATASET dsTopRentCars):
        beCarAgency:TopRentCars(OUTPUT DATASET dsTopRentCars BY-REFERENCE ).
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        numRecs = 10.
    END METHOD.
    
END CLASS.