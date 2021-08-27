@program FILE(name="SIRentalCompany.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SIRentalCompany", URI="/SIRentalCompany", schemaName="dsRentalCompany", schemaFile="").

 /*------------------------------------------------------------------------
    File        : SIRentalCompany
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

CLASS src.SI.SIRentalCompany:

    {src/include/dsRentalCompany.i}
    
    DEFINE VARIABLE beRentalCompany AS src.BE.BERentalCompany NO-UNDO.

    /*------------------------------------------------------------------------------
    Purpose:
    Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC SIRentalCompany():

        beRentalCompany = NEW src.BE.BERentalCompany().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
    Purpose: Get one or more records, based on a filter string
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID ReadRentalCompany( INPUT filter AS CHARACTER, OUTPUT DATASET dsRentalCompany):
        
       DATASET dsRentalCompany:empty-dataset(). 
       MESSAGE "DEBUG SI: Start ReadRentalCompany".  
       beRentalCompany:ReadRentalCompany(INPUT filter, OUTPUT DATASET dsRentalCompany BY-REFERENCE).
       MESSAGE "DEBUG SI: End ReadRentalCompany".  

    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Create one or more new records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="create", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID CreateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany):
         
         MESSAGE "DEBUG SI: Start CreateRentalCompany".  
         beRentalCompany:CreateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE).         
         MESSAGE "DEBUG SI: End CreateRentalCompany".  
         
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Update one or more records
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="update", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID UpdateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany):
        
        MESSAGE "DEBUG SI: Start UpdateRentalCompany".       
        beRentalCompany:UpdateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE).        
        MESSAGE "DEBUG SI: End UpdateRentalCompany". 
        
    END METHOD.

    /*------------------------------------------------------------------------------
    Purpose: Delete a record
    Notes:
    ------------------------------------------------------------------------------*/
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="delete", URI="", alias="", mediaType="application/json").
    METHOD PUBLIC VOID DeleteRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany):
        
        MESSAGE "DEBUG SI: Start DeleteRentalCompany".         
        beRentalCompany:DeleteRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE).        
        MESSAGE "DEBUG SI: End DeleteRentalCompany".
        
    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):       
        beRentalCompany:CountRentalCompany(INPUT filter, OUTPUT numRecs).
    END METHOD.

END CLASS.
