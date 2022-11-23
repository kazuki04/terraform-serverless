import { authenticationData, poolData, signInResult } from "../types/cognitoAuth"
import {
    AuthenticationDetails,
    CognitoUser,
    CognitoUserPool,
    CookieStorage
} from 'amazon-cognito-identity-js';

export default async function cognitoAuth(username: string, password: string): Promise<signInResult> {
    const poolData: poolData = {
        UserPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID as string,
        ClientId: process.env.NEXT_PUBLIC_CLIENT_ID as string,
        Storage: new CookieStorage({
            domain: process.env.NEXT_PUBLIC_DOMAIN as string,
            secure: false,
        }),
    };
    const userPool = new CognitoUserPool(poolData);
    let userData = {
        Username: username,
        Pool: userPool,
        Storage: poolData.Storage,
    };
    let cognitoUser = new CognitoUser(userData);
    let authenticationData: authenticationData = {
        Username: username,
        Password: password,
    };
    let authenticationDetails = new AuthenticationDetails(authenticationData);

    const signInResult: signInResult  = await new Promise((resolve) => {
        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: (result) =>
            resolve({
              success: true,
              session: result,
            }),
          onFailure: (err) =>
            resolve({
              success: false,
              err: err,
            }),
        });
    })

    return signInResult
};
