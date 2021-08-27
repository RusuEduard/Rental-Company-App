import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CarTypeViewComponent } from './car-type-view.component';

describe('CarTypeViewComponent', () => {
  let component: CarTypeViewComponent;
  let fixture: ComponentFixture<CarTypeViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CarTypeViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CarTypeViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
