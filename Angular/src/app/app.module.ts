import { HttpClient, HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { DialogModule } from '@progress/kendo-angular-dialog';
import { DropDownListModule } from '@progress/kendo-angular-dropdowns';
import { GridModule } from '@progress/kendo-angular-grid';
import { InputsModule } from '@progress/kendo-angular-inputs';
import { LabelModule } from '@progress/kendo-angular-label';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { UserRoleViewComponent } from './user-role-view/user-role-view.component';
import { DropDownListFilterComponent } from './dropdownlist-filter/dropdownlist-filter.component';
import { EditFormComponent } from './edit-form/edit-form.component';
import { CarStockViewComponent } from './car-stock-view/car-stock-view.component';
import { AppUserViewComponent } from './app-user-view/app-user-view.component';
import { EditFormAppuserComponent } from './edit-form-appuser/edit-form-appuser.component';
import { RoleTypeViewComponent } from './role-type-view/role-type-view.component';
import { DataProviderService } from './data/service-config';
import { ProgressServiceFactory } from './data/progress-service-factory';
import { ProgressSessionService } from './data/progress-session.service';
import { CarTypeViewComponent } from './car-type-view/car-type-view.component';
import { LoginComponent } from './login/login.component';
import { AppLayoutComponent } from './app-layout/app-layout.component';
import { ForbiddenAccessComponent } from './forbidden-access/forbidden-access.component';
import { CarTypeReportComponent } from './car-type-report/car-type-report.component';
import { RaportCompaniesUsersNumComponent } from './raport-companies-users-num/raport-companies-users-num.component';
import { DropdownlistRoletypesComponent } from './dropdownlist-roletypes/dropdownlist-roletypes.component';
import { ToastrModule } from 'ngx-toastr';
import { CarAgencyComponent } from './car-agency/car-agency.component';
import { RentalCompanyComponent } from './rental-company/rental-company.component';
import { EditForm2Component } from './edit-form2/edit-form2.component';
import { DropdownlistFilter2Component } from './dropdownlist-filter2/dropdownlist-filter2.component';
import { RentViewComponent } from './rent-view/rent-view.component';
import { RentCarViewComponent } from './rent-car-view/rent-car-view.component';
import { EditFormRentComponent } from './edit-form-rent/edit-form-rent.component';
import { EditFormRentCarComponent } from './edit-form-rent-car/edit-form-rent-car.component';
import { DropdownlistRentalcoComponent } from './dropdownlist-rentalco/dropdownlist-rentalco.component';
import { CarViewComponent } from './car-view/car-view.component';
import { CarStockDropdownComponent } from './car-stock-dropdown/car-stock-dropdown.component';
import { RentsReportComponent } from './rents-report/rents-report.component';
import { LaunchReportComponent } from './launch-report/launch-report.component';
import { UsersReportComponent } from './users-report/users-report.component';
import { EditFormCaragencyComponent } from './edit-form-caragency/edit-form-caragency.component';

@NgModule({
  declarations: [
    AppComponent,
    CarViewComponent,
    DropDownListFilterComponent,
    DropdownlistRoletypesComponent,
    EditFormComponent,
    EditFormAppuserComponent,
    CarStockViewComponent,
    CarTypeViewComponent,
    LoginComponent,
    ForbiddenAccessComponent,
    AppLayoutComponent,
    AppUserViewComponent,
    RoleTypeViewComponent,
    CarTypeReportComponent,
    UserRoleViewComponent,
    CarAgencyComponent,
    RentalCompanyComponent,
    EditForm2Component,
    DropdownlistFilter2Component,
    RentViewComponent,
    RentCarViewComponent,
    EditFormRentComponent,
    EditFormRentCarComponent,
    EditFormCaragencyComponent,
    DropdownlistRentalcoComponent,
    RaportCompaniesUsersNumComponent,
    CarStockDropdownComponent,
    RentsReportComponent,
    LaunchReportComponent,
    UsersReportComponent
],
  imports: [  BrowserModule,
    HttpClientModule,

    AppRoutingModule,
    GridModule,
    ReactiveFormsModule,
    DropDownListModule,
    InputsModule,
    DialogModule,
    LabelModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    GridModule],

  providers: [
    DataProviderService,
    ProgressServiceFactory,
    ProgressSessionService
    ],
  bootstrap: [AppComponent]
})
export class AppModule { }
