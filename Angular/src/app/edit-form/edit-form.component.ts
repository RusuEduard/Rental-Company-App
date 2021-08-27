import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { DataProviderCar } from '../data/car.model';

@Component({
  selector: 'kendo-grid-edit-form',
  styleUrls: ['./edit-form.component.css'],
  templateUrl: './edit-form.component.html',
})
export class EditFormComponent {
  @Input() CarTypesList: any;

  public currentCar: DataProviderCar;

  public active = false;
  public editForm: FormGroup = new FormGroup({
    Model: new FormControl(),
    Manufacturer: new FormControl(),
    CarTypeId: new FormControl(),
   
  });

  @Input() public isNew = false;

  @Input() public set model(car: DataProviderCar) {
    this.currentCar = car;
    this.editForm.reset(car);

    this.active = car !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderCar> = new EventEmitter();

  public onSave(e): void {
    e.preventDefault();
    this.currentCar = Object.assign(
      this.currentCar,
      this.editForm.value
    );
    console.log("new car: "+this.currentCar.CarTypeId);
    this.save.emit(this.currentCar);
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
