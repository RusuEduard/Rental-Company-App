import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent, GridDataResult } from '@progress/kendo-angular-grid';
import { ToastrService } from 'ngx-toastr';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getRentalCompanyConfig } from '../data/rental-company.config';
import { DataProviderRentalCompany } from '../data/rental-company.model';

@Component({
  selector: 'app-rental-company',
  templateUrl: './rental-company.component.html',
  styleUrls: ['./rental-company.component.css']
})
export class RentalCompanyComponent implements OnInit {

  public grid:GridDataResult;

  public currentRentalCompany: string = "";
  public mySelection:any[] = [0];
  public state: any = {
    skip: 0,
    take: 10,
    filter: {
      logic: 'and',
      filters: [],
    },
  };

  public state2: any = {
    skip: 0,
    take: 100,
  };

  public editDataItem: DataProviderRentalCompany;
  public isNew: boolean;
  public dataService;
  public stateDataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderRentalCompany>(
        getRentalCompanyConfig(),
        this.state
      );

    this.dataService.errors.subscribe((error) => {
        if(error && error['error']){
          this.toastr.error(error['error'].message);
        }
      });
    this.view = this.dataService.dataChanges();
  }

  public ngOnInit(): void {
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
      if (data !== null) {
          this.currentRentalCompany = data['data'][0]?.RentalCompanyId;
      }
    });
    this.dataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
    this.mySelection[0] = this.state.skip;
  }

  public addHandler() {
    this.editDataItem = new DataProviderRentalCompany();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }

  public saveHandler(rentalCompany) {
      if (this.isNew) {
        this.dataService.create(rentalCompany);
      } else {
        this.dataService.update(rentalCompany);
      }
      this.editDataItem = undefined;
  }

  public removeHandler(e:any){
    const { sender, rowIndex, dataItem } = e;
    console.log(rowIndex);
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(rentalCompanyGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRentalCompany = selectedData.RentalCompanyId;
  }

}