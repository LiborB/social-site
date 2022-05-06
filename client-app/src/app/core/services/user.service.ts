import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {ACCOUNT_BASE_URL} from "../constants";

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private httpClient: HttpClient) {

  }

  getAccountDetails() {
    return this.httpClient.get<string>(`${ACCOUNT_BASE_URL}`)
  }
}
