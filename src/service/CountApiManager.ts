import ICountApiManager from "../interface/ICountApiManager";
import IRequest from "../interface/IRequest";
import { instance } from "./AxiosInstance"


class CountApiManager implements ICountApiManager {
    
    public async increment(request: IRequest): Promise<void> {
        await instance.get(`/hit/${request.namespace}/${request.key}`)
    }
    
    public async getTotalAcces(request: IRequest): Promise<number> {
        const response = await instance.get(`/get/${request.namespace}/${request.key}`);
        
        return response.data.value
    }
}

export default CountApiManager