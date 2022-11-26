import os
import json
import botocore
import boto3
import logging
import uuid

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ["DDB_TABLE_NAME"])

def lambda_handler(event, context):
    logger.info(event)
    json_data = json.loads(event['body'])

    try:
        table.put_item(
            Item={
                'ArticleId': str(uuid.uuid1()),
                'Title': json_data['title'],
                'Content': json_data['content'],
            }
        )
    except botocore.exceptions.ClientError as err:
        if err.response['Error']['Code'] == 'InternalServerError':
            logger.error('An error occurred on the server side.')
            logger.error('Error Message: {}'.format(err.response['Error']['Message']))
            logger.error('Request ID: {}'.format(err.response['ResponseMetadata']['RequestId']))
            logger.error('Http code: {}'.format(err.response['ResponseMetadata']['HTTPStatusCode']))
        else:
            raise err

    json_region = os.environ['AWS_REGION']
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region
        })
    }
