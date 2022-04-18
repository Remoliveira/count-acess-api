// import { expect } from 'chai';

import KeyManager from "../service/KeyManager";

const keyManager = new KeyManager;

describe('Key Manager tests', async () =>{
    it.only('Create a key', async () => {
        const response = await keyManager.createRandomKey()
        console.log(response)
    })
})