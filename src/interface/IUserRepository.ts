import ICreateUser from "./ICreateUser";

interface IUserRepository{
    createOne(item: ICreateUser): Promise<void>;

    getUser(email: string): Promise<ICreateUser>

}

export default IUserRepository;