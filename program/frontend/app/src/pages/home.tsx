import {AxiosResponse} from 'axios';
import {useState, useEffect} from 'react';
import apiClient from '../api/apiClient';
import {getCognitoAccessToken} from '../api/cognitoAuth';
import {Article} from '../types/article';
import styles from '../styles/Index.module.css';

export default function Home() {
    const [articles, setArticles] = useState([]);

    const fetchArticles = async () => {
        const authToken = getCognitoAccessToken();

        try {
            apiClient.interceptors;
            const response: AxiosResponse = await apiClient.get(
                '/api/v1/articles',
                {
                    headers: {
                        Authorization: authToken
                    }
                }
            );

            return response;
        } catch (e: any) {
            return {
                data: []
            };
        }
    };

    useEffect(() => {
        (async() => {
            const response = await fetchArticles();
 
            if (response.data.length !== 0) {
                setArticles(response.data.articles.Items);
            }
        })();
      }, []);

    return (
        <div>
            <h1>Home</h1> 
            {
                articles.map((article: Article, index) => 
                    <div key={index} className={styles.article}>
                        <h2>Title: {article.Title}</h2>
                        <div>
                            <h3>Content:</h3>
                            <p>{article.Title}</p>
                        </div>
                    </div>
                )
            }
            {
                articles.length > 0 &&
                <h2>There are no articles.</h2>
            }
        </div>
    );
}
