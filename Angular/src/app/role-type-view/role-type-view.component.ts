import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { DataProviderRoleType } from '../data/role-type.model';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { getRoleTypeConfig } from '../data/role-type.config';
import { ToastrService } from 'ngx-toastr';

const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    RoleTypeId: new FormControl(dataItem.RoleTypeId),
    Description: new FormControl(dataItem.Description, Validators.required)
  });

@Component({
  selector: 'app-role-type-view',
  templateUrl: './role-type-view.component.html',
  styleUrls: ['./role-type-view.component.css']
})
export class RoleTypeViewComponent implements OnInit {
  public currentRoleType: string = "";

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

  public editDataItem: DataProviderRoleType;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;
  public mySelection: any[];

  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr:ToastrService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderRoleType>(
        getRoleTypeConfig(),
        this.state
      );

    this.view = this.dataService.dataChanges();

    this.dataService.errors.subscribe((error) => {
      if(error && error['error']){
        this.toastr.error(error['error'].message);
      }
    });
  }

  public ngOnInit(): void {
    this.readData();
  }

  private readData(): void{
    console.log("In read data");
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
      if (data && data['data']) {
          this.currentRoleType = data['data'][0]['RoleTypeId'];
          this.mySelection = [this.currentRoleType];
      }
    });
    this.dataService.read();
  }

  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  public addHandler(e: any): void {
    const { sender } = e;
    this.editDataModel = this.dataService.createModel();
    this.formGroup = createFormGroup({});
    this.closeEditor(sender);
    sender.addRow(this.formGroup);
  }

  public editHandler( e: any ): void {
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
    console.log("In save handle");
    const item: any = Object.assign(this.editDataModel, this.formGroup.value);
    let cErrorMessage = "";
    console.log(item);
    if(item['Description'] == null || item['Description'] == "")
      cErrorMessage = cErrorMessage + "Description cannot be empty!\n";
    if(cErrorMessage != "")
      alert(cErrorMessage);
      else{
      if (isNew) {
        this.dataService.create(item);
      } else {
        this.dataService.update(item);
      }
    
      sender.closeRow(rowIndex);
    }
  }

  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
  }

  gridUserSelectionChange(roletypeGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentRoleType = selectedData.RoleTypeId;
  }

  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }


}
