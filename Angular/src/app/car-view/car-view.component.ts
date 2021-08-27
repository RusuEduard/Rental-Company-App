import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { getCarTypeConfig } from '../data/car-type.config';
import { DataStateChangeEvent, GridComponent, GridDataResult, GridItem, RowClassArgs } from '@progress/kendo-angular-grid';
import { DataProviderCarType } from '../data/car-type.model';
import { getCarConfig } from '../data/car.config';
import { DataProviderCar } from '../data/car.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../auth/authentication.service';

@Component({
  selector: 'app-car-view',
  templateUrl: './car-view.component.html',
  styleUrls: ['./car-view.component.css']
})
export class CarViewComponent implements OnInit {

  public grid:GridDataResult;
  @Input()
  AppUserId:string ;

  @Input()
  RentalCompanyId:string;

  UserRole:string ="";

  public currentCar: string = "";
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

  public editDataItem: DataProviderCar;
  public isNew: boolean;
  public CarTypesList: Array<DataProviderCarType> = [];
  public dataService;
  public stateDataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService,
              private authService: AuthenticationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderCar>(
        getCarConfig(),
        this.state
      );

    this.dataService.errors.subscribe((error) => {
        if(error && error['error']){
          this.toastr.error(error['error'].message);
        }
      });
      
    this.view = this.dataService.dataChanges();

    this.stateDataService =
      this.progressServiceFactory.getService<DataProviderCarType>(
        getCarTypeConfig(),
        this.state2
      );

  }

  public ngOnInit(): void {
    console.log(this.dataService);
    this.dataServiceData = this.dataService.dataChanges();
    this.UserRole = this.authService.getUserRole();
    console.log(this.UserRole);

  

    this.dataService.dataChanges().subscribe((data) => {
      console.log(data);
      if(data!==null ){
        console.log("selection: "+ data['data'][this.mySelection[0]]);
        console.log("my selection: "+this.mySelection[0]);
        this.currentCar = data['data'][0]?.CarId;
      }
     
    });


    this.stateDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.CarTypesList = data['data'];
    });
    this.dataService.read();
    this.stateDataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
    this.mySelection[0]=state.skip;




  }

  public addHandler() {
    this.editDataItem = new DataProviderCar();
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
    
    let errors= "";
    if(car['Model'] === null || car['Model'] === " "){
        errors+="The model is not typed; \n ";
    }
    if(car['Manufacturer'] === null || car['Manufacturer'] === " "){
        errors+="The manufacturer is not typed; \n";
    }
    if(car['CarTypeId'] ===  null){
        errors+="The car type is not selected; \n";
    }
  
    if(errors != "")
      this.toastr.error(errors, 'Validation error');
    else{
  
      if (this.isNew) {
        this.dataService.create(car);
      } else {
        this.dataService.update(car);
      }

      this.editDataItem = undefined;
    }
  }

 

  public removeHandler(e:any){
    const { sender, rowIndex, dataItem } = e;
    console.log(rowIndex);
    this.dataService.remove(dataItem);
 

  }


  gridUserSelectionChange(carGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentCar = selectedData.CarId;
    //this.mySelection[0]= this.currentCar;
  }

  public cartypes(id: string): any {
    
    const t = this.CarTypesList.find((x) => x.CarTypeId === id);
    return t;
  }
}


