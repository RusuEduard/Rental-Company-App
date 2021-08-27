import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { getRentConfig } from '../data/rent.config';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { DataProviderRent } from '../data/rent.model';
import { DataProviderAppUser } from '../data/app-user.model';
import { getAppUserConfig } from '../data/app-user.config';
import { DataProviderCarAgency } from '../data/car-agency.model';
import { DataProviderRentalCompany } from '../data/rental-company.model';
import { getCarAgencyConfig } from '../data/car-agency.config';
import { getRentalCompanyConfig } from '../data/rental-company.config';
import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../auth/authentication.service';
const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({

    RentId: new FormControl(dataItem.RentId),
    AppUserId: new FormControl(dataItem.AppUserId, Validators.required),
    CarAgency: new FormControl(dataItem.CarAgency, Validators.required),
    CarAgencyId: new FormControl(dataItem.CarAgencyId, Validators.required),
    DateFrom: new FormControl(dataItem.DateFrom, Validators.required),
    DateTo: new FormControl(dataItem.DateTo, Validators.required),
   
  });
  
@Component({
  selector: 'app-rent-view',
  templateUrl: './rent-view.component.html',
  styleUrls: ['./rent-view.component.css']
})
export class RentViewComponent implements OnInit {
  public currentRent: string = "";

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
    filter: {
      logic: 'and',
      filters: [],
    },
  };
  public state3: any = {
    skip: 0,
    take: 100,
    filter: {
      logic: 'and',
      filters: [],
    },
  };
  public AppUserList: Array<DataProviderAppUser> =[];
  public CarAgencyList: Array<DataProviderCarAgency> = [];
  public RentalCompanyList: Array<DataProviderRentalCompany> =[];
  public RentStatusList=["finished","ongoing","pending"];

  public rentalCompanyId: string="";
  public appUserId: string="";

  public UserRole:string="";
  public editDataItem: DataProviderRent;
  public isNew: boolean;
  public dataService;
  public stateDataService;
  public stateDataService1;
  public stateDataService2;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;
  public mySelection: any[];

  
  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService, private AuthService: AuthenticationService) {

    this.dataService =
      this.progressServiceFactory.getService<DataProviderRent>(
        getRentConfig(),
        this.state
      );
      this.dataService.errors.subscribe((error) => {
        if(error && error['error']){
          this.toastr.error(error['error'].message);
        }
      });
    this.view = this.dataService.dataChanges();

    this.stateDataService =
      this.progressServiceFactory.getService<DataProviderAppUser>(
        getAppUserConfig(),
        this.state2
      );

    this.stateDataService1 =
      this.progressServiceFactory.getService<DataProviderCarAgency>(
        getCarAgencyConfig(),
        this.state3
      );

    this.stateDataService2 =
      this.progressServiceFactory.getService<DataProviderRentalCompany>(
        getRentalCompanyConfig(),
        this.state3
      );
   }

  ngOnInit(): void {

    this.rentalCompanyId = this.AuthService.getRentalCompany();
    this.appUserId = this.AuthService.userValue.AppUserId;
    this.UserRole = this.AuthService.getUserRole();
    console.log(this.rentalCompanyId, this.UserRole);
    this.stateDataService.dataChanges().subscribe((data) => {
      if (data && data['data']){
         this.AppUserList = data['data'];
         console.log(this.AppUserList[0].AppUserId);
         
       //  this.dataService.read(this.state);
      }

    });
    if (this.UserRole !=="superadmin"){
        this.state.filter.filters.push( {
          field: "AppUserId", operator: "eq", value:this.appUserId
        });
    }
    this.stateDataService1.dataChanges().subscribe((data) => {
      if (data && data['data']) {
        this.CarAgencyList = data['data'];
        console.log(this.CarAgencyList[0].CarAgencyId);
        if(this.CarAgencyList !== undefined && this.CarAgencyList[0] !== undefined){
          console.log(this.CarAgencyList[0].CarAgencyId);
          this.state.filter.filters.push ({
            field: "CarAgencyId", operator: "eq", value:this.CarAgencyList[0].CarAgencyId
          });
      }
        this.dataService.read(this.state);
       
     };
    });

    this.stateDataService2.dataChanges().subscribe((data) => {
      if (data && data['data']) this.RentalCompanyList = data['data'];
    });
    
    console.log(this.state.filter.filters);
    this.readData();
    if(this.UserRole !== "superadmin"){
     
      this.state2.filter.filters = [{
         field: "AppUserId", operator: "eq", value:this.appUserId
      }];
    }

    if(this.rentalCompanyId !== "" && this.rentalCompanyId !== "All"){
     
      this.state3.filter.filters = [{
         field: "RentalCompanyId", operator: "eq", value:this.rentalCompanyId
      }];
    }
    this.stateDataService.read(this.state2);
    this.stateDataService1.read(this.state3);
    this.stateDataService2.read(this.state3);
  }

  private readData(): void{
    
    this.dataServiceData = this.dataService.dataChanges();
    
    this.dataService.dataChanges().subscribe((data) => {

      if (data && data['data']) {

          this.currentRent = data['data'][0]['RentId'];
          this.mySelection = [this.currentRent];
      }
    });
    console.log(this.state.filter.filters);
    this.dataService.read(this.state);
  }

  public dataStateChange(state: DataStateChangeEvent): void {

    this.state = state;
    if(this.UserRole==="superadmin")
        this.state.filter.filters=[];
    this.dataService.read(this.state);
  }

  public addHandler(e: any): void {

    this.editDataItem = new DataProviderRent();
    this.isNew = true;
  }

  public editHandler({ dataItem }) {

    this.editDataItem = dataItem;
    this.isNew = false;
  }

  public cancelHandler() {

    this.editDataItem = undefined;
  }

  public saveHandler(rentcar) {

    
    let cErrorMessage = "";

    if(rentcar['DateFrom'] == null || rentcar['DateFrom'] == "")
      cErrorMessage = cErrorMessage + "Starting rent's date cannot be empty!\n";
    if(rentcar['DateTo'] == null || rentcar['DateTo'] == "")
      cErrorMessage = cErrorMessage + "Ending rent's date cannot be empty!\n";
    if(rentcar['DateFrom'] > rentcar['DateTo'])
    cErrorMessage = cErrorMessage + "Starting rent's date cannot be after ending rent's date!\n";
    if(rentcar['AppUserId'] == null || rentcar['AppUserId'] == "")
      cErrorMessage = cErrorMessage + "User cannot be empty!\n";
    if(cErrorMessage != "")
      this.toastr.error(cErrorMessage, 'Validation error!');
    else{
      if (this.isNew) {

        this.dataService.create(rentcar);
      } else {

        this.dataService.update(rentcar);
      }

      this.toastr.success('succes');
    }

    //this.editDataItem = undefined;
  }

  public removeHandler({ dataItem }) {

    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(rentGrid, selection) {

    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRent = selectedData.RentId;
   
  }

  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }

  public appuser(id: string): any {
    
    const t = this.AppUserList.find((x) => x.AppUserId === id);
    
    return t;
  }

  public caragency(id: string): any{

    const t = this.CarAgencyList.find((x) => x.CarAgencyId === id);
    
    return t;
  }

  public rentalcompany(id: string): any{

    const u = this.RentalCompanyList.find((y) => y.RentalCompanyId === this.caragency(id)?.RentalCompanyId);
    
    return u;
  }

}
