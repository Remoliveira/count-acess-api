"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const tslib_1 = require("tslib");
class IncrementPeopleBusiness {
    constructor(countManager) {
        this.countManager = countManager;
    }
    increment(request) {
        return tslib_1.__awaiter(this, void 0, void 0, function* () {
            yield this.countManager.increment(request);
        });
    }
}
exports.default = IncrementPeopleBusiness;
