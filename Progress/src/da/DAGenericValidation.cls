USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.da.DAGenericValidation: 

    METHOD PUBLIC VOID createMessage(INPUT ipcFieldName AS CHARACTER, INPUT-OUTPUT iopcMess AS CHARACTER):
        iopcMess = iopcMess + "The "+ ipcFieldName + " cannot be empty~n.".
    END METHOD.
        
    METHOD PUBLIC LOGICAL isEmpty (INPUT ipcCharacter AS CHARACTER, INPUT ipcFieldName AS CHARACTER, INPUT-OUTPUT opcErrMessage AS CHARACTER):
        IF TRIM(ipcCharacter) = "" OR ipcCharacter = ? THEN
            DO:
                createMessage(ipcFieldName, opcErrMessage).
                RETURN TRUE.
            END.
        ELSE
            RETURN FALSE.
    END METHOD.

    METHOD PUBLIC LOGICAL isEmpty (INPUT ipcNumber AS INTEGER, INPUT ipcFieldName AS CHARACTER, INPUT-OUTPUT opcErrMessage AS CHARACTER):
        IF TRIM( STRING (ipcNumber)) = "" OR ipcNumber = 0 OR ipcNumber = ? THEN
            DO:
                createMessage(ipcFieldName, opcErrMessage).
                RETURN TRUE.
            END.
        ELSE
            RETURN FALSE.
    END METHOD.

    METHOD PUBLIC LOGICAL isEmpty (INPUT ipcDate AS DATE, INPUT ipcFieldName AS CHARACTER, INPUT-OUTPUT opcErrMessage AS CHARACTER):
        IF TRIM( STRING (ipcDate)) = "" OR ipcDate = ? THEN
            DO:
                createMessage(ipcFieldName, opcErrMessage).
                RETURN TRUE.
            END.
        ELSE
            RETURN FALSE.
    END METHOD.    
    
    METHOD PUBLIC LOGICAL isChronological (INPUT ipcDateFrom AS DATE, INPUT ipcDateTo AS DATE, INPUT-OUTPUT opcErrMessage AS CHARACTER):
        IF NOT isEmpty(ipcDateFrom, "Valid From", opcErrMessage) AND NOT isEmpty(ipcDateTo, "Valid To", opcErrMessage) THEN 
            IF ipcDateFrom > ipcDateTo THEN
                DO:
                    opcErrMessage = opcErrMessage + "The start date is after the end date,~n". 
                    RETURN FALSE.
                END.
            ELSE
                RETURN TRUE.                
    END METHOD. 
END CLASS.