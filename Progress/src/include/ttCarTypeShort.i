
/*------------------------------------------------------------------------
    File        : ttCarTypeShort.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : cristinahendre
    Created     : Sun Aug 08 20:39:18 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttCarTypeShort NO-UNDO 
       FIELD NumberOfCars AS INTEGER     
       FIELD Description  AS CHARACTER FORMAT "x(60)" 
       INDEX idxNumberOfCars NumberOfCars  DESCENDING.
