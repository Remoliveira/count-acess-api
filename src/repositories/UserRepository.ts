import ICreateUser from "../interface/ICreateUser";
import IUserRepository from "interface/IUserRepository";

const AWS = require("aws-sdk"); 

class UserRepository implements IUserRepository {
    
    private documentClient: any;

    constructor() {
        this.documentClient = new AWS.DynamoDB.DocumentClient();
    }

    public async createOne(item: ICreateUser): Promise<void> {
        
        await this.documentClient.put({
            TableName: "Users",
            Item: item
        }).promise();
    }
    
    public async getUser(email: string): Promise<ICreateUser> {
        const user = await this.documentClient.get({
            TableName: "Users",
            Key: {
                "email": email,
              }
        }) 

        return user;
    }
}

export default UserRepository