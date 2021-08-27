import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditForm2Component } from './edit-form2.component';

describe('EditForm2Component', () => {
  let component: EditForm2Component;
  let fixture: ComponentFixture<EditForm2Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditForm2Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditForm2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
