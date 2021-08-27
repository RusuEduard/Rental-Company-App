import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFormCaragencyComponent } from './edit-form-caragency.component';

describe('EditFormCaragencyComponent', () => {
  let component: EditFormCaragencyComponent;
  let fixture: ComponentFixture<EditFormCaragencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFormCaragencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFormCaragencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
