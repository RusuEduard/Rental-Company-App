import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditFormAppuserComponent } from './edit-form-appuser.component';

describe('EditFormAppuserComponent', () => {
  let component: EditFormAppuserComponent;
  let fixture: ComponentFixture<EditFormAppuserComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditFormAppuserComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditFormAppuserComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
