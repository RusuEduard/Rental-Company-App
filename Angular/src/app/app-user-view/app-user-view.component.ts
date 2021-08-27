import { Component, OnInit } from '@angular/core';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { DataProviderAppUser } from '../data/app-user.model';
import { getAppUserConfig } from '../data/app-user.config';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../auth/authentication.service'; 


const createFormGroup: (item: any) => FormGroup = (dataItem: any) =>
  new FormGroup({
    AppUserId: new FormControl(dataItem.AppUserId),
    UserName: new FormControl(dataItem.UserName, Validators.required),
    Password: new FormControl(dataItem.Password, Validators.required),
    Name: new FormControl(dataItem.Name, Validators.required)
  });

@Component({
  selector: 'app-app-user-view',
  templateUrl: './app-user-view.component.html',
  styleUrls: ['./app-user-view.component.css']
})

export class AppUserViewComponent implements OnInit {
  public currentAppUser: string = "";

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

  public editDataItem: DataProviderAppUser;
  public isNew: boolean;
  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;

  private editedRowIndex: number;
  private originalItem: any;
  public formGroup: FormGroup;
  public mySelection: any[];

  constructor(private progressServiceFactory: ProgressServiceFactory, private toastr: ToastrService, private authService: AuthenticationService) {
    this.dataService =
      this.progressServiceFactory.getService<DataProviderAppUser>(
        getAppUserConfig(),
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
    console.log("In ngOnInit");
    console.log("Role type: ", this.authService.getUserRole());
    console.log("Current user: ", this.authService.userValue);
    this.readData();
  }

  private readData(): void{
    console.log("In read data");
    this.dataServiceData = this.dataService.dataChanges();
    this.dataService.dataChanges().subscribe((data) => {
      if (data && data['data']) {
          this.currentAppUser = data['data'][0]['AppUserId'];
          this.mySelection = [this.currentAppUser];
      }
    });
    this.dataService.read(this.state);
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
    const item: any = Object.assign(this.editDataModel, this.formGroup.value);
    let cErrorMessage = "";
    if(item['UserName'] == null || item['UserName'] == "")
      cErrorMessage = cErrorMessage + "UserName cannot be empty!\n";
    if(item['Name'] == null || item['Name'] == "")
      cErrorMessage = cErrorMessage + "Name cannot be empty!\n";
    if(item['Password'] == null || item['Password'] == "")
      cErrorMessage = cErrorMessage + "Password cannot be empty!\n";

    if(cErrorMessage != "")
      this.toastr.error(cErrorMessage, 'Validation error!');
      
      else{
      if (isNew) {
        this.dataService.create(item);
      } else {
        this.dataService.update(item);
      }
    
      sender.closeRow(rowIndex);
    }
    console.log("After save");
  }

  public removeHandler(e: any): void {
    const { dataItem } = e;
    this.dataService.remove(dataItem);
    console.log("after delete!");
    this.dataService.read(this.state);
    this.readData();
  }

  gridUserSelectionChange(appuserGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    this.currentAppUser = selectedData.AppUserId;
  }

  private closeEditor(
    grid: GridComponent,
    rowIndex: number = this.editedRowIndex
  ): void {
    grid.closeRow(rowIndex);
    this.editedRowIndex = undefined;
  }


}
