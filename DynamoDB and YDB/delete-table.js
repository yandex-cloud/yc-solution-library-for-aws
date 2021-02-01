var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const dynamodb = new AWS.DynamoDB();
const tableName = "pets"

dynamodb.deleteTable({
    TableName: tableName,
}, function(err, data) {
    if (err) {
        console.error("Delete table failed:", JSON.stringify(err, null, 2));
    } else {
        console.log("Table deleted:", JSON.stringify(data, null, 2));
    }
})
