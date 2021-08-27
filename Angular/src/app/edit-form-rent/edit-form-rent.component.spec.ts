import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFormRentComponent } from './edit-form-rent.component';

describe('EditFormRentComponent', () => {
  let component: EditFormRentComponent;
  let fixture: ComponentFixture<EditFormRentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFormRentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFormRentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
