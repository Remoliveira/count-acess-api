"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class KeyManager {
    constructor() { }
    createRandomKey() {
        if (!KeyManager.instance) {
            KeyManager.instance = new KeyManager();
        }
        return KeyManager.instance;
    }
}
exports.default = KeyManager;
