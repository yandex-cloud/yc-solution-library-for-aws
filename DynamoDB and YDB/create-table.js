var AWS = require("aws-sdk");

AWS.config.update({
    region: "us-west-2",
    endpoint: process.env["AWS_ENDPOINT"],
    accessKeyId: process.env["AWS_ACCESS_KEY_ID"],
    secretAccessKey: process.env["AWS_SECRET_ACCESS_KEY"],
});

const dynamodb = new AWS.DynamoDB();
const tableName = "pets"

dynamodb.createTable({
    AttributeDefinitions: [
        {AttributeName: "species", AttributeType: "S"},
        {AttributeName: "name", AttributeType: "S"},
    ],
    TableName: tableName,
    KeySchema: [
        {AttributeName: "species", KeyType: "HASH"},
        {AttributeName: "name", KeyType: "RANGE"},
    ],
    BillingMode: 'PAY_PER_REQUEST',
}, function(err, data) {
    if (err) {
        console.error("Unable to create table:", JSON.stringify(err, null, 2));
    } else {
        console.log("Table created:", JSON.stringify(data, null, 2));
    }
})
