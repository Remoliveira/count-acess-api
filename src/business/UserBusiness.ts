import ICreateUser from "interface/ICreateUser";
import IUserRepository from "interface/IUserRepository";



class UserBusiness {
    private userRepository: IUserRepository;
    constructor(userRepository: IUserRepository) {
        this.userRepository = userRepository;
    }

    async createUser(item: ICreateUser): Promise<void> {
        await this.userRepository.createOne(item)
    }

    async getUser(email: string): Promise<ICreateUser> {
        const user =  await this.userRepository.getUser(email);

        return user;
    }

    
}

export default UserBusiness;