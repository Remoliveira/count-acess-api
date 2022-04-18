import UserBusiness from "business/UserBusiness";
import UserRepository from "../repositories/UserRepository";



export async function createUser(event: any): Promise<any> {
  try {
    const { email, password, namespace, key } = event.body;
    
    const userRepository = new UserRepository()

    const userBusiness = new UserBusiness(userRepository)
    await userBusiness.createUser({ namespace, key, email, password })

    return {
              statusCode: 200,
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                message:  'User Created'
            }),
    }
  } catch (error) {
    return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message:  'Error on creating a user'
      }),
}
  }
}



