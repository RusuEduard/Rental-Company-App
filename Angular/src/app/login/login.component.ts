import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { AuthenticationService } from '../auth/authentication.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  loginForm!: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private authService: AuthenticationService,
    private toastr: ToastrService
  ) {
    this.loginForm = this.formBuilder.group({
      username: ['', [Validators.required]],
      password: ['', [Validators.required]],
    });

    this.authService.errors.subscribe((error) => {
      if(error && error['error']){
        this.toastr.error(error['error'].message, 'There is no account associated with this username and password');
      }
    });
  }

  
  ngOnInit(): void {}

  onSubmit() {
    const username = this.loginForm.controls.username.value;
    const password = this.loginForm.controls.password.value;
    this.authService.login(username, password).subscribe(response => 
      {
        if(response = true){
          this.authService.isUserSuperadmin().subscribe((response) =>{
            if(response == true){
              console.log('superadmin logged in');
              this.authService.setUserRole('superadmin');
              this.router.navigate(['/']);
            }
            else{
              console.log('user logged in');
              this.authService.setUserRole('undefined');
              this.router.navigate(['/app-company-picker']);
            }
          }, (err: HttpErrorResponse) => {
              this.authService.handleError(err);
            });
        }
      }, (err: HttpErrorResponse) => {
          this.authService.handleError(err);
      });
    console.log("After login: ", this.authService.getUserRole());
  }
}
