var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const documentClient = new AWS.DynamoDB.DocumentClient()
const tableName = "pets"

documentClient.query({
    TableName: tableName,
    ConsistentRead: true,
    KeyConditionExpression: "species = :s",
    ExpressionAttributeValues: {":s": "cat"},
}, function(err, data) {
    if (err) {
        console.error("Query failed: ", JSON.stringify(err, null, 2));
    } else {
        console.log("Query result: ", JSON.stringify(data, null, 2));
    }
})