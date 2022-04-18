import axios from "axios";

export const instance = axios.create({
    baseURL: 'https://api.countapi.xyz/',
    timeout: 40000,
  });