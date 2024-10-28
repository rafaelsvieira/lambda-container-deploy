import os

def handler(event, _):
    print(event)
    return f'Hello from AWS Lambda. Version: {os.environ["APP_VERSION"]}.'
