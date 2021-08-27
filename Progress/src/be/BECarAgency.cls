USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BECarAgency INHERITS src.BE.BEGeneric: 
    {src/include/dsCarAgency.i}.
    {src/include/dsRentalCompany.i}.
    {src/include/dsTopRentCars.i}.
    {src/include/dsCar.i}
    
    DEFINE PRIVATE VARIABLE daCarAgency         AS src.DA.DACarAgency         NO-UNDO.
    DEFINE PRIVATE VARIABLE beRentalCompany     AS src.BE.BERentalCompany     NO-UNDO.
    DEFINE PRIVATE VARIABLE daGenericValidation AS src.da.DAGenericValidation NO-UNDO.
    DEFINE PRIVATE VARIABLE beCarType           AS src.be.BECarType           NO-UNDO.
    DEFINE PRIVATE VARIABLE beRentCar           AS src.be.BERentCar           NO-UNDO.
    DEFINE PRIVATE VARIABLE beCar               AS src.be.BECar               NO-UNDO.
    
    CONSTRUCTOR PUBLIC BECarAgency ():
        daCarAgency         = NEW src.DA.DACarAgency().
        daGenericValidation = NEW src.da.DAGenericValidation().
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC BECarAgency ():
        DELETE OBJECT daCarAgency         NO-ERROR.
        DELETE OBJECT daGenericValidation NO-ERROR.
    END DESTRUCTOR.
    
    METHOD PUBLIC VOID GetData (OUTPUT DATASET dsCarAgency):
        daCarAgency:fetchGeneric(OUTPUT DATASET dsCarAgency BY-REFERENCE).
    END METHOD.  
     
    METHOD PUBLIC VOID ReadCarAgency(INPUT filter AS CHARACTER , OUTPUT DATASET dsCarAgency):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daCarAgency:ReadGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT DATASET dsCarAgency BY-REFERENCE).
    END METHOD.
    
    METHOD PUBLIC VOID CreateCarAgency(INPUT-OUTPUT DATASET dsCarAgency):
        beRentalCompany = NEW src.BE.BERentalCompany().
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        
        FOR EACH ttCarAgency NO-LOCK:
            daGenericValidation:isEmpty(INPUT ttCarAgency.Address, INPUT "Address", INPUT-OUTPUT cErrorMessage).
            IF NOT beRentalCompany:ExistsWithRentalCompanyId(ttCarAgency.RentalCompanyId) THEN
                cErrorMessage = cErrorMessage + " The rental company is invalid;~n.".        
            IF cErrorMessage <> "" THEN
                UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
        END.             
        daCarAgency:CreateCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).
        
        FINALLY:
                DELETE OBJECT beRentalCompany NO-ERROR.    
        END FINALLY.
    END METHOD.
    
    METHOD PUBLIC VOID UpdateCarAgency(INPUT-OUTPUT DATASET dsCarAgency):
        DEFINE VARIABLE cErrorMessage AS CHARACTER INITIAL "" NO-UNDO.
        FOR EACH ttCarAgency NO-LOCK:
            daGenericValidation:isEmpty(INPUT ttCarAgency.Address, INPUT "Address", INPUT-OUTPUT cErrorMessage).
        END.
        IF cErrorMessage <> "" THEN
            UNDO, THROW NEW Progress.Lang.AppError(cErrorMessage, 100).
         
        daCarAgency:UpdateCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).        
    END METHOD.
    
    
    METHOD PUBLIC VOID DeleteCarAgency (INPUT-OUTPUT DATASET dsCarAgency):
        daCarAgency:DeleteCarAgency(INPUT-OUTPUT DATASET dsCarAgency BY-REFERENCE).   
    END METHOD. 

    METHOD PUBLIC VOID DeleteCarAgencyWithRentalCompany(INPUT ipcRentalCompanyId AS CHARACTER):
        daCarAgency:DeleteCarAgencyWithRentalCompany(INPUT ipcRentalCompanyId).
    END METHOD.
        
    METHOD PUBLIC LOGICAL  ExistsCarAgency(INPUT ipcAgencyId AS CHARACTER ):
        RETURN daCarAgency:ExistsCarAgency(ipcAgencyId).
    END METHOD.
                  
    METHOD PUBLIC VOID CountCarAgency(INPUT filter AS CHARACTER ,OUTPUT numRecs AS INTEGER):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(filter, cWhere, iMaxRows, iSkipRows).
        daCarAgency:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.   
    
    METHOD PRIVATE VOID OutputToFile(INPUT-OUTPUT DATASET dsTopRentCars):
    
        DEFINE VARIABLE iContor     AS INTEGER   NO-UNDO.
        DEFINE VARIABLE cFilename   AS CHARACTER NO-UNDO .
   
        cFilename = SESSION:TEMP-DIRECTORY + "RentsReport.csv".
        
        OUTPUT  TO  VALUE (cFilename).
        EXPORT DELIMITER ";" "Number of rents" "Model" "Manufacturer" "Type".
        
        FOR EACH ttTopRentCars:
            IF iContor < 10 THEN DO:
                EXPORT DELIMITER ";" ttTopRentCars.NrOfRents ttTopRentCars.Model ttTopRentCars.Manufacturer ttTopRentCars.CarType .
                iContor =  1 + iContor.
            END.
            ELSE  DELETE ttTopRentCars .
        END.
        
        OUTPUT CLOSE.
    END METHOD.
    
    METHOD PUBLIC VOID TopRentCars(OUTPUT DATASET dsTopRentCars):
        
        beCarType = NEW src.BE.BECarType().
        beRentCar = NEW src.BE.BERentCar().
        beCar     = NEW src.BE.BECar().
        
        DEFINE VARIABLE iNrOfRents AS INTEGER                  NO-UNDO.
        DEFINE VARIABLE cCarType   AS CHARACTER FORMAT "x(60)" NO-UNDO.
        
        DATASET dsTopRentCars:EMPTY-DATASET ().
        DATASET dsCar        :EMPTY-DATASET ().
        
        beCar:GetData(DATASET dsCar BY-REFERENCE ).
        FOR EACH ttCar NO-LOCK:
             iNrOfRents = beRentCar:GetNumberOfRentsOfACar(ttCar.CarId).
             cCarType   = beCarType:GetDescriptionByCarTypeId(ttCar.CarTypeId).
             CREATE ttTopRentCars.
             ASSIGN ttTopRentCars.NrOfRents = iNrOfRents
                    ttTopRentCars.CarType = cCarType
                    ttTopRentCars.Model = ttCar.Model
                    ttTopRentCars.Manufacturer = ttCar.Manufacturer.
        END.
        OutputToFile(INPUT-OUTPUT  DATASET dsTopRentCars BY-REFERENCE ).
        
        FINALLY:
             DELETE OBJECT beCarType NO-ERROR.
             DELETE OBJECT beRentCar NO-ERROR.
             DELETE OBJECT beCar     NO-ERROR.    
        END FINALLY.

    END METHOD.
END CLASS.

