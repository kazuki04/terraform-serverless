import {AxiosResponse} from 'axios';
import {ChangeEvent, useState} from 'react';
import apiClient from '../api/apiClient';
import {getCognitoAccessToken} from '../api/cognitoAuth';
import styles from '../styles/Home.module.css';

export default function Post() {
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const authToken = getCognitoAccessToken();

    const postArticle = async () => {
        try {
            apiClient.interceptors;
            const response: AxiosResponse = await apiClient.post(
                '/api/v1/article',
                { 
                    title: title,
                    content: content,
                },
                {
                    headers: {
                        Authorization: authToken
                    }
                }
            );

            return {
                status: response.status ?? 200,
                success: true,
            };
        } catch (e: any) {
            console.log(e);
            // return {
            //     status: e.response.status === 0 ? 500 : e.response.status,
            //     success: false,
            // }
        }
    };

    const handleChangeTitle = (e: ChangeEvent<HTMLInputElement>) => {
        setTitle(e.target.value);
    };

    const handleChangeContent = (e: ChangeEvent<HTMLTextAreaElement>) => {
        setContent(e.target.value);
    };

    return (
        <div className={styles.container}>
            <main className={styles.main}>
                <form>
                    <label htmlFor="first" className={styles.input_label}>Title:</label>
                    <input type="text" id="title" name="title" onChange={handleChangeTitle} value={title} />
                    <label htmlFor="last" className={styles.input_label}>Content:</label>
                    <textarea id="content" name="content" className={styles.content} onChange={handleChangeContent} value={content}>
                    </textarea>
                    <button type="button" className={styles.submit_button} onClick={postArticle}>Submit</button>
                </form>
            </main>
        </div>
    );
}
