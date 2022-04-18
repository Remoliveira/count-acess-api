// import { expect } from 'chai';

import CountApiManager from "../service/CountApiManager";


const apiManager = new CountApiManager;

describe('Key Manager tests', async () =>{
    it('Create a key', async () => {
        const response = await apiManager.increment({namespace: 'ton.com.br', key: 'd52e6ce2-5cb6-4cbe-a255-b2b0d234d485'})
        console.log(response)
    })

    it.only('Get the value of a key', async () => {
        const response = await apiManager.getTotalAcces({namespace: 'ton.com.br', key: 'd52e6ce2-5cb6-4cbe-a255-b2b0d234d485'})
        console.log(response)
    })
})