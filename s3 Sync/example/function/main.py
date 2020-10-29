import contextlib
import enum
import json
import os
import typing

import boto3
import botocore
#1

class CloudPlatform(enum.Enum):
    YANDEX = 1
    AWS = 2


class Environ(enum.Enum):
    AMAZON_BUCKET = "AMAZON_BUCKET"
    AMAZON_ACCESS_KEY_ID = "AMAZON_ACCESS_KEY_ID"
    AMAZON_SECRET_ACCESS_KEY = "AMAZON_SECRET_ACCESS_KEY"
    YANDEX_BUCKET = "YANDEX_BUCKET"
    YANDEX_ACCESS_KEY_ID = "YANDEX_ACCESS_KEY_ID"
    YANDEX_SECRET_ACCESS_KEY = "YANDEX_SECRET_ACCESS_KEY"


def mask(data):
    return '{}{}'.format(data[0:6], '*' * (len(data) - 6))


class StorageConfig:
    bucket_name: str
    access_key_id: str
    secret_access_key: str

    def __init__(self, platform: CloudPlatform, bucket_var: Environ, access_var: Environ, secret_var: Environ):
        self.bucket_name = self.__extract_value(platform, bucket_var)
        self.access_key_id = self.__extract_value(platform, access_var)
        self.secret_access_key = self.__extract_value(platform, secret_var)

    @staticmethod
    def __extract_value(platform: CloudPlatform, var: Environ) -> str:
        try:
            return os.environ[var.value]
        except KeyError:
            msg = 'Invalid configuration, {} must be set for {}'.format(var.value, platform)
            raise Exception(msg)

    def __repr__(self) -> str:
        return 'StorageConfig(bucket_name={}, access_key_id={}, secret_access_key={})'.format(
            self.bucket_name,
            self.access_key_id,
            mask(self.secret_access_key),
        )


class Config:
    yandex: StorageConfig
    aws: StorageConfig

    def __init__(self):
        self.yandex = StorageConfig(
            CloudPlatform.YANDEX,
            Environ.YANDEX_BUCKET,
            Environ.YANDEX_ACCESS_KEY_ID,
            Environ.YANDEX_SECRET_ACCESS_KEY,
        )
        self.aws = StorageConfig(
            CloudPlatform.AWS,
            Environ.AMAZON_BUCKET,
            Environ.AMAZON_ACCESS_KEY_ID,
            Environ.AMAZON_SECRET_ACCESS_KEY,
        )

    def __repr__(self) -> str:
        return 'Config(yandex={}, aws={})'.format(self.yandex, self.aws)


class ObjectReference:
    source_platform: CloudPlatform
    target_platform: CloudPlatform
    object_name: str

    def __init__(self, source: CloudPlatform, name: str):
        self.source_platform = source
        self.object_name = name
        if source == CloudPlatform.AWS:
            self.target_platform = CloudPlatform.YANDEX
        else:
            self.target_platform = CloudPlatform.AWS


def parse_event(event: typing.Dict) -> ObjectReference:
    if 'messages' in event and \
            len(event['messages']) > 0 and \
            'event_metadata' in event['messages'][0]:
        message = event['messages'][0]
        return ObjectReference(CloudPlatform.YANDEX, message['details']['object_id'])

    # TODO parse aws

    raise Exception('unknown payload: {}'.format(json.dumps(event)))


class SyncClient:
    config: Config

    def __init__(self, config: Config):
        self.config = config

        aws_session = boto3.session.Session(
            aws_access_key_id=config.aws.access_key_id,
            aws_secret_access_key=config.aws.secret_access_key,
        )
        yc_session = boto3.session.Session(
            aws_access_key_id=config.yandex.access_key_id,
            aws_secret_access_key=config.yandex.secret_access_key,
        )

        self.aws = aws_session.client('s3')
        self.yc = yc_session.client('s3', endpoint_url='https://storage.yandexcloud.net/')

    def sync(self, obj: ObjectReference) -> bool:
        if not self.__should_sync_to(obj):
            return False
        return self.__sync(obj)

    def __should_sync_to(self, obj: ObjectReference) -> bool:
        source_client, target_client = self.__clients(obj)
        source_bucket, target_bucket = self.__buckets(obj)

        print('checking if {}/{} exists in target provider {}'.format(target_bucket, obj.object_name,
                                                                      obj.target_platform))

        try:
            tgt_object = target_client.get_object(Bucket=target_bucket, Key=obj.object_name)
            # TODO check md5 for source and target
            print('{}/{} exists in {}'.format(target_bucket, obj.object_name, obj.target_platform))
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == "NoSuchKey":
                print('{}/{} does not exists in {}'.format(target_bucket, obj.object_name, obj.target_platform))
                return True
            else:
                raise e

        return False

    def __sync(self, obj: ObjectReference) -> bool:
        source_client, target_client = self.__clients(obj)
        source_bucket, target_bucket = self.__buckets(obj)

        print('copying {}/{} from {} to {}/{} in {}'.format(
            source_bucket,
            obj.object_name,
            obj.source_platform,
            target_bucket,
            obj.object_name,
            obj.target_platform,
        ))

        source_object = source_client.get_object(Bucket=source_bucket, Key=obj.object_name)
        with contextlib.closing(source_object['Body']) as body:
            # TODO copy attributes
            # TODO verify memory usage by syncing very large file with 256mb of memory
            target_client.upload_fileobj(body, Bucket=target_bucket, Key=obj.object_name)

        return True

    def __clients(self, obj):
        source = None
        target = None

        if obj.source_platform == CloudPlatform.YANDEX:
            source = self.yc
        elif obj.source_platform == CloudPlatform.AWS:
            source = self.aws

        if obj.target_platform == CloudPlatform.YANDEX:
            target = self.yc
        elif obj.target_platform == CloudPlatform.AWS:
            target = self.aws

        if not source or not target:
            raise Exception('unknown sync {} -> {}'.format(obj.source_platform, obj.target_platform))

        return source, target

    def __buckets(self, obj):
        source = None
        target = None

        if obj.source_platform == CloudPlatform.YANDEX:
            source = self.config.yandex.bucket_name
        elif obj.source_platform == CloudPlatform.AWS:
            source = self.config.aws.bucket_name

        if obj.target_platform == CloudPlatform.YANDEX:
            target = self.config.yandex.bucket_name
        elif obj.target_platform == CloudPlatform.AWS:
            target = self.config.aws.bucket_name

        if not source or not target:
            raise Exception('unknown sync {} -> {}'.format(obj.source_platform, obj.target_platform))

        return source, target


config = Config()
client = SyncClient(config)


def handler(event, context):
    print(config)
    object_ref = parse_event(event)
    result = client.sync(object_ref)
    return {
        'source': str(object_ref.source_platform),
        'target': str(object_ref.target_platform),
        'object_name': str(object_ref.object_name),
        'result': result,
    }
