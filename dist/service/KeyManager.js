"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const tslib_1 = require("tslib");
const AvailableSites_1 = (0, tslib_1.__importDefault)(require("constants/AvailableSites"));
const AxiosInstance_1 = require("./AxiosInstance");
class KeyManager {
    async createRandomKey() {
        const response = await AxiosInstance_1.instance.get(`/create?namespace=${AvailableSites_1.default.TON}`);
        console.log(response);
    }
}
exports.default = KeyManager;
