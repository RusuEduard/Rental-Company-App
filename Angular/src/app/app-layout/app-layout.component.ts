import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthenticationService } from '../auth/authentication.service';
import { AuthorizationService } from '../auth/authorization.service';

@Component({
  selector: 'app-app-layout',
  templateUrl: './app-layout.component.html',
  styleUrls: ['./app-layout.component.css']
})
export class AppLayoutComponent implements OnInit {
  constructor(
    private authService: AuthenticationService,
    private router: Router,
    private authorization: AuthorizationService
  ) {}

  ngOnInit(): void {}

  logout(): void {
    this.authService.logout();
    this.router.navigate(['login']);
  }

  back():void {
    this.authService.setUserRole('undefined');
    this.router.navigate(['app-company-picker']);
  }

  isAuthorized(roleList: string[]): boolean {
    return this.authorization.isAuthorized({ roles: roleList });
  }

}
