import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DropdownlistRoletypesComponent } from './dropdownlist-roletypes.component';

describe('DropdownlistRoletypesComponent', () => {
  let component: DropdownlistRoletypesComponent;
  let fixture: ComponentFixture<DropdownlistRoletypesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DropdownlistRoletypesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DropdownlistRoletypesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
