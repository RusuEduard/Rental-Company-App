import { Component, Input, OnInit, Output,EventEmitter } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderCar } from '../data/car.model';
import { ModelDataResult } from '../data/model-data-result';
import { DataProviderRentCar } from '../data/rent-car.model';

@Component({
  selector: 'app-edit-form-rent-car',
  templateUrl: './edit-form-rent-car.component.html',
  styleUrls: ['./edit-form-rent-car.component.css']
})

export class EditFormRentCarComponent implements OnInit {
  @Input() CarList : any;

  public currentRentCar: DataProviderRentCar;
  public active = false;

  public editForm: FormGroup = new FormGroup({

    Model: new FormControl(),
    CarId: new FormControl()
  })

  @Input() public isNew = false;
  @Input() public id : any;
  @Input() public set model(rentcar: DataProviderRentCar){

    this.currentRentCar = rentcar;
    this.editForm.reset(rentcar);
    this.active = rentcar !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRentCar> = new EventEmitter();
  constructor() { }

  ngOnInit(): void {
  }

  public onSave(e): void {

    e.preventDefault();

    this.currentRentCar = Object.assign(
      this.currentRentCar,
      this.editForm.value
    );

    this.currentRentCar.RentId = this.id;
    this.save.emit(this.currentRentCar);
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
