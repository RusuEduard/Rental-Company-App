import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { getCarTypeConfig } from '../data/car-type.config';
import { DataProviderCarType } from '../data/car-type.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { ToastrService } from 'ngx-toastr';


const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    Description: new FormControl(dataItem.Description,
      Validators.compose([
        Validators.required,
        Validators.pattern("^[a-zA-Z0-9_]+( [a-zA-Z0-9_]+)*$"),
      ])),
    CarTypeId: new FormControl(dataItem.CarTypeId)
  
  });

@Component({
  selector: 'app-car-type-view',
  templateUrl: './car-type-view.component.html',
  styleUrls: ['./car-type-view.component.css']
})
export class CarTypeViewComponent implements OnChanges {

  @Input() 
  CarTypeId: string = "";

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
  public formGroup: FormGroup;

  constructor (private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderCarType>(
      getCarTypeConfig(),
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
    });
    if(this.CarTypeId != ""){
      this.state.filter.filters = [{field: "CarTypeId", operator: "eq", value: this.CarTypeId}];
    }
   
    this.dataService.read(this.state);
  }

  public ngOnChanges(): void {
    if(this.CarTypeId != ""){
      this.state.filter.filters = [{field: "CarTypeId", operator: "eq", value: this.CarTypeId}];
    }
    this.dataService.read(this.state);
  }
  
  public editHandler(e: any): void {
    const { sender, rowIndex, dataItem } = e;
    this.originalItem = Object.assign({}, dataItem);
    this.editDataModel = dataItem;
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
      
      item.CustNum = this.CarTypeId;
        
      if (isNew) {
            this.dataService.create(item);
      } 
      else {
            this.dataService.update(item);
          }
        
      sender.closeRow(rowIndex);   
   }
   else{
    if(item['Description'] ===" " || item['Description'] == "" || item['Description'] === null){
      this.toastr.error("The description is empty", 'Validation error');
    }
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
    this.dataService.read(this.state);
  }
  
  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }

}
