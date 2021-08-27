import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCarAgency} from './car-agency.model';

export function getCarAgencyConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCarAgency(),
    jsdo: {
      name: 'SICarAgency',
    },
    ds: {
      countFnName: 'count',
    },
  };
}