var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const documentClient = new AWS.DynamoDB.DocumentClient()
const tableName = "pets"

documentClient.batchWrite({
    ReturnConsumedCapacity: "TOTAL",
    RequestItems: {
        [tableName]: [
            {
                PutRequest: {
                    Item: {
                        "species": "cat",
                        "name": "Tom",
                        "color": "black",
                        "sex": "M",
                        "price": 10,
                    }
                },
            },
            {
                PutRequest: {
                    Item: {
                        "species": "cat",
                        "name": "Mamba",
                        "color": "white",
                        "sex": "F",
                        "price": 12,
                    }
                },
            },
            {
                PutRequest: {
                    Item: {
                        "species": "cat",
                        "name": "Persimon",
                        "color": "red",
                        "sex": "F",
                        "price": 14,
                    }
                },
            },
            {
                PutRequest: {
                    Item: {
                        "species": "dog",
                        "name": "Rex",
                        "color": "brown",
                        "sex": "M",
                        "price": 22,
                    }
                },
            },
        ]
    }
}, function(err, data) {
    if (err) {
        console.error("Data load failed:", JSON.stringify(err, null, 2));
    } else {
        console.log("Data load complete: ", JSON.stringify(data, null, 2));
    }
})
