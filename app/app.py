import os

def handler(event, context):
    return f'Hello from AWS Lambda version {os.environ["APP_VERSION"]}'
