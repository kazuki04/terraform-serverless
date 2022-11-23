import { CognitoUserSession, CookieStorage } from 'amazon-cognito-identity-js';

export type poolData = {
    UserPoolId: string
    ClientId: string
    Storage: CookieStorage
}

export type authenticationData = {
    Username: string
    Password: string
}

export type signInResult = {
    success: boolean
    session?: CognitoUserSession
    err?: any
}
