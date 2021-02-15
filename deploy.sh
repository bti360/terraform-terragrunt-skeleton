aws --profile bti360 cloudformation deploy \
  --template-file init/admin/init-admin-account.cf.yml \
  --stack-name terraform-bootstrap \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    StateBucketName=bti360-terraform-state \
    StateLogBucketName=bti360-terraform-state-logs \
    LockTableName=bti360-terraform-state-locks
