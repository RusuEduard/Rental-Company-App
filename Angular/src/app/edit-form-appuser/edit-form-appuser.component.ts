import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderUserRole } from '../data/user-role.model';

@Component({
  selector: 'app-edit-form-appuser',
  templateUrl: './edit-form-appuser.component.html',
  styleUrls: ['./edit-form-appuser.component.css']
})

export class EditFormAppuserComponent {
  @Input() roleTypesList: any;
  @Input() rentalCompanyList: any;
  @Input() AppUserId: string;

  public currentUserRole: DataProviderUserRole;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    RoleTypeId: new FormControl(),
    RentalCompanyId: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(userRole: DataProviderUserRole) {
    this.currentUserRole= userRole;
    this.editForm.reset(userRole);

    this.active = userRole !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderUserRole> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentUserRole = Object.assign(
      this.currentUserRole,
      this.editForm.value
    );
    this.currentUserRole.AppUserId = this.AppUserId;
    console.log("new user role: "+this.currentUserRole.UserRoleId);
    console.log("AppUserId: ", this.currentUserRole.AppUserId);
    this.save.emit(this.currentUserRole);
    this.active = false;
  }

  public onCancel(e): void {
    e.preventDefault();
    this.closeForm();
  }

  public closeForm(): void {
    this.active = false;
    this.cancel.emit();
  }

}
