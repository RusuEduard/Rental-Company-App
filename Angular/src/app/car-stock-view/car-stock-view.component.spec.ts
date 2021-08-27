import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CarStockViewComponent } from './car-stock-view.component';

describe('CarStockViewComponent', () => {
  let component: CarStockViewComponent;
  let fixture: ComponentFixture<CarStockViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CarStockViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CarStockViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
