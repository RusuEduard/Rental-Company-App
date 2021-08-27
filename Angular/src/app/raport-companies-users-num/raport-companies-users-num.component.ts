import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { getCompaniesUsersReportConfig } from '../data/companies-users-report.config';
import { DataProviderCompanyUsersNumReport } from '../data/companies-users-report.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';


@Component({
  selector: 'app-raport-companies-users-num',
  templateUrl: './raport-companies-users-num.component.html',
  styleUrls: ['./raport-companies-users-num.component.css']
})
export class RaportCompaniesUsersNumComponent implements OnInit {


  public state: any = {
    skip: 0,
    take: 10,
    filter: {
      logic: 'and',
      filters: [],
   },
  };

  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  private editedRowIndex: number;
  private originalItem: any;

  constructor (private progressServiceFactory: ProgressServiceFactory) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderCompanyUsersNumReport>(
      getCompaniesUsersReportConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();
  }

 public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });
   
    this.dataService.read(this.state);
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }
  

}

