import Link from 'next/link';
import {useRouter} from 'next/router';
import {ChangeEvent, useState} from 'react';
import {cognitoAuth} from '../api/cognitoAuth';
import {signInResult} from '../types/cognitoAuth';
import styles from '../styles/Login.module.css';

export default function Login() {
    const router = useRouter();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleChangeEmail = (e: ChangeEvent<HTMLInputElement>) => {
        setEmail(e.target.value);
    };

    const handleChangePassword = (e: ChangeEvent<HTMLInputElement>) => {
        setPassword(e.target.value);
    };

    const handleSingIn= async () => {
        const result: signInResult = await cognitoAuth(email, password);
        if (result.success) {
            router.push('/home');
        } else {
            alert('Error: Failed Sign in');
        };
    };

    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <h1>Sign In</h1>
                <form id="loginForm">
                    <input type="text" id="emailInputLogin" className={styles.input} placeholder="Email" value={email} onChange={handleChangeEmail} required />
                    <input type="password" id="passwordInputLogin" className={styles.input} placeholder="Password" pattern=".*" value={password} onChange={handleChangePassword} required />
                    <button type="button" className={styles.input} onClick={handleSingIn}>Sign in</button>
                </form>
                <Link href='/'>
                    <button className={styles.back_home_btn}>Back home</button>
                </Link>
            </main>
        </div>
    );
}
