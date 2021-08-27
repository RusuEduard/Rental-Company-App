import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { DataProviderAppUser } from '../data/app-user.model';
import { RentalCompanyService } from './rental-company.service';
import { RoleService } from './role.service';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService {
  private currentUser!: DataProviderAppUser;
  private loginUrl = "http://localhost:8810/BestCars/rest/BestCarsService/SIAppUser/GetUserByUsernameAndPassword";
  private roleTestUrl = "http://localhost:8810/BestCars/rest/BestCarsService/SIUserRole/IsUserSuperAdmin";
  public readonly errors = new BehaviorSubject<Error>(null);

  public get userValue(): DataProviderAppUser | null {
    return this.currentUser;
  }

  constructor(private http: HttpClient, private roleService: RoleService, 
              private rentalCompanyService: RentalCompanyService) {}

  getUserData(username: string, password: string): Observable<DataProviderAppUser> {
    const url = `${this.loginUrl}`;
    return this.http.put<DataProviderAppUser>(url, {"request":{
      "ipcUserName":username,
      "ipcPassword":password
  }
  })
      .pipe(
        tap( response => console.log(response)),
        map( response => response['response']['dsAppUser']['dsAppUser']['ttAppUser'][0])
      );
  }

  isUserSuperadmin(): Observable<boolean> {
    return this.http.put<boolean>(this.roleTestUrl, {"request":{
        "ipcAppUserId": this.currentUser.AppUserId
      }
    })
      .pipe(
        tap(response => console.log(response['response'].oplIsSuper)),
        map( response => response['response'].oplIsSuper)
      );
  }

  login(username: string, password: string): Observable<boolean> {
    const response = this.getUserData(username,password).pipe(map(result => {
      this.currentUser = result; console.log(this.currentUser); 
      if(this.currentUser != null){
        return true;
      }
        return false;
      }
    ));
    return response;
  }

  setUserRole(userrole:string):void{
    this.roleService.setRole(userrole);
  }

  getUserRole(): string{
    return this.roleService.getRole();
  }
  
  setRentalCompany(company:string):void{
    this.rentalCompanyService.setRentalCompany(company);
  }

  getRentalCompany(): string{
    return this.rentalCompanyService.getRentalCompany();
  }

  logout(): void {
    this.currentUser = new DataProviderAppUser();
    this.roleService.clearRoles();
  }

  handleError(err: HttpErrorResponse) {
    this.errors.next(err);
  }
}
