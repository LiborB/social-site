import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { TopNavComponent } from './core/components/top-nav/top-nav.component';
import {JwtHelperService, JwtModule} from "@auth0/angular-jwt";
import {HTTP_INTERCEPTORS, HttpClientModule, HttpRequest} from "@angular/common/http";
import {AuthInterceptor} from "./core/interceptors/auth.interceptor";

export function tokenGetter() {
  return localStorage.getItem("access_token");
}

@NgModule({
  declarations: [
    AppComponent,
    TopNavComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    JwtModule.forRoot({
      config: {
        tokenGetter: tokenGetter,
        allowedDomains: ["localhost:3001"],
      },
    }),
    HttpClientModule
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    },
    ],
  bootstrap: [AppComponent]
})
export class AppModule { }
