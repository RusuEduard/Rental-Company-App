import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCar } from './car.model';

export function getCarConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCar(),
    jsdo: {
      name: 'SICar',
    },
    ds: {
      countFnName: 'count',
    },
  };
}
