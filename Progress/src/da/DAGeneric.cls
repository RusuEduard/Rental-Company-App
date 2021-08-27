 
 /*------------------------------------------------------------------------
    File        : DAGeneric
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Jul 12 08:32:11 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.DA.DAGeneric: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    DEFINE PROTECTED PROPERTY TableName AS CHARACTER NO-UNDO
           PROTECTED GET.
           PROTECTED SET.
           
    
    DEFINE PROTECTED PROPERTY TempTableName AS CHARACTER NO-UNDO
           PROTECTED GET.
           PROTECTED SET.
           
    METHOD PUBLIC VOID FetchGeneric (OUTPUT DATASET-HANDLE dsHandle)   :
        
        
        DEFINE VARIABLE hTable AS HANDLE NO-UNDO .
        DEFINE VARIABLE hTempTable AS HANDLE NO-UNDO .
        DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE hQuery AS HANDLE NO-UNDO .
        
        dsHandle:EMPTY-DATASET ().
        CREATE BUFFER hBuffer FOR TABLE TableName. 
        CREATE BUFFER hTempTable FOR TABLE  dsHandle:GET-BUFFER-HANDLE (TempTableName).
        
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS (hBuffer).
        
        hQuery:QUERY-PREPARE (SUBSTITUTE ("for each &1 no-lock ", TableName )).
        hQuery:QUERY-OPEN ().
        hQuery:GET-FIRST (NO-LOCK ).
        
        REPEAT:
            IF hQuery:QUERY-OFF-END THEN LEAVE.
            hTempTable:BUFFER-CREATE ().
            hTempTable:BUFFER-COPY (hBuffer).
            hQuery:GET-NEXT (NO-LOCK ).
        END.
        
        hQuery:QUERY-CLOSE ().
        
        FINALLY:
            DELETE OBJECT hBuffer NO-ERROR.
            DELETE OBJECT hTempTable NO-ERROR.
            DELETE OBJECT hTable NO-ERROR.
            DELETE OBJECT hQuery NO-ERROR .
        END FINALLY.
    END METHOD.
    
    
    METHOD PUBLIC VOID CountGeneric(INPUT imaxRows AS INTEGER , INPUT irowsToSkip AS INTEGER ,
                                    INPUT cWhere AS CHARACTER , OUTPUT numRecs AS INTEGER):
        
        DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
        DEFINE VARIABLE hQuery AS HANDLE  NO-UNDO.
        CREATE BUFFER hBuffer FOR TABLE  TableName. 
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS (hBuffer).
       
        hQuery:QUERY-PREPARE("preselect each " + TableName + " no-lock  " + cWhere).
        hQuery:QUERY-OPEN ().
        
        numRecs = hQuery:NUM-RESULTS .
        hQuery:QUERY-CLOSE ().
        
         FINALLY:
            DELETE OBJECT hBuffer NO-ERROR.
            DELETE OBJECT hQuery NO-ERROR .
        END FINALLY.    
    END METHOD.
    
    
      
    METHOD PUBLIC VOID ReadGeneric( INPUT imaxRows AS INTEGER ,  INPUT irowsToSkip AS INTEGER , 
                                    INPUT cWhere AS CHARACTER , OUTPUT DATASET-HANDLE  dsHandle ):
                                         
        DEFINE VARIABLE hTable AS HANDLE NO-UNDO .
        DEFINE VARIABLE hTempTable AS HANDLE NO-UNDO .
        DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
        DEFINE VARIABLE hQuery AS HANDLE NO-UNDO .
        DEFINE VARIABLE iContor AS INTEGER NO-UNDO.
        
        dsHandle:EMPTY-DATASET ().
        CREATE BUFFER hBuffer FOR TABLE TableName. 
        CREATE BUFFER hTempTable FOR TABLE  dsHandle:GET-BUFFER-HANDLE (TempTableName).
        
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS (hBuffer).
        
        hQuery:QUERY-PREPARE (SUBSTITUTE ("for each &1 &2 ", TableName, cWhere  )).
        hQuery:QUERY-OPEN ().
        hQuery:REPOSITION-TO-ROW (irowsToSkip + 1).
        hQuery:GET-NEXT  (NO-LOCK ).
        REPEAT:
            IF hQuery:QUERY-OFF-END THEN LEAVE.
            hTempTable:BUFFER-CREATE ().
            hTempTable:BUFFER-COPY (hBuffer).
            hQuery:GET-NEXT (NO-LOCK ).
            iContor  = 1 + iContor.
            IF iContor = imaxRows  THEN LEAVE.
        END.
        
        hQuery:QUERY-CLOSE ().
        
        FINALLY:
            DELETE OBJECT hBuffer NO-ERROR.
            DELETE OBJECT hTempTable NO-ERROR.
            DELETE OBJECT hTable NO-ERROR.
            DELETE OBJECT hQuery NO-ERROR .
        END FINALLY.
       
    END METHOD .
    
    
    CONSTRUCTOR PUBLIC DAGeneric (  ):
        SUPER ().
        
    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC DAGeneric ( ):

    END DESTRUCTOR.

END CLASS.