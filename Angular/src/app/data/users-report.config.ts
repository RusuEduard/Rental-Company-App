import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderUsersReport } from './users-report.model';

export function getUsersReportConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: false,
    createModel: () => new DataProviderUsersReport(),
    jsdo: {
      name: 'Test',
    },
    ds: { countFnName: 'count' },
  };
}
