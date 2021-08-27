import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRentCar } from './rent-car.model';

export function getRentCarConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRentCar(),
    jsdo: {
      name: 'SIRentCar',
    },
    ds: {
      countFnName: 'count',
    },
  };
}