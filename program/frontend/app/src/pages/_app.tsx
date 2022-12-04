import '../styles/globals.css';
import type {AppProps} from 'next/app';
import Head from 'next/head';
import {useEffect} from 'react';
import {redirectUnAuthenticatedUser} from '../api/cognitoAuth';

export default function App({Component, pageProps}: AppProps) {

    useEffect(() => {
        const pathname = window.location.pathname;

        if (pathname !== '/login' && pathname !== '/'){
            redirectUnAuthenticatedUser();
        }
    }, []);

    return (
        <>
            <Head>
                <title>Serverless App</title>
            </Head>
            <Component {...pageProps} />
        </>
    );
}
