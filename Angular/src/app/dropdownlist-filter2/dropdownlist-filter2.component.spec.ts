import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DropdownlistFilter2Component } from './dropdownlist-filter2.component';

describe('DropdownlistFilter2Component', () => {
  let component: DropdownlistFilter2Component;
  let fixture: ComponentFixture<DropdownlistFilter2Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DropdownlistFilter2Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DropdownlistFilter2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
