import KeysBusiness from "../business/KeysBusiness";
import CountApiManager from "../service/CountApiManager";

export async function incrementPeople(event: any): Promise<any> {
  try {
    const { namespace, key } = event.body;
    
    const countApiManager = new CountApiManager()

    const keysBusiness = new KeysBusiness(countApiManager);
    await keysBusiness.increment({ namespace, key })

    return {
              statusCode: 200,
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                message:  'Incremented one'
            }),
    }
  } catch (error) {
    return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message:  'Error on incrementing one'
      }),
}
  }
}



