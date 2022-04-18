import IRequest from "./IRequest";

interface ICountApiManager {
    increment(request: IRequest): Promise<void>;

    getTotalAcces(request: IRequest): Promise<number>;
}

export default ICountApiManager;