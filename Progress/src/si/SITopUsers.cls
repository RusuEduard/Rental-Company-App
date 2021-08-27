@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SITopUsers", URI="/SITopUsers", schemaName="dsTopUsers", schemaFile="BestCars/src/si/SITopUsers.cls").

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SITopUsers: 
{src/include/dsTopUsers.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE beRent AS src.be.beRent NO-UNDO.
    
    
    CONSTRUCTOR PUBLIC SITopUsers (  ):
        SUPER ().
        
    END CONSTRUCTOR.
     @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
     @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
     METHOD PUBLIC VOID TopUsers(INPUT filter AS CHARACTER , OUTPUT DATASET dsTopUsers):
        beRent = NEW src.be.beRent().
        beRent:TopUsers(OUTPUT DATASET dsTopUsers BY-REFERENCE ).
         FOR EACH ttTopUsers:
            MESSAGE ttTopUsers.Name.
        END.
        FINALLY:
            DELETE OBJECT beRent NO-ERROR.
        END FINALLY.
    END METHOD.
     @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
     @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count", alias="", mediaType="application/json").
     METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        numRecs = 10.

    END METHOD.
    DESTRUCTOR PUBLIC SITopUsers ( ):

    END DESTRUCTOR.

END CLASS.