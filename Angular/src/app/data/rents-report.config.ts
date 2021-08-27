import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderRentsReport } from './rents-report.model';
 
export function getRentsReportConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderRentsReport(),
    jsdo: {
      name: 'SITopRentCarsReport',
    },
    ds: { countFnName: 'count' },
  };
}
