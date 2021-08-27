import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCarTypeReport } from './car-type-report.model';

export function getCarTypeReportConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCarTypeReport(),
    jsdo: {
      name: 'SICarTypeReport',
    },
    ds: { countFnName: 'count' },
  };
}
