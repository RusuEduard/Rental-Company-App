import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCarStock} from './car-stock.model';

export function getCarStockConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCarStock(),
    jsdo: {
      name: 'SICarStock',
    },
    ds: {
      countFnName: 'count',
    },
  };
}