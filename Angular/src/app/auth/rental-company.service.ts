import { Injectable } from '@angular/core';
import { AuthenticationService } from './authentication.service';

@Injectable({
  providedIn: 'root',
})
export class RentalCompanyService {
  private RentalCompany: string = '';
  constructor() {}

  public getRentalCompany(): string {
    return this.RentalCompany;
  }

  public setRentalCompany(role: string): void {
    this.RentalCompany = role;
  }

  public clearRentalCompany(): void {
    this.RentalCompany = '';
  }
}
