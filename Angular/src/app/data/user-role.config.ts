import { ProgressServiceConfig } from './progress-service-config';
import { DataProviderUserRole } from './user-role.model';

export function getUserRoleConfig(): ProgressServiceConfig {
  return {
    dataProviderName: 'smartProvider',
    serverOperations: false,
    createModel: () => new DataProviderUserRole(),
    jsdo: {
      name: 'SIUserRole',
    },
    ds: { countFnName: 'count' },
  };
}
