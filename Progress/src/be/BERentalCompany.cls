USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BERentalCompany INHERITS src.BE.BEGeneric: 
    {src/include/dsRentalCompany.i}.
    
    DEFINE PRIVATE VARIABLE daRentalCompany     AS src.DA.DARentalCompany       NO-UNDO.
    DEFINE PRIVATE VARIABLE daGenericValidation AS src.da.DAGenericValidation   NO-UNDO.
    
    
    CONSTRUCTOR PUBLIC BERentalCompany ():
        daRentalCompany     = NEW src.DA.DARentalCompany().
        daGenericValidation = NEW src.da.DAGenericValidation().        
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC BERentalCompany ():
        DELETE OBJECT daRentalCompany       NO-ERROR.
        DELETE OBJECT daGenericValidation   NO-ERROR.        
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID GetData (OUTPUT DATASET dsRentalCompany):
        daRentalCompany:fetchGeneric(OUTPUT DATASET dsRentalCompany BY-REFERENCE).
    END METHOD.

    METHOD PUBLIC VOID ReadRentalCompany(INPUT filter AS CHARACTER , OUTPUT DATASET dsRentalCompany):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daRentalCompany:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsRentalCompany BY-REFERENCE).
    END METHOD.
        
    METHOD PUBLIC VOID CreateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany):
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
        FOR EACH ttRentalCompany NO-LOCK:           
            daGenericValidation:isEmpty(INPUT ttRentalCompany.Description, INPUT "Description", INPUT-OUTPUT cErrorMessage).
            
            IF ExistsWithSameDescription(INPUT ttRentalCompany.Description) THEN
                cErrorMessage = cErrorMessage + "There is another rental company with this description~n".   
            IF cErrorMessage <> "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.
                 
        daRentalCompany:CreateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE).
    END METHOD.
    
    METHOD PUBLIC VOID UpdateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany):
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
        FOR EACH ttRentalCompany NO-LOCK:
            daGenericValidation:isEmpty(INPUT ttRentalCompany.Description, INPUT "Description", INPUT-OUTPUT cErrorMessage).
            IF ExistsWithSameDescription(INPUT ttRentalCompany.Description) THEN
                cErrorMessage = cErrorMessage + "There is another rental company with this description~n".
            IF cErrorMessage <> "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.   
              
        daRentalCompany:UpdateRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE).        
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteRentalCompany (INPUT-OUTPUT DATASET dsRentalCompany):
        daRentalCompany:DeleteRentalCompany(INPUT-OUTPUT DATASET dsRentalCompany BY-REFERENCE ). 
    END METHOD. 
      
    METHOD PUBLIC VOID CountRentalCompany(INPUT filter AS CHARACTER ,OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daRentalCompany:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD. 
    
    METHOD PUBLIC LOGICAL ExistsWithRentalCompanyId(INPUT ipcRentalCompanyId AS CHARACTER):
        RETURN daRentalCompany:ExistsWithRentalCompanyId(INPUT ipcRentalCompanyId). 
    END METHOD.    
    
    METHOD PUBLIC LOGICAL ExistsWithSameDescription(INPUT ipcDescription AS CHARACTER):
        RETURN daRentalCompany:ExistsWithSameDescription(INPUT ipcDescription). 
    END METHOD.         
END CLASS.

