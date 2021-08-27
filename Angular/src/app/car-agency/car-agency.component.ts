import { Component, Input, OnChanges, ViewChild } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { ToastrService } from 'ngx-toastr';
import { getCarAgencyConfig } from '../data/car-agency.config';
import { DataProviderCarAgency } from '../data/car-agency.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getRentalCompanyConfig } from '../data/rental-company.config';
import { DataProviderRentalCompany } from '../data/rental-company.model';

@Component({
  selector: 'app-car-agency',
  templateUrl: './car-agency.component.html',
  styleUrls: ['./car-agency.component.css']
})
export class CarAgencyComponent implements OnChanges {

  @ViewChild('carAgencyGrid') carAgencyGrid: GridComponent;

  @Input() 
  RentalCompanyId: string = "";

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

  public editDataItem: DataProviderCarAgency;
  public isNew: boolean;

  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public formGroup: FormGroup;

  public rentalCompanyList: Array<DataProviderRentalCompany> = [];
  public rentalCompanyDataService;

  constructor (private progressServiceFactory: ProgressServiceFactory, private toastr:ToastrService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderCarAgency>(
      getCarAgencyConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();
    
    this.rentalCompanyDataService =
      this.progressServiceFactory.getService<DataProviderRentalCompany>(
        getRentalCompanyConfig(),
        this.state2
      );

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
        this.toastr.error(error['error'].message);
      }
    });
  }

 public ngOnInit(): void {
    
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });

    this.rentalCompanyDataService.dataChanges().subscribe((data) =>{
      if (data && data['data']) this.rentalCompanyList = data['data'];
    })

    if(this.RentalCompanyId !== ""){
      this.state.filter.filters = [{field: "RentalCompanyId", operator: "eq", value: this.RentalCompanyId}];
    }

    this.dataService.read(this.state);
    this.rentalCompanyDataService.read();
  }

  public ngOnChanges(): void {
    if(this.RentalCompanyId != ""){
      this.carAgencyGrid?.filterChange.emit({
        filters: [
          {
            field: 'RentalCompanyId',
            operator: 'eq',
            value: this.RentalCompanyId,
          },
        ],
        logic: 'and',
      });
    }
    if(this.RentalCompanyId !== ""){
      this.state.filter.filters = [{field: "RentalCompanyId", operator: "eq", value: this.RentalCompanyId}];
    }

    this.dataService.read(this.state);

  }
  

  public editHandler({ dataItem }) {
    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {
    this.editDataItem = undefined;
  }
  
  public saveHandler(userRole) {
    if (this.isNew) {
      this.dataService.create(userRole);
    } else {
      this.dataService.update(userRole);
    }

    this.editDataItem = undefined;
  }
  
  public addHandler(e: any): void {
    this.editDataItem = new DataProviderCarAgency();
    this.isNew = true;
  }
  
  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public rentalcompanies(id: string): any{
    const t = this.rentalCompanyList.find((x) => x.RentalCompanyId === id);
    if (t != undefined)
    return t;
  }
}
