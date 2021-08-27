 
 /*------------------------------------------------------------------------
    File        : SIRent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : wayfaretraining
    Created     : Tue Aug 03 10:50:12 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

@program FILE(name="SIRentCar.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRentCar", URI="/SIRentCar", schemaName="dsRentCar", schemaFile="").

USING Progress.Lang.*.

USING OpenEdge.BusinessLogic.BusinessEntity.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.SI.SIRentCar:

    {src/include/dsRentCar.i}
    DEFINE VARIABLE BERentCar AS src.BE.BERentCar NO-UNDO.

    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
   ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SIRentCar():

        BERentCar = NEW src.BE.BERentCar().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
   Purpose: Get one or more records, based on a filter string
   Notes:
   ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadRentCar( INPUT filter AS CHARACTER, OUTPUT DATASET dsRentCar):
        DATASET dsRentCar:EMPTY-DATASET().
        MESSAGE "DEBUG SI: Start ReadCustomer".
        BERentCar:ReadRentCar(INPUT filter, OUTPUT DATASET dsRentCar BY-REFERENCE).
        MESSAGE "DEBUG SI: End ReadCustomer".

    END METHOD.

    /*------------------------------------------------------------------------------
   Purpose: Create one or more new records
   Notes:
   ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRentCar(INPUT-OUTPUT DATASET dsRentCar):
        MESSAGE "DEBUG SI: Start CreateCustomer".
        BERentCar:CreateRentCar(INPUT-OUTPUT DATASET dsRentCar BY-REFERENCE).
        MESSAGE "DEBUG SI: End CreateCustomer".
    END METHOD.

    /*------------------------------------------------------------------------------
   Purpose: Update one or more records
   Notes:
   ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRentCar(INPUT-OUTPUT DATASET dsRentCar):
        MESSAGE "DEBUG SI: Start UpdateCustomer".
        BERentCar:UpdateRentCar(INPUT-OUTPUT DATASET dsRentCar BY-REFERENCE).
        MESSAGE "DEBUG SI: End UpdateCustomer".
    END METHOD.

    /*------------------------------------------------------------------------------
   Purpose: Delete a record
   Notes:
   ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRentCar(INPUT-OUTPUT DATASET dsRentCar):
        MESSAGE "DEBUG SI: Start DeleteCustomer".
        BERentCar:DeleteRentCar(INPUT-OUTPUT DATASET dsRentCar BY-REFERENCE).
        MESSAGE "DEBUG SI: End DeleteCustomer".
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        BERentCar:CountRentCar(INPUT filter, OUTPUT numRecs, INPUT dataset dsRentCar).

    END METHOD.

END CLASS.