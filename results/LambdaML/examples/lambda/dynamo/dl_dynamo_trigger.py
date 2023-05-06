import boto3
import json

from storage import DynamoTable, S3Storage
from storage.dynamo import dynamo_operator


def handler(event, context):

    function_name = "lambda_core"

    # dataset setting
    dataset_name = 'cifar10'
    data_bucket = "cifar10dataset"
    n_features = 32 * 32
    n_classes = 10
    tmp_table_name = "tmp-params"
    merged_table_name = "merged-params"
    cp_bucket = "cp-model"
    key_col = "key"

    # training setting
    model = "mobilenet"     # mobilenet or resnet
    optim = "grad_avg"  # grad_avg or model_avg
    sync_mode = "reduce"    # async, reduce or reduce_scatter
    n_workers = 10

    # hyper-parameters
    lr = 0.01
    batch_size = 256
    n_epochs = 5
    start_epoch = 0
    run_epochs = 3

    # clear dynamodb table
    s3_storage = S3Storage()
    s3_storage.clear(cp_bucket)
    dynamo_client = dynamo_operator.get_client()
    tmp_tb = DynamoTable(dynamo_client, tmp_table_name)
    merged_tb = DynamoTable(dynamo_client, tmp_table_name)
    tmp_tb.clear(key_col)
    merged_tb.clear(key_col)

    # lambda payload
    payload = dict()
    payload['dataset'] = dataset_name
    payload['data_bucket'] = data_bucket
    payload['n_features'] = n_features
    payload['n_classes'] = n_classes
    payload['n_workers'] = n_workers
    payload['tmp_table_name'] = tmp_table_name
    payload['merged_table_name'] = merged_table_name
    payload['key_col'] = key_col
    payload['cp_bucket'] = cp_bucket
    payload['model'] = model
    payload['optim'] = optim
    payload['sync_mode'] = sync_mode
    payload['lr'] = lr
    payload['batch_size'] = batch_size
    payload['n_epochs'] = n_epochs
    payload['start_epoch'] = start_epoch
    payload['run_epochs'] = run_epochs
    payload['function_name'] = function_name

    # invoke functions
    lambda_client = boto3.client('lambda')
    for i in range(n_workers):
        payload['worker_index'] = i
        payload['train_file'] = 'training_{}.pt'.format(i)
        payload['test_file'] = 'test.pt'
        lambda_client.invoke(FunctionName=function_name,
                             InvocationType='Event',
                             Payload=json.dumps(payload))
