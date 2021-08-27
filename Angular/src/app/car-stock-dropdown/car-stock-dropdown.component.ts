import { Component, Input } from "@angular/core";
import {
  FilterService,
  BaseFilterCellComponent,
} from "@progress/kendo-angular-grid";

@Component({
  selector: 'app-car-stock-dropdown',
  templateUrl: './car-stock-dropdown.component.html',
  styleUrls: ['./car-stock-dropdown.component.css']
})
export class CarStockDropdownComponent extends BaseFilterCellComponent {

  public get selectedValue(): any {
    const filter = this.filterByField(this.valueField);
    return filter ? filter.value : null;
  
  }
  //public selectedValue:any = null;

  @Input() public filter: any;
  @Input() public data: any[];
  @Input() public textField: string;
  @Input() public valueField: string;

  public get defaultItem(): any {
    return {
      [this.textField]: "Choose ",
      [this.valueField]: null,
    };
  }

  constructor(filterService: FilterService) {
    super(filterService);
    console.log(this.data);

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

    console.log(value);
    if(this.data &&  this.data[0]){
     // this.selectedValue = this.data[0][this.valueField];
    }
  }

}
