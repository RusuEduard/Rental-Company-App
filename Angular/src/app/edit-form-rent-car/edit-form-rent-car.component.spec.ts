import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFormRentCarComponent } from './edit-form-rent-car.component';

describe('EditFormRentCarComponent', () => {
  let component: EditFormRentCarComponent;
  let fixture: ComponentFixture<EditFormRentCarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFormRentCarComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFormRentCarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
