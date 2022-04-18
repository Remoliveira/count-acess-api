import ICountApiManager from "../interface/ICountApiManager";
import IRequest from "../interface/IRequest";


class KeysBusiness {
    private countManager: ICountApiManager;
    constructor(countManager: ICountApiManager) {
        this.countManager = countManager;
    }

    async increment(request: IRequest): Promise<void> {
        await this.countManager.increment(request)
    }

    async getTotalAcessOfAKey(request: IRequest): Promise<number> {
        return await this.countManager.getTotalAcces(request);
    }
}

export default KeysBusiness;