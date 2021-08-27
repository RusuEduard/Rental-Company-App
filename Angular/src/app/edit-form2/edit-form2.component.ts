import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderRentalCompany } from '../data/rental-company.model';

@Component({
  selector: 'kendo-grid-edit-form2',
  templateUrl: './edit-form2.component.html',
  styleUrls: ['./edit-form2.component.css']
})
export class EditForm2Component {

  public currentRentalCompany: DataProviderRentalCompany;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Description: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set model(rentalCompany: DataProviderRentalCompany) {
    this.currentRentalCompany = rentalCompany;
    this.editForm.reset(rentalCompany);

    this.active = rentalCompany !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRentalCompany> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentRentalCompany = Object.assign(
      this.currentRentalCompany,
      this.editForm.value
    );
    console.log("new rental company: " + this.currentRentalCompany.RentalCompanyId);
    this.save.emit(this.currentRentalCompany);
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