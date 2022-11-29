import {
    authenticationData,
    poolData,
    signInResult,
}
from '../types/cognitoAuth';
import {
    AuthenticationDetails,
    CognitoUser,
    CookieStorage,
    CognitoUserPool,
    CognitoUserSession,
} from 'amazon-cognito-identity-js';

export function getPoolData(): poolData {
    const poolData: poolData = {
        UserPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID as string,
        ClientId: process.env.NEXT_PUBLIC_CLIENT_ID as string,
        Storage: new CookieStorage({
            domain: process.env.NEXT_PUBLIC_DOMAIN as string,
            secure: false,
        }),
    };

    return poolData;
}

export async function cognitoAuth(username: string, password: string): Promise<signInResult> {
    const poolData: poolData = getPoolData();
    
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
    });

    return signInResult;
};

export function getCognitoUserSession(): CognitoUserSession| null {
    const poolData: poolData = getPoolData();

    const userPool = new CognitoUserPool(poolData);
    const cognitoUser = userPool.getCurrentUser();

    if (!cognitoUser) {
        return null;
    }

    let userSession = null;
    cognitoUser.getSession((err: Error, session: CognitoUserSession | null) => {
        if (session != null) {
            userSession = session;
        }
    });

    return userSession;
}

export function getCognitoAccessToken(): string | null {
    const userSession = getCognitoUserSession();

    let accessToken = null;
    if (userSession != null) {
        accessToken = userSession.getAccessToken().getJwtToken();
    }

    return accessToken;
}

export function redirectUnAuthenticatedUser(): void {
    const poolData: poolData = getPoolData();

    const userPool = new CognitoUserPool(poolData);
    const cognitoUser = userPool.getCurrentUser();


    if (!cognitoUser) {
        window.location.href = '/login';
        return;
    }

    cognitoUser.getSession(function (err: Error | null, session: null | CognitoUserSession ) {
        if (session !== null && session.isValid()) {
            window.location.href = '/login';
        }
    });

};
