import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LaunchReportComponent } from './launch-report.component';

describe('LaunchReportComponent', () => {
  let component: LaunchReportComponent;
  let fixture: ComponentFixture<LaunchReportComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LaunchReportComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LaunchReportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
