import { Component, Input, OnInit } from '@angular/core';
import { DataStateChangeEvent } from '@progress/kendo-angular-grid';
import { getCarTypeReportConfig } from '../data/car-type-report.config';
import { DataProviderCarTypeReport } from '../data/car-type-report.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';

@Component({
  selector: 'app-car-type-report',
  templateUrl: './car-type-report.component.html',
  styleUrls: ['./car-type-report.component.css']
})
export class CarTypeReportComponent implements OnInit {


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
    this.progressServiceFactory.getService<DataProviderCarTypeReport>(
      getCarTypeReportConfig(),
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
