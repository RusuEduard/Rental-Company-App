import { Injectable } from '@angular/core';
import { AuthenticationService } from './authentication.service';

@Injectable({
  providedIn: 'root',
})
export class RoleService {
  private userRole: string = '';
  constructor() {}

  public getRole(): string {
    return this.userRole;
  }

  public setRole(role: string): void {
    this.userRole = role;
  }

  public clearRoles(): void {
    this.userRole = '';
  }
}
