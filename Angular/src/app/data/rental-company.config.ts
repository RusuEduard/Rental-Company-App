import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRentalCompany} from './rental-company.model';

export function getRentalCompanyConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRentalCompany(),
    jsdo: {
      name: 'SIRentalCompany',
    },
    ds: {
      countFnName: 'count',
    },
  };
}