"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const tslib_1 = require("tslib");
const KeyManager_1 = (0, tslib_1.__importDefault)(require("service/KeyManager"));
const keyManager = new KeyManager_1.default;
describe('Key Manager tests', async () => {
    it.only('Create a key', async () => {
        const response = await keyManager.createRandomKey();
        console.log(response);
    });
});
