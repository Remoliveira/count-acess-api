import UserBusiness from "business/UserBusiness";
import UserRepository from "../repositories/UserRepository";



export async function getUser(event: any): Promise<any> {
  try {
    const { email } = event.params;
    
    const userRepository = new UserRepository()

    const userBusiness = new UserBusiness(userRepository)
    const user =  await userBusiness.getUser(email)

    return {
              statusCode: 200,
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                message:  user
            }),
    }
  } catch (error) {
    return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message:  'Error on getting a user'
      }),
}
  }
}



