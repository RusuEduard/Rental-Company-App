import { Component, Input, OnInit, Output, EventEmitter} from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { DataProviderAppUser } from '../data/app-user.model';
import { DataProviderRent } from '../data/rent.model';
import {  DataProviderCarAgency} from '../data/car-agency.model'

@Component({
  selector: 'app-edit-form-rent',
  templateUrl: './edit-form-rent.component.html',
  styleUrls: ['./edit-form-rent.component.css']
})

export class EditFormRentComponent implements OnInit {
  @Input() AppUserList: any;
  @Input() CarAgencyList: any;

  public currentRent: DataProviderRent;

  public active = false;
  public editForm: FormGroup = new FormGroup({

    AppUserId: new FormControl(),
    CarAgencyId: new FormControl(),
    DateFrom: new FormControl(),
    DateTo: new FormControl(),
  });

  @Input() public isNew = false;

  @Input() public set appuser(rent: DataProviderRent){
    
    this.currentRent = rent;
    this.editForm.reset(rent);
    this.active = rent !== undefined;
  }

  @Output() cancel: EventEmitter<any> = new EventEmitter();
  @Output() save: EventEmitter<DataProviderRent> = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
  }
  public onSave(e): void {
    e.preventDefault();
    this.currentRent = Object.assign(
      this.currentRent,
      this.editForm.value
    );
    this.save.emit(this.currentRent);
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
