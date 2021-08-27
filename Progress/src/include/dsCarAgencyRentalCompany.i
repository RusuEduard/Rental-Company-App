{include/ttCarAgency.i}
{include/ttRentalCompany.i}

DEFINE DATASET dsCarAgencyRentalCompany FOR ttCarAgency,ttRentalCompany
    DATA-RELATION drCarAgencyRentalCompany FOR ttCarAgency, ttRentalCompany
        RELATION-FIELDS(RentalCompanyId, RentalCompanyId).
        
   
