import { Component, Input, OnChanges, ViewChild } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { FilterDescriptor } from '@progress/kendo-data-query';
import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../auth/authentication.service';
import { getCarAgencyConfig } from '../data/car-agency.config';
import { DataProviderCarAgency } from '../data/car-agency.model';
import { getCarStockConfig } from '../data/car-stock.config';
import { DataProviderCarStock } from '../data/car-stock.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getRentalCompanyConfig } from '../data/rental-company.config';
import { DataProviderRentalCompany } from '../data/rental-company.model';

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    CarStockId: new FormControl(dataItem.CarStockId),
    CarId: new FormControl(dataItem.CarId),
    Address: new FormControl(dataItem.Address),
    CarAgencyId: new FormControl(dataItem.CarAgencyId, Validators.required),
    RentalCompanyId: new FormControl(dataItem.RentalCompanyId),
    ValidFrom: new FormControl(dataItem.ValidFrom , Validators.required  ),
    ValidTo: new FormControl(dataItem.ValidTo),
    StockAmount: new FormControl(dataItem.StockAmount,
      
      Validators.compose([
        Validators.required,
        Validators.pattern("^[0-9]*$"),
      ])),

  });

  
@Component({
  selector: 'app-car-stock-view',
  templateUrl: './car-stock-view.component.html',
  styleUrls: ['./car-stock-view.component.css']
})
export class CarStockViewComponent implements OnChanges {

  @ViewChild('carstockGrid') carstockGrid: GridComponent;

  @Input() 
  CarId: string = "";

  UserRole:string = "";
  RentalCompany:string = "";

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
    filter :{
      logic:'and',
      filters:[]
    }
  };


  public dataService;
  public dataServiceData: any;
  public agencyService:any;
  public view;
  public editDataModel: any;
  private editedRowIndex: number;
  public companyService;
  private originalItem: any;
  public formGroup: FormGroup;
  public CompaniesList: Array<DataProviderRentalCompany> = [];
  public AgenciesList: Array<DataProviderCarAgency> = [];



  constructor (private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService,
              private authService: AuthenticationService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderCarStock>(
      getCarStockConfig(),
      this.state
    );
    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
        this.toastr.error(error['error'].message);
      }
    });

    this.view = this.dataService.dataChanges();
 
    this.companyService =
    this.progressServiceFactory.getService<DataProviderRentalCompany>(
      getRentalCompanyConfig(),
      this.state2
    );

    this.agencyService =
    this.progressServiceFactory.getService<DataProviderCarAgency>(
      getCarAgencyConfig(),
      this.state2
    );

   
  }

 public ngOnInit(): void {
    this.RentalCompany = this.authService.getRentalCompany();
    console.log("rental company: "+this.RentalCompany);
    this.UserRole = this.authService.getUserRole();
    console.log(this.UserRole);

    this.agencyService.dataChanges().subscribe((data)=>{
      if(data && data['data'])
      { this.AgenciesList = data['data'];
        this.AgenciesList.forEach(element => {
          console.log("agency "+element.CarAgencyId);
        });
        if(this.RentalCompany!=='All' && this.RentalCompany!==""){
          this.state.filter.filters.push({field: 'CarAgencyId', operator: 'eq', value:this.AgenciesList[0].CarAgencyId});
         
          this.dataService.read(this.state);
        }
    }
    });
    
    this.companyService.dataChanges().subscribe((data)=>{
      if(data && data['data']) this.CompaniesList = data['data'];
    });
    this.dataServiceData = this.dataService.dataChanges();
  
    if(this.RentalCompany!==undefined && this.RentalCompany!=="" && 
        this.RentalCompany!=='All'){
      
      this.state2.filter.filters = [{field: "RentalCompanyId", operator: "eq", 
          value: this.RentalCompany}];

      if(this.CarId != ""){    
        this.state.filter.filters =  [{field: "CarId", operator: "eq", value: this.CarId}];

      }
    }
    else{
      this.state2.filter.filters= [];
      this.state.filter.filters = [{field: "CarId", operator: "eq", value: this.CarId}];

    }

    this.dataService.read(this.state);
    this.agencyService.read(this.state2);
    this.companyService.read(this.state2);
   


  }

  public ngOnChanges(): void {

    
    if(this.RentalCompany!=='All'  && this.RentalCompany!=="" && this.AgenciesList[0] && this.CarId!==""){
        this.state.filter.filters = [];
 
         this.carstockGrid.filterChange.emit({
          filters: [
            {
              field: 'CarAgencyId',
              operator: 'eq',
              value: this.AgenciesList[0].CarAgencyId,
            },
            {
              field: 'CarId',
              operator: 'eq',
              value: this.CarId,
            }
          ],
          logic: 'and',
        });
      }
    else if(this.CarId != ""  ){
      this.state.filter.filters=[{field: "CarId", operator: "eq", value: this.CarId}];
    }
  
    console.log(this.state.filter.filters);
    this.dataService.read(this.state); 

  }


  
  
  public editHandler(e: any): void {
    
    const { sender, rowIndex, dataItem } = e;
    this.originalItem = Object.assign({}, dataItem);
    console.log(dataItem);
    let CarAgency;
    this.editDataModel = dataItem;
    if( dataItem && dataItem!==undefined && dataItem.CarAgencyId!==undefined){
      const AgencyId = dataItem.CarAgencyId;
      CarAgency = this.AgenciesList.find((x) => x.CarAgencyId === AgencyId);
      this.editDataModel.CarAgencyId = AgencyId;

    }
   
    this.formGroup = createFormGroup(this.originalItem);
    
    this.closeEditor(sender);
    this.editedRowIndex = rowIndex;
    sender.editRow(rowIndex, this.formGroup);
    
  }
  
  public cancelHandler({ sender, rowIndex }: any): void {
    Object.assign(this.editDataModel, this.originalItem);
    this.closeEditor(sender, rowIndex);
  }
  
  public saveHandler({ sender, rowIndex, isNew }: any): void {
    const item: any = Object.assign(this.editDataModel, this.formGroup.value);
    if(this.formGroup.valid){
      console.log(this.formGroup.value);
      console.log(this.editDataModel);
      const CarAgency= this.AgenciesList.find((x) => x.CarAgencyId === item.CarAgencyId);
      console.log("[save]car agency = "+CarAgency);
      if(CarAgency && CarAgency!==undefined) item.CarAgencyId = CarAgency.CarAgencyId;
      item.CarId = this.CarId;

      console.log("save item = "+ item.CarAgencyId);
      if (isNew) {
        this.dataService.create(item);
      } else {
        this.dataService.update(item);
      }
    
      sender.closeRow(rowIndex);
   }
   else{
    let errors= "";
    if(item['ValidFrom'] === null || item['ValidFrom'] === ""){
      errors+="The valid from date is not selected; \n ";
    }
    if(item['CarAgencyId'] === null){
      errors+="The agency is not selected; \n";
    }
    if(item['StockAmount'] === 0 || item['StockAmount'] === null){
      errors+="The stock amount is empty; \n";
    }

    this.toastr.error(errors, 'Validation error');

   }
  }
  
  public addHandler(e: any): void {
    const { sender } = e;
    
    this.editDataModel = this.dataService.createModel();
    this.formGroup = createFormGroup({});

    this.closeEditor(sender);
    sender.addRow(this.formGroup);

  
  }
  
  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    
    if( this.state.filter.filters.filter(
      (el: FilterDescriptor) => el.field == 'CarId'
      )[0] !== undefined){
    
      this.state.filter.filters.filter(
          (el: FilterDescriptor) => el.field == 'CarId'
          )[0]['value'] = this.CarId;


      this.dataService.read(this.state);
    }
  
  }
  
  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }

  public companies(id: string): any {
    
    if(this.CompaniesList != []){
      const agency = this.AgenciesList.find((x)=>x.CarAgencyId === id);
      if(agency && agency!==undefined){
        const t = this.CompaniesList.find((x)=> x.RentalCompanyId === agency.RentalCompanyId);
        return t;
      }
  }
    return undefined;

  }
  public agencies(id: string): any {
    
    if(this.AgenciesList !=[]){
      const agency = this.AgenciesList.find((x)=>x.CarAgencyId === id);

      return agency;
    }

  }

}
