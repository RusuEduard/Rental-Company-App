import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { DataStateChangeEvent, GridComponent } from '@progress/kendo-angular-grid';
import { getUserRoleConfig } from '../data/user-role.config';
import { DataProviderUserRole } from '../data/user-role.model';
import { DataProviderRoleType } from '../data/role-type.model';
import { getRoleTypeConfig } from '../data/role-type.config';
import { DataProviderRentalCompany } from '../data/rental-company.model';
import { getRentalCompanyConfig } from '../data/rental-company.config';
import { ProgressServiceFactory } from '../data/progress-service-factory';
import { AuthenticationService } from '../auth/authentication.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-user-role-view',
  templateUrl: './user-role-view.component.html',
  styleUrls: ['./user-role-view.component.css']
})
export class UserRoleViewComponent implements OnInit {
  @ViewChild('rolesGrid') rolesGrid: GridComponent;

  @Input() 
  AppUserId: string = "";

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

  public editDataItem: DataProviderUserRole;
  public isNew: boolean;

  public dataService;
  public dataServiceData: any;
  public view;
  public editDataModel: any;
  public formGroup: FormGroup;

  public roleTypesList: Array<DataProviderRoleType> = [];
  public roleTypesDataService;

  public rentalCompanyList: Array<DataProviderRentalCompany> = [];
  public rentalCompanyDataService;

  constructor (private progressServiceFactory: ProgressServiceFactory, private router: Router, private authService: AuthenticationService, private toastr:ToastrService) {
    this.dataService =
    this.progressServiceFactory.getService<DataProviderUserRole>(
      getUserRoleConfig(),
      this.state
    );

    this.view = this.dataService.dataChanges();

    this.roleTypesDataService =
      this.progressServiceFactory.getService<DataProviderRoleType>(
        getRoleTypeConfig(),
        this.state2
      );
    
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
      console.log(data);
    });

    this.roleTypesDataService.dataChanges().subscribe((data) => {
      if (data && data['data']) this.roleTypesList = data['data'];
    });

    this.rentalCompanyDataService.dataChanges().subscribe((data) =>{
      if (data && data['data']) this.rentalCompanyList = data['data'];
    })


    if(this.AppUserId != ""){
      this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: this.AppUserId}];
    }
    else{
      let currentUser = this.authService.userValue;
      this.state.filter.filters = [{field: "AppUserId", operator: "eq", value: currentUser.AppUserId}];
    }
   
    this.dataService.read(this.state);
    this.roleTypesDataService.read();
    this.rentalCompanyDataService.read();

    console.log("Role types: ", this.roleTypesList);
    console.log("Rental companys: ", this.rentalCompanyList);
  }

  public ngOnChanges(): void {
    if(this.AppUserId != ""){
      this.rolesGrid?.filterChange.emit({
        filters: [
          {
            field: 'AppUserId',
            operator: 'eq',
            value: this.AppUserId,
          },
        ],
        logic: 'and',
      });

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
    console.log("add");
    console.log("App user id: ", this.AppUserId);
    this.editDataItem = new DataProviderUserRole();
    this.isNew = true;
  }
  
  public removeHandler({ dataItem }) {
    this.dataService.remove(dataItem);
  }
  
  public dataStateChange(state: DataStateChangeEvent): void {
    this.state = state;
    this.dataService.read(this.state);
  }

  
  public roletypes(id: string): any{
    const t = this.roleTypesList.find((x) => x.RoleTypeId === id);
    if(t != undefined)
      console.log("Roletype = "+t.Description);
    return t;
  }


  public rentalcompany(id: string): any{
    const t = this.rentalCompanyList.find((x) => x.RentalCompanyId === id);
    if (t != undefined)
      console.log("Rental company = " + t.Description);
    return t;
  }

  gridUserSelectionChange(rolesGrid, selection) {
    const selectedData = selection.selectedRows[0].dataItem;
    if(this.AppUserId == ""){
      this.authService.setUserRole(this.roletypes(selectedData.RoleTypeId).Description);
      this.authService.setRentalCompany(selectedData.RentalCompanyId);
      this.router.navigate(['/']);
    }
  }
 
}
