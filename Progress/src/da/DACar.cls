 
 /*------------------------------------------------------------------------
    File        : DACar
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:00:00 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.DA.DAGeneric.


BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DACar INHERITS DAGeneric: 
    {src/include/dsCar.i}

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DACar ():
        TempTableName = "ttCar".
        TableName = "Car".
    END CONSTRUCTOR.
    

 
 
   /*
    Creates new cars (each one will get a  unique id )
   */  
   METHOD PUBLIC  VOID CreateCar(INPUT-OUTPUT DATASET dsCar):
        DEFINE BUFFER bufCar FOR Car.
        DO TRANSACTION:
            FOR EACH ttCar WHERE ROW-STATE(ttCar) = ROW-CREATED :
                CREATE bufCar.
                BUFFER-COPY ttCar  EXCEPT CarId TO bufCar.
                bufCar.CarId =  GUID.
            END.
        END.
    END METHOD.
    
    
    /*
    Returns the number of cars that have a given type
    */
    METHOD PUBLIC INTEGER GetNumberOfCarsWithType(INPUT ipcCarType AS CHARACTER ):
        
        DEFINE BUFFER bufCar FOR Car.
        
        DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
        FOR EACH bufCar NO-LOCK WHERE bufCar.CarTypeId = ipcCarType:
            iCounter = 1 + iCounter.
            
        END.
        RETURN iCounter.
    END METHOD.
    
    
    
    /*
      Deletes existing cars
    */
    METHOD PUBLIC VOID DeleteCar(INPUT-OUTPUT  DATASET dsCar):
        
        DEFINE BUFFER bufCar FOR Car.
        
        MESSAGE "da:delete car start".
        DO TRANSACTION:
            FOR EACH bttCar WHERE ROW-STATE(bttCar) = ROW-DELETED:
                FIND  FIRST bufCar EXCLUSIVE-LOCK WHERE bufCar.CarId = bttCar.CarId NO-ERROR.
                IF AVAILABLE (bufCar) THEN  
                    DELETE bufCar.
                ELSE UNDO, THROW NEW Progress.Lang.AppError ("Car not found. ", 100).
            END.
        END.
        MESSAGE "da:delete car end".
        
    END METHOD.
    

    
    /*
      Checks if there is another car with the given CarId
    */
    METHOD PUBLIC LOGICAL ExistsWithCarId(INPUT ipcCarId AS CHARACTER):
        
        DEFINE BUFFER bufCar FOR Car.
        RETURN CAN-FIND (FIRST bufCar NO-LOCK WHERE bufCar.CarId = ipcCarId).
        
    END METHOD.
    
    
    /*
      Checks if there is another car with the given model, manufacturer and car type id
    */
    METHOD PUBLIC LOGICAL ExistsWithModelAndManufacturer(INPUT ipcModel AS CHARACTER, 
                          INPUT ipcManufacturer AS CHARACTER, INPUT ipcCarTypeId AS CHARACTER):
        
      DEFINE BUFFER bufCar FOR Car.
      RETURN CAN-FIND (FIRST bufCar NO-LOCK WHERE bufCar.Model = ipcModel AND 
                        bufCar.Manufacturer = ipcManufacturer AND  bufCar.CarTypeId = ipcCarTypeId).
        
    END METHOD.
    
    
    
    /*
      Deletes all the cars that have a given type
    */
    METHOD PUBLIC VOID EmptyCarsWithType(INPUT ipcCarTypeId AS CHARACTER  ):
        DEFINE BUFFER bufCar FOR Car.
        
        MESSAGE "empty(da) car start".
        FOR EACH bufCar EXCLUSIVE-LOCK WHERE bufCar.CarTypeId = ipcCarTypeId:
            DELETE bufCar.
        END.
        MESSAGE "empty(da) car end".
        
    END METHOD .
    

    
    /*
     Updates existing cars
    */
    METHOD PUBLIC VOID UpdateCar(INPUT-OUTPUT  DATASET dsCar):
        
        DEFINE BUFFER bufCar FOR Car.
        
        DO TRANSACTION:
            FOR EACH ttCar WHERE ROW-STATE(ttCar) = ROW-MODIFIED    :
                FIND  FIRST bufCar EXCLUSIVE-LOCK WHERE bufCar.CarId = ttCar.CarId  NO-ERROR.
                IF AVAILABLE (bufCar) THEN  BUFFER-COPY ttCar EXCEPT CarId TO  bufCar.
                ELSE UNDO , THROW NEW Progress.Lang.AppError("Car not found. ", 100).
            END.
        END.
    END METHOD.
    
    
    
    METHOD PUBLIC VOID FetchAllCars (OUTPUT DATASET dsCar):
        DEFINE BUFFER bufCar FOR Car.
        
        DATASET dsCar:EMPTY-DATASET ().
        FOR EACH bufCar NO-LOCK :
            CREATE ttCar.
            BUFFER-COPY bufCar TO ttCar.
        END.
    END METHOD.
    
    
    /*
      Fills the dataset with all the cars that have a given type
    */
    METHOD PUBLIC VOID FetchCarsWithType (INPUT ipcCarType AS CHARACTER , OUTPUT DATASET dsCar):
        
        DEFINE BUFFER bufCar FOR Car.
        
        DATASET dsCar:EMPTY-DATASET ().
        FOR EACH bufCar NO-LOCK WHERE bufCar.CarTypeId = ipcCarType :
            CREATE ttCar.
            BUFFER-COPY bufCar TO ttCar.
        END.
    END METHOD.

   
    DESTRUCTOR PUBLIC DACar ( ):

    END DESTRUCTOR.

END CLASS.