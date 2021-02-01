var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const documentClient = new AWS.DynamoDB.DocumentClient()
const tableName = "pets"

documentClient.update({
    TableName: tableName,
    Key: {
        "species": "cat",
        "name": "Tom",
    },
    ExpressionAttributeValues: {":discount": 4},
    UpdateExpression: "SET price = price - :discount",
    ReturnValues: "ALL_NEW",
}, function(err, data) {
    if (err) {
        console.error("Update failed: ", JSON.stringify(err, null, 2));
    } else {
        console.log("Update result: ", JSON.stringify(data, null, 2));
    }
})