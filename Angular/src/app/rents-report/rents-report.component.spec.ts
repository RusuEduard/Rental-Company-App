import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentsReportComponent } from './rents-report.component';

describe('RentsReportComponent', () => {
  let component: RentsReportComponent;
  let fixture: ComponentFixture<RentsReportComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentsReportComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentsReportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
