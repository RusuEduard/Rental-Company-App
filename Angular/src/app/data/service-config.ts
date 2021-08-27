import { Injectable } from '@angular/core';

@Injectable()
export class AppConfigService {
  static settings: IAppConfigSettings = {
    dataProviders: {
      smartProvider: {
        serviceUri: 'http://localhost:8810/BestCars',
        catalogUris: [
          'http://localhost:8810/BestCars/static/BestCarsService.json',
        ],
        authenticationModel: 'Anonymous',
      },
    },
  } as IAppConfigSettings;
}

export interface IAppConfigSettings {
  dataProviders: any;
  authentication: any;
}

export const environmentBase: any = {
  getDataProviders(): any {
    return AppConfigService.settings.dataProviders;
  },
  getAuthentication(): any {
    return AppConfigService.settings.authentication;
  },
};

export class DataServiceConfig {
  public dataProviderName: string;
  public serverOperations = false;
  public createModel: () => any;
  public mapData?: (dataItem: any) => any;
}

@Injectable()
export class DataProviderService {
  public get(providerName: string): any {
    const dataProviders: any = environmentBase.getDataProviders();
    return dataProviders[providerName];
  }
}

export class DataServiceRequest {
  url: string;
  routeParams?: { [param: string]: any };
  queryString?: string;
}
