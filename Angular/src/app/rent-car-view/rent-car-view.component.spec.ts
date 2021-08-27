import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RentCarViewComponent } from './rent-car-view.component';

describe('RentCarViewComponent', () => {
  let component: RentCarViewComponent;
  let fixture: ComponentFixture<RentCarViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RentCarViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RentCarViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
