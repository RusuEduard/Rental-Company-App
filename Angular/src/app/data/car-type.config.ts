import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCarType } from './car-type.model';

export function getCarTypeConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCarType(),
    jsdo: {
      name: 'SICarType',
    },
    ds: { countFnName: 'count' },
  };
}
