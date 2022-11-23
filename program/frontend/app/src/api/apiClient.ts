import applyCaseMiddleware from 'axios-case-converter'
import axios from 'axios'

const apiClient = applyCaseMiddleware(
  axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_BASE_URL,
    responseType: 'json',
    headers: {
      'Content-Type': 'application/json',
    },
    withCredentials: true,
  }),
)

export default apiClient
