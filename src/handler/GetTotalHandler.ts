import KeysBusiness from "../business/KeysBusiness";
import CountApiManager from "../service/CountApiManager";

export async function getTotalHandler(event: any): Promise<any> {
  try {
    const { namespace, key } = event.params;
    
    const countApiManager = new CountApiManager()

    const keysBusiness = new KeysBusiness(countApiManager);
    const total =  await keysBusiness.getTotalAcessOfAKey({ namespace, key })

    return {
              statusCode: 200,
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                message:  `Total value is: ${total}`
            }),
    }
  } catch (error) {
    return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message:  'Error on geting the value of a key'
      }),
}
  }
}



