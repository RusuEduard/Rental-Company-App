import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CarStockDropdownComponent } from './car-stock-dropdown.component';

describe('CarStockDropdownComponent', () => {
  let component: CarStockDropdownComponent;
  let fixture: ComponentFixture<CarStockDropdownComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CarStockDropdownComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CarStockDropdownComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
