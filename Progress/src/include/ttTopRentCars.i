DEFINE TEMP-TABLE ttTopRentCars NO-UNDO
       FIELD Model AS CHARACTER FORMAT "x(60)"
       FIELD Manufacturer AS CHARACTER FORMAT "x(60)"
       FIELD CarType AS CHARACTER FORMAT "x(60)"
       FIELD NrOfRents AS INTEGER
        
       INDEX idxNrOfRents NrOfRents DESCENDING.