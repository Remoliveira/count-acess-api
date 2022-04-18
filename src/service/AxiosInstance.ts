import axios from "axios";

export const instance = axios.create({
    baseURL: 'https://api.countapi.xyz/',
    timeout: 1000,
    headers: {'X-Custom-Header': 'foobar'}
  });