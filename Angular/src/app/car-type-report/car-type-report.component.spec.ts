import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CarTypeReportComponent } from './car-type-report.component';

describe('CarTypeReportComponent', () => {
  let component: CarTypeReportComponent;
  let fixture: ComponentFixture<CarTypeReportComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CarTypeReportComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CarTypeReportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
