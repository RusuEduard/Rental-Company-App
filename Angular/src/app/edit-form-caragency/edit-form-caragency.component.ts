import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderCarAgency } from '../data/car-agency.model';

@Component({
  selector: 'app-edit-form-caragency',
  templateUrl: './edit-form-caragency.component.html',
  styleUrls: ['./edit-form-caragency.component.css']
})
export class EditFormCaragencyComponent {

  @Input() rentalCompanyList: any;
  @Input() RentalCompanyId: string;

  public currentCarAgency: DataProviderCarAgency;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Address: new FormControl()
  });

  @Input() public isNew = false;

  @Input() public set model(carAgency: DataProviderCarAgency) {
    this.currentCarAgency= carAgency;
    this.editForm.reset(carAgency);

    this.active = carAgency !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderCarAgency> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentCarAgency = Object.assign(
      this.currentCarAgency,
      this.editForm.value
    );
    this.currentCarAgency.RentalCompanyId = this.RentalCompanyId;
    this.save.emit(this.currentCarAgency);
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
