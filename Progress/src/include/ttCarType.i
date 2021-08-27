
/*------------------------------------------------------------------------
    File        : ttCarType.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : cristinahendre
    Created     : Mon Aug 02 15:56:21 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttCarType NO-UNDO 
       BEFORE-TABLE bttCarType
       FIELD CarTypeId AS CHARACTER  FORMAT "x(36)" SERIALIZE-NAME "CarTypeId"
       FIELD Description    AS CHARACTER FORMAT "x(60)" 
       INDEX pkCarType IS PRIMARY UNIQUE CarTypeId.
       
