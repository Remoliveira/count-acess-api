"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const tslib_1 = require("tslib");
const AxiosInstance_1 = require("./AxiosInstance");
class CountApiManager {
    increment(request) {
        return tslib_1.__awaiter(this, void 0, void 0, function* () {
            yield AxiosInstance_1.instance.get(`/hit/${request.namespace}/${request.key}`);
        });
    }
}
exports.default = CountApiManager;
