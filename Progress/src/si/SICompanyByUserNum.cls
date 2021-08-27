@program FILE(name="SICompanyByUserNum.cls", module="AppServer").
@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
@progress.service.resource FILE(name="SICompanyByUserNum", URI="/SICompanyByUserNum", schemaName="dsCompanyByUserNum", schemaFile="BestCars/src/si/SICompanyByUserNum.cls").
 
/*------------------------------------------------------------------------
   File        : SICompanyByUserNum
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : wayfaretraining
   Created     : Mon Aug 16 23:51:06 EEST 2021
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.si.SICompanyByUserNum: 
    {src/include/dsCompanyByUserNum.i}

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PRIVATE VARIABLE beCompanyByUserNum AS src.be.BECompanyByUserNum.
    CONSTRUCTOR PUBLIC SICompanyByUserNum (  ):
        SUPER ().
        THIS-OBJECT:beCompanyByUserNum = NEW src.be.BECompanyByUserNum().
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC SICompanyByUserNum ( ):
        DELETE OBJECT THIS-OBJECT:beCompanyByUserNum NO-ERROR.
    END DESTRUCTOR.
    
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="true").
    @progress.service.resourceMapping(type="REST", operation="read", URI="?filter=~{filter~}", alias="", mediaType="application/json").
    @openapi.openedge.method.property (name="mappingType", value="JFP").
    @openapi.openedge.method.property (name="capabilities", value="ablFilter,top,skip,id,orderBy").
    METHOD PUBLIC VOID TopCompaniesByUsers(INPUT filter AS CHARACTER , OUTPUT  DATASET dsCompanyByUserNum):
        
        THIS-OBJECT:beCompanyByUserNum:TopTenCompanies(OUTPUT DATASET dsCompanyByUserNum BY-REFERENCE ).
        
    END METHOD.
    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    @progress.service.resourceMapping(type="REST", operation="invoke", URI="/count?filter=~{filter~}", alias="", mediaType="application/json").
    METHOD PUBLIC VOID count( INPUT filter AS CHARACTER, OUTPUT numRecs AS INTEGER):
        
        numRecs = 10.

    END METHOD.

END CLASS.