import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DropDownListFilterComponent } from './dropdownlist-filter.component';

describe('DropdownlistFilterComponent', () => {
  let component: DropDownListFilterComponent;
  let fixture: ComponentFixture<DropDownListFilterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DropDownListFilterComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DropDownListFilterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
