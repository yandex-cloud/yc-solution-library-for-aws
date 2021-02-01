var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const documentClient = new AWS.DynamoDB.DocumentClient()
const tableName = "pets"

documentClient.scan({TableName: tableName}, function(err, data) {
    if (err) {
        console.error("Scan failed: ", JSON.stringify(err, null, 2));
    } else {
        console.log("All pets: ", JSON.stringify(data, null, 2));
    }
})