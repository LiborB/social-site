import {HTTP_INTERCEPTORS, HttpEvent, HttpErrorResponse, HttpClient} from '@angular/common/http';
import {Injectable, Injector} from '@angular/core';
import { HttpInterceptor, HttpHandler, HttpRequest } from '@angular/common/http';
import {BehaviorSubject, map, Observable, throwError} from 'rxjs';
import { catchError, filter, switchMap, take } from 'rxjs/operators';
import {JwtHelperService} from "@auth0/angular-jwt";
import {Router} from "@angular/router";
import {environment} from "../../../environments/environment";

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private jwtHelperService: JwtHelperService, private injector: Injector, private router: Router) {
  }

  intercept(req: HttpRequest<any>, next: HttpHandler) {
    return next.handle(req).pipe(catchError(async error => {
      if (error instanceof HttpErrorResponse) {
        if (error.status === 401) {
          const isExpired = this.jwtHelperService.isTokenExpired();
          if (isExpired) {
            const http = this.injector.get(HttpClient);

            http.post<{
              token: string,
              refreshToken: string
            }>(`${environment.accountBaseUrl}/auth`, {
              refreshToken: this.jwtHelperService.tokenGetter() ?? ""
            }).subscribe({
              next: ({token, refreshToken}) => {
                localStorage.setItem('access_token', token);
                localStorage.setItem('refresh_token', refreshToken);
                return next.handle(req);
              },
              error: async () => {
                await this.router.navigate(['/login']);
                return next.handle(req);
              }
            })
          }
        } else {
          return error
        }
      }
      else {
        return error
      }
    }))
  }
}
