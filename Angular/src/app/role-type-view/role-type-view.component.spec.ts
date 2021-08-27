import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RoleTypeViewComponent } from './role-type-view.component';

describe('RoleTypeViewComponent', () => {
  let component: RoleTypeViewComponent;
  let fixture: ComponentFixture<RoleTypeViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RoleTypeViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RoleTypeViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
