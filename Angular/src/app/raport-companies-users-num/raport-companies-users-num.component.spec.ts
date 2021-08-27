import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RaportCompaniesUsersNumComponent } from './raport-companies-users-num.component';

describe('RaportCompaniesUsersNumComponent', () => {
  let component: RaportCompaniesUsersNumComponent;
  let fixture: ComponentFixture<RaportCompaniesUsersNumComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RaportCompaniesUsersNumComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RaportCompaniesUsersNumComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
