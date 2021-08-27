import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DropdownlistRentalcoComponent } from './dropdownlist-rentalco.component';

describe('DropdownlistRentalcoComponent', () => {
  let component: DropdownlistRentalcoComponent;
  let fixture: ComponentFixture<DropdownlistRentalcoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DropdownlistRentalcoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DropdownlistRentalcoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
