import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderCompanyUsersNumReport } from './companies-users-report.model';

export function getCompaniesUsersReportConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: true,
    createModel: () => new DataProviderCompanyUsersNumReport(),
    jsdo: {
      name: 'SICompanyByUserNum',
    },
    ds: { countFnName: 'count' },
  };
}
