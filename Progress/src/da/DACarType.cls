 
 /*------------------------------------------------------------------------
    File        : DACarType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Aug 02 15:48:00 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING src.DA.DAGeneric.


BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DACarType INHERITS DAGeneric: 
    {src/include/dsCarType.i}

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC DACarType ():
        TempTableName = "ttCarType".
        TableName = "CarType".
    END CONSTRUCTOR.
    

 
   /*
     Creates new car types.
   */  
   METHOD PUBLIC  VOID CreateCarType(INPUT-OUTPUT  DATASET dsCarType):
        DEFINE BUFFER bufCarType FOR CarType.
        
        DO TRANSACTION:
            FOR EACH ttCarType  WHERE ROW-STATE(ttCarType) = ROW-CREATED:
                CREATE bufCarType.
                BUFFER-COPY ttCarType EXCEPT CarTypeId TO bufCarType.
                bufCarType.CarTypeId =  GUID .
            END.
        END.
    END METHOD.
    
    
    /*
      Deletes existing car types
    */
    METHOD PUBLIC VOID DeleteCarType(INPUT-OUTPUT  DATASET dsCarType):
        
        DEFINE BUFFER bufCarType FOR CarType.
        
        MESSAGE "da:delete cartype start".
        DO TRANSACTION:
            FOR EACH bttCarType WHERE ROW-STATE(bttCarType) = ROW-DELETED:
               FIND FIRST bufCarType EXCLUSIVE-LOCK WHERE bufCarType.CarTypeId = bttCarType.CarTypeId NO-ERROR.
               IF AVAILABLE (bufCarType) THEN  DO:  
                    DELETE bufCarType.
               END.
               ELSE  UNDO , THROW NEW Progress.Lang.AppError("Car type not found.", 100).
            END.
        END.
        MESSAGE "da:delete cartype end".
        
    END METHOD.
    
    
    /*
      Updates existing car types
    */
    METHOD PUBLIC VOID UpdateCarType(INPUT-OUTPUT  DATASET dsCarType):
        
        DEFINE BUFFER bufCarType FOR CarType.
        
        DO TRANSACTION:
            FOR EACH ttCarType WHERE ROW-STATE(ttCarType) = ROW-MODIFIED :
                FIND FIRST bufCarType EXCLUSIVE-LOCK WHERE bufCarType.CarTypeId = ttCarType.CarTypeId NO-ERROR.
                IF AVAILABLE (bufCarType ) THEN BUFFER-COPY ttCarType EXCEPT CarTypeId TO  bufCarType.
                ELSE UNDO , THROW NEW Progress.Lang.AppError("Car type not found.", 100).
            END.
        END.
    END METHOD.
    
    
    METHOD PUBLIC VOID FetchAllCarTypes (OUTPUT DATASET dsCarType):
        DEFINE BUFFER bufCarType FOR CarType.
        
        DATASET dsCarType:EMPTY-DATASET ().
        FOR EACH bufCarType NO-LOCK :
            CREATE ttCarType.
            BUFFER-COPY bufCarType TO ttCarType.
        END.
    END METHOD.
    

   
    /*
      Checks if there is another Car type with the given id
    */
    METHOD PUBLIC LOGICAL ExistsWithCarTypeId(INPUT ipcCarTypeId AS CHARACTER):
        
        DEFINE BUFFER bufCarType FOR CarType.
        RETURN CAN-FIND (FIRST bufCarType NO-LOCK WHERE bufCarType.CarTypeId = ipcCarTypeId).
        
    END METHOD.
    
    
    /*
      Checks if there is another Car type with the given description
    */
    METHOD PUBLIC LOGICAL ExistsWithCarTypeDescription(INPUT ipcCarTypeDescription AS CHARACTER):
        
        DEFINE BUFFER bufCarType FOR CarType.
        RETURN CAN-FIND (FIRST bufCarType NO-LOCK WHERE bufCarType.Description = ipcCarTypeDescription).
        
    END METHOD.
    
    
   /*
    Returns the description of the car type that has an id equal to the input parameter
   */
    METHOD PUBLIC CHARACTER GetDescriptionByCarTypeId(INPUT ipcCarTypeId AS CHARACTER):
        DEFINE BUFFER bufCarType FOR CarType.
        
        FOR FIRST bufCarType NO-LOCK 
                WHERE bufCarType.CarTypeId = ipcCarTypeId:
            RETURN bufCarType.Description.
        END.
    END METHOD.
    
    DESTRUCTOR PUBLIC DACarType ( ):

    END DESTRUCTOR.

END CLASS.