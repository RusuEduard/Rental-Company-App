 
 /*------------------------------------------------------------------------
    File        : BECarType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:12:14 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.BE.BeGeneric.
USING src.Da.DaCarType.
USING src.BE.BECar.
USING src.DA.DaGenericValidation.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BECarType INHERITS BEGeneric: 

    {src/include/dsCarType.i}
    {src/include/dsCar.i}
    {src/include/dsCarTypeShort.i}
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PRIVATE VARIABLE daCarType AS DACarType NO-UNDO .
    DEFINE PRIVATE VARIABLE beCar AS BECar NO-UNDO .
    DEFINE PRIVATE VARIABLE daGenericValidation AS DAGenericValidation NO-UNDO.
    
    
    
    
    CONSTRUCTOR PUBLIC BECarType (  ):
        daCarType = NEW DACarType () .
        daGenericValidation = NEW DAGenericValidation().        
        
    END CONSTRUCTOR.
    
    
    /*
      Fetches the data, after applying a specific filter.
    */
    METHOD PUBLIC VOID ReadCarType(INPUT pcfilter AS CHARACTER , OUTPUT DATASET  dsCarType ):
                                         
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(pcfilter, cWhere, iMaxRows, iSkipRows).
        daCarType:ReadGeneric( INPUT iMaxRows, INPUT iSkipRows ,
                                     INPUT cWhere  , OUTPUT  DATASET  dsCarType BY-REFERENCE ).
    END METHOD.


    /*
      Creates new car types
    */
    METHOD PUBLIC VOID CreateCarType (INPUT-OUTPUT  DATASET dsCarType):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        
        FOR EACH ttCarType :

            daGenericValidation:isEmpty(INPUT ttCarType.Description, INPUT "Description", INPUT-OUTPUT cErrorMessages).

            //checks if there is another car type with this description
            IF ExistsWithCarTypeDescription(ttCarType.Description) THEN 
              cErrorMessages = cErrorMessages + " There is another car type with this description; ".
              
            IF cErrorMessages <> "" THEN DO:
              UNDO , THROW NEW Progress.Lang.AppError(cErrorMessages, 100).
            END.  
        END.
      
        daCarType:CreateCarType(INPUT-OUTPUT  DATASET dsCarType BY-REFERENCE ). 
    END METHOD.
    
    
    
    /*
       Updates existing car types
    */
    METHOD PUBLIC VOID UpdateCarType(INPUT-OUTPUT  DATASET dsCarType):
        DEFINE VARIABLE cErrorMessages AS CHARACTER INITIAL "" NO-UNDO.
        MESSAGE "[be]update car type start".
        FOR EACH ttCarType :
               
            daGenericValidation:isEmpty(INPUT ttCarTYpe.Description, INPUT "Description", INPUT-OUTPUT cErrorMessages).

            //checks if there is another car type with this description
            IF ExistsWithCarTypeDescription(ttCarType.Description) THEN 
              cErrorMessages = cErrorMessages + " There is another car type with this description; ".
              
            IF cErrorMessages <> "" THEN DO:
              UNDO , THROW NEW Progress.Lang.AppError(cErrorMessages, 100).
            END.   
        END.
       
        daCarType:UpdateCarType(INPUT-OUTPUT  DATASET dsCarType BY-REFERENCE ). 
        MESSAGE "[be]update car type end".
        
    END METHOD.
    
    
    /*
      Deletes existing car types (and all the cars that have this type)
    */
    METHOD PUBLIC VOID DeleteCarType(INPUT-OUTPUT  DATASET dsCarType):
       beCar = NEW BECar().
       MESSAGE "be delete car -start".
       DO TRANSACTION :
           FOR EACH bttCarType  WHERE ROW-STATE(bttCarType) = ROW-DELETED :
              beCar:EmptyCarsWithType(bttCarType.CarTypeId).
              
           END.       
           daCarType:DeleteCarType(INPUT-OUTPUT  DATASET dsCarType BY-REFERENCE ). 
       END.
       MESSAGE "be delete car -end".
       FINALLY:
           DELETE OBJECT beCar NO-ERROR.    
       END FINALLY.
       
    END METHOD.
    
    
    /*
     Returns the number of rows that fulfill  a criteria
    */
    METHOD PUBLIC VOID CountCarType(INPUT ipcfilter AS CHARACTER , OUTPUT numRecs AS INTEGER ):
        DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE iMaxRows AS INTEGER NO-UNDO.
        DEFINE VARIABLE iSkipRows AS INTEGER NO-UNDO.
        ExtractABLFilter(ipcfilter, cWhere, iMaxRows, iSkipRows).
        daCarType:CountGeneric(INPUT iMaxRows, INPUT iSkipRows, INPUT cWhere, OUTPUT numRecs).
    END METHOD.
    
    
 
    
    
    /*
      Checks if there is another Car type with the given CarTypeId
    */
    METHOD PUBLIC LOGICAL ExistsWithCarTypeId(INPUT ipcCarTypeId AS CHARACTER):
        
        RETURN daCarType:ExistsWithCarTypeId(ipcCarTypeId).
        
    END METHOD.
    
    
    /*
      Checks if there is another Car type with the given Description
    */
    METHOD PUBLIC LOGICAL ExistsWithCarTypeDescription(INPUT ipcCarTypeDescription AS CHARACTER):
        
        RETURN daCarType:ExistsWithCarTypeDescription(ipcCarTypeDescription).
        
    END METHOD.
    
    
    /*
      Finds top 10 car types.
      The idea is:
          -take all the existing car types, find the number of cars for each type
          -store the number of cars and description for each car type in a temp-table
          
    */
    METHOD PUBLIC VOID TopCarTypes(OUTPUT  DATASET dsCarTypeShort):
        beCar = NEW BECar().
        DEFINE VARIABLE iNoOfCars AS INTEGER NO-UNDO.
        DATASET dsCarTypeShort:EMPTY-DATASET ().
        daCarType:FetchAllCarTypes(DATASET dsCarType BY-REFERENCE ).
        FOR EACH ttCarType NO-LOCK:
            
             iNoOfCars = beCar:GetNumberOfCarsWithType(ttCarType.CarTypeId).
             CREATE ttCarTypeShort.
             ASSIGN ttCarTypeShort.NumberOfCars = iNoOfCars
                    ttCarTypeShort.Description = ttCarType.Description.
           
        END.
        OutputToFile(INPUT-OUTPUT  DATASET dsCarTypeShort BY-REFERENCE ).
        
        FINALLY:
             DELETE OBJECT beCar NO-ERROR.    
        END FINALLY.

    END METHOD.
    
    
    /*
      Outputs the content of temp-table into a csv file
    */
    METHOD PRIVATE VOID OutputToFile(INPUT-OUTPUT  DATASET dsCarTypeShort):
        
        DEFINE VARIABLE iContor AS INTEGER NO-UNDO.
        DEFINE  VARIABLE  cFilename AS  CHARACTER  NO-UNDO .
        
        cFilename = SESSION:TEMP-DIRECTORY + "CarType.csv".
        LOG-MANAGER :WRITE-MESSAGE (cFilename). 
   
        OUTPUT  TO  VALUE (cFilename).
        EXPORT DELIMITER ";" "Number of cars" "Name".
        
        FOR EACH ttCarTypeShort BY ttCarTypeShort.NumberOfCars DESCENDING:
            
            IF iContor < 10 THEN DO:
                EXPORT DELIMITER ";" ttCarTypeShort.NumberOfCars ttCarTypeShort.Description.
                iContor =  1 + iContor.
            END.
            ELSE  DELETE ttCarTypeShort .
            
        END.
        OUTPUT CLOSE.
    END METHOD.
    
    METHOD PUBLIC CHARACTER GetDescriptionByCarTypeId(INPUT ipcCarTypeId AS CHARACTER):
        RETURN daCarType:GetDescriptionByCarTypeId(INPUT ipcCarTypeId).
    END METHOD.    
    
    DESTRUCTOR PUBLIC BECarType ( ):
        DELETE OBJECT daCarType  NO-ERROR.
    END DESTRUCTOR.

END CLASS.