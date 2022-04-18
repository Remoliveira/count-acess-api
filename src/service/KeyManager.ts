import urls from "../constants/AvailableSites"
import { instance } from "./AxiosInstance"

// interface KeyResponse {
//     namespace: string,

// }

class KeyManager {
    
    public async createRandomKey() {

        const response = await instance.get(`/create?namespace=${urls.TON}`)
        console.log(response)
    }
    

}

export default KeyManager