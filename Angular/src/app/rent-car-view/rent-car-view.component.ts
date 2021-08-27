import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getRentCarConfig } from '../data/rent-car.config';
import { DataProviderRentCar } from '../data/rent-car.model';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { DataProviderRent } from '../data/rent.model';
import { getRentConfig } from '../data/rent.config';
import { DataProviderCar } from '../data/car.model';
import { getCarConfig } from '../data/car.config';
import { FilterDescriptor } from '@progress/kendo-data-query';
import { ToastrService } from 'ngx-toastr';


  
@Component({
  selector: 'app-rent-car-view',
  templateUrl: './rent-car-view.component.html',
  styleUrls: ['./rent-car-view.component.css']
})
export class RentCarViewComponent implements OnChanges {
  @Input() RentId: string = "";

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

  public CarList: Array<DataProviderCar> =[];
  
  public editDataItem: DataProviderRentCar;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public stateDataService;
  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;
  public mySelection: any[];


  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderRentCar>(
      getRentCarConfig(),
      this.state
    );
    
    this.view = this.dataService.dataChanges();
    this.stateDataService =
      this.progressServiceFactory.getService<DataProviderCar>(
        getCarConfig(),
        this.state2
      );
      this.dataService.errors.subscribe((error) => {
        if(error && error['error']){
          this.toastr.error(error['error'].message);
        }
      });
   }

  ngOnInit(): void {

    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
    });

    if(this.RentId != ""){
      this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    }

    this.stateDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.CarList = data['data'];
    });

    this.dataService.read(this.state);
    this.stateDataService.read();
   
  }
  ngOnChanges(): void{

    if(this.RentId != ""){
      this.state.filter.filters = [{field: "RentId", operator: "eq", value: this.RentId}];
    }

    this.dataService.read(this.state);
 
  }
  
  private readData(): void{
   
    this.dataServiceData = this.dataService.dataChanges();

    this.dataService.dataChanges().subscribe((data) => {

      if (data && data['data']) {

          console.log(data);
          this.RentId = data['data'][0]['RentId'];
          this.mySelection = [this.RentId];
      }
    });

    this.dataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {

    this.state = state;

    this.state.filter.filters.filter(
      (el: FilterDescriptor) => el.field == 'RentId'
      )[0]['value'] = this.RentId;

    this.dataService.read(this.state);
    this.mySelection=[state.skip];
  }

  public addHandler() {

    this.editDataItem = new DataProviderRentCar();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {

    this.editDataItem = dataItem;
    this.isNew = false;
  }
  
  public cancelHandler() {

    this.editDataItem = undefined;
  }

  public saveHandler(car) {

    if (this.isNew) {
      this.dataService.create(car);
    } else {
      this.dataService.update(car);
    }

    this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {

    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(appuserGrid, selection) {

    const selectedData = selection.selectedRows[0].dataItem;
    this.RentId = selectedData.RentCarId;
  }

  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {

    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }

  public car(id: string):any{

    const t = this.CarList.find((x) => x.CarId === id);
    return t;
  }

}
