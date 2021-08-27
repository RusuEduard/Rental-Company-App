import { Component, Input } from "@angular/core";
import {
  FilterService,
  BaseFilterCellComponent,
} from "@progress/kendo-angular-grid";


@Component({
  selector: 'app-dropdownlist-rentalco',
  templateUrl: './dropdownlist-rentalco.component.html',
  styleUrls: ['./dropdownlist-rentalco.component.css']
})
export class DropdownlistRentalcoComponent extends BaseFilterCellComponent {
  public get selectedValue(): any {
    const filter = this.filterByField(this.valueField);
    return filter ? filter.value : null;
  }

  @Input() public filter: any;
  @Input() public data: any[];
  @Input() public textField: string;
  @Input() public valueField: string;

  public get defaultItem(): any {
    return {
      [this.textField]: "Select a rental company",
      [this.valueField]: null,
    };
  }

  constructor(filterService: FilterService) {
    super(filterService);
  }

  public onChange(value: any): void {
    this.applyFilter(
      value === null // value of the default item
        ? this.removeFilter(this.valueField) // remove the filter
        : this.updateFilter({
            // add a filter for the field with the value
            field: this.valueField,
            operator: "eq",
            value: value,
          })
    ); // update the root filter
  }

}
