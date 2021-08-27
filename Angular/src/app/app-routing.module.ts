import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CarTypeViewComponent } from './car-type-view/car-type-view.component';
import { CarViewComponent } from './car-view/car-view.component';
import { AppLayoutComponent } from './app-layout/app-layout.component';
import { AuthenticationGuardService } from './auth/authentication-guard.service';
import { AuthorizationGuardService } from './auth/authorization-guard.service';
import { ForbiddenAccessComponent } from './forbidden-access/forbidden-access.component';
import { LoginComponent } from './login/login.component';
import { AppUserViewComponent } from './app-user-view/app-user-view.component';
import { CarTypeReportComponent } from './car-type-report/car-type-report.component';
import { CarAgencyComponent } from './car-agency/car-agency.component';
import { RentalCompanyComponent } from './rental-company/rental-company.component';
import { RentViewComponent } from './rent-view/rent-view.component';
import { RoleTypeViewComponent } from './role-type-view/role-type-view.component';
import { UserRoleViewComponent } from './user-role-view/user-role-view.component';
import { RaportCompaniesUsersNumComponent } from './raport-companies-users-num/raport-companies-users-num.component';
import { LaunchReportComponent } from './launch-report/launch-report.component';
import { RentsReportComponent } from './rents-report/rents-report.component';
import { UsersReportComponent } from './users-report/users-report.component';

const routes: Routes = [
  {
    path: '',
    component: AppLayoutComponent,
    canActivate: [AuthenticationGuardService],
    children: [
     
      {
        path: 'app-company-picker',
        component: UserRoleViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['undefined'],
          },
        },
      },
      {
        path: 'car-view',
        component: CarViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'user', 'superadmin'],
          },
        },
      },
      {
        path: 'car-type-report',
        component: CarTypeReportComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'superadmin'],
          },
        },
      },
      {
        path: 'companies-users-report',
        component: RaportCompaniesUsersNumComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['superadmin'],
          },
        },
      },
      {
        path: 'car-type-view',
        component: CarTypeViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'superadmin'],
          },
        },
      },
      {
        path: 'user-view',
        component: AppUserViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['superadmin'],
          },
        },
      },
      {
        path: 'app-car-agency',
        component: CarAgencyComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'superadmin'],
          },
        },
      },
      {
        path: 'app-rental-company',
        component: RentalCompanyComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'superadmin'],
          },
        },
      },
      {
        path: 'app-launch-report',
        component: LaunchReportComponent,
        canActivate: [AuthorizationGuardService],
        children: [
          {
            path: 'app-raport-top-users',
            component: UsersReportComponent,
            canActivate: [AuthorizationGuardService],
            data: {
              authorization: {
                roles: ['admin', 'superadmin'],
              },
            },
          },
          {
            path: 'app-rents-report',
            component: RentsReportComponent,
            canActivate: [AuthorizationGuardService],
            data: {
              authorization: {
                roles: ['admin', 'superadmin'],
              },
            },
          },
          {
            path: 'app-raport-companies-users-num',
            component: RaportCompaniesUsersNumComponent,
            canActivate: [AuthorizationGuardService],
            data: {
              authorization: {
                roles: ['admin', 'superadmin'],
              },
            },
          },
          {
            path: 'car-type-report',
            component: CarTypeReportComponent,
            canActivate: [AuthorizationGuardService],
            data: {
              authorization: {
                roles: ['admin', 'superadmin'],
              },
            },
          },
        ]
      },
      {
        path: 'rent',
        component: RentViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['admin', 'user', 'superadmin'],
          },
        },
      },
      {
        path: 'role-types',
        component: RoleTypeViewComponent,
        canActivate: [AuthorizationGuardService],
        data: {
          authorization: {
            roles: ['superadmin'],
          },
        },
      },
     
    ],
  },
  { path: 'login', component: LoginComponent },
  { path: 'forbidden', component: ForbiddenAccessComponent },
  { path: '**', redirectTo: '' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
