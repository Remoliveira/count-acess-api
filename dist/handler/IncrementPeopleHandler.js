"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.incrementPeople = void 0;
const tslib_1 = require("tslib");
const IncrementPeopleBusiness_1 = tslib_1.__importDefault(require("../business/IncrementPeopleBusiness"));
const CountApiManager_1 = tslib_1.__importDefault(require("../service/CountApiManager"));
function incrementPeople(event) {
    return tslib_1.__awaiter(this, void 0, void 0, function* () {
        try {
            const { namespace, key } = event;
            const countApiManager = new CountApiManager_1.default();
            const incrementPeopleBusiness = new IncrementPeopleBusiness_1.default(countApiManager);
            yield incrementPeopleBusiness.increment({ namespace, key });
            return {
                statusCode: 200,
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: 'Incremented one'
                }),
            };
        }
        catch (error) {
            return {
                statusCode: 400,
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: 'Error on incrementing one'
                }),
            };
        }
    });
}
exports.incrementPeople = incrementPeople;
