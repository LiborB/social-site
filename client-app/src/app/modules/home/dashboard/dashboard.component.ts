import {Component, Input, OnInit} from '@angular/core';
import {UserService} from "../../../core/services/user.service";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  @Input() test: string = ""
  constructor(
    private userService: UserService,
  ) { }

  ngOnInit(): void {
    this.userService.getAccountDetails().subscribe(value => {
  this.test = value
    })
  }

}
