aws cloudformation update-stack --stack-name FoundationRepositoryRole \
                                --template-body file://foundation.yml \
                                --capabilities CAPABILITY_NAMED_IAM \
                                --parameters ParameterKey=BucketName,UsePreviousValue=true \
                                             ParameterKey=Repository,UsePreviousValue=true \
                                             ParameterKey=RoleName,UsePreviousValue=true
