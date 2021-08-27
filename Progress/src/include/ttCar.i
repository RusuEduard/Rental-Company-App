
/*------------------------------------------------------------------------
    File        : ttCar.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:04:48 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttCar NO-UNDO 
       BEFORE-TABLE bttCar
       FIELD CarId AS CHARACTER FORMAT "x(36)"
       FIELD CarTypeId AS CHARACTER  FORMAT "x(36)"
       FIELD Manufacturer AS CHARACTER FORMAT "x(60)"
       FIELD Model AS CHARACTER FORMAT "x(60)"
       INDEX pkCar IS PRIMARY UNIQUE CarId.
