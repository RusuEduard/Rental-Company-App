import { ProgressServiceConfig } from './progress-service-config';
import { SmartProviderLocation } from './location.model';

export function getLocationConfig(): ProgressServiceConfig {
    return {
        dataProviderName: 'smartProvider',
        serverOperations: false,
        createModel: () => new SmartProviderLocation(),
        jsdo: {
            name: 'LocationServiceInterface',
        },
        ds: {},
    };
}
