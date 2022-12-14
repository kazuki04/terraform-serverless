import {useRouter} from 'next/router';
import styles from '../styles/Home.module.css';

export default function Top() {
    const router = useRouter();

    const handleClickLoginButton = () => {
        router.push('/login');
    };

    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <h1>Top page</h1>
                <button onClick={handleClickLoginButton }>Sign in</button>
            </main>
        </div>
    );
}
