"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.instance = void 0;
const tslib_1 = require("tslib");
const axios_1 = (0, tslib_1.__importDefault)(require("axios"));
exports.instance = axios_1.default.create({
    baseURL: 'https://api.countapi.xyz/',
    timeout: 1000,
    headers: { 'X-Custom-Header': 'foobar' }
});
