import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRent } from './rent.model';

export function getRentConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRent(),
    jsdo: {
      name: 'SIRent',
    },
    ds: {
      countFnName: 'count',
    },
  };
}