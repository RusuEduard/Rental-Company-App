import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getUsersReportConfig } from '../data/users-report.config';
import { DataProviderUsersReport } from '../data/users-report.model';

@Component({
  selector: 'app-users-report',
  templateUrl: './users-report.component.html',
  styleUrls: ['./users-report.component.css']
})
export class UsersReportComponent implements OnInit {
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
  constructor(private progressServiceFactory: ProgressServiceFactory) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderUsersReport>(
      getUsersReportConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();
   }

  ngOnInit(): void {
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
