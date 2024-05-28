# quick start

## clickhouse-keeper
```
make clickhouse-keeper
```

## clickhouse
```yaml
clickhouse-keeper:
  enabled: true
  nameOverride: "keeper"
  namespaceOverride: ""
  replicaCount: 3

# -- Clickhouse user
user: admin
# -- Clickhouse password
password: changeme
layout:
  shardsCount: 2
  replicasCount: 1

# Cold storage configuration
coldStorage:
  # -- Whether to enable S3 or GCS cold storage
  enabled: true
  # -- Reserve free space on default disk (in bytes)
  # Default value set below is 10MiB
  defaultKeepFreeSpaceBytes: "10485760"
  # -- Type of cold storage: s3 or gcs
  type: s3
  # -- Endpoint for S3 or GCS
  endpoint: "http://192.168.1.160:9999/clickhouse/"
  # -- Access Key for S3 or GCS
  accessKey: "qBo3LFBm61mEKF7MR5dU"
  # -- Secret Access Key for S3 or GCS
  secretAccess: "hjmZx3sjZQcI0ZqjhLUelurXgWPSnXFZtUd3EmOt"
```


```
make clickhouse
```

## kafka

拿到 kafka 的 brokers 信息，以及认证信息，后续 otel collector 会用到
```
```

## minio or aws s3

## signoz

```yaml
kafka: &kafka
  protocol_version: "2.0.0"
  brokers: "my-kafka-controller-0.my-kafka-controller-headless.kafka.svc.cluster.local:9092,my-kafka-controller-1.my-kafka-controller-headless.kafka.svc.cluster.local:9092,my-kafka-controller-2.my-kafka-controller-headless.kafka.svc.cluster.local:9092"
  topic: "otlp_spans"
  encoding: "otlp_proto"
  auth:
    plain_text:
      username: user1
      password: EWz1thErgo
externalClickhouse:
  # -- Host of the external cluster.
  host: "clickhouse.clickhouse.svc.cluster.local."
  # -- User name for the external cluster to connect to the external cluster as
  user: "admin"
  # -- Password for the cluster.
  password: "changeme"
  # -- Whether to use TLS connection connecting to ClickHouse
  secure: false
  # -- Whether to verify TLS connection connecting to ClickHouse
  verify: false
  # -- HTTP port of Clickhouse
  httpPort: 8123
  # -- TCP port of Clickhouse
  tcpPort: 9000
```

make signoz

## signoz-test

```yaml
namespace: ""
otlp:
  endpoint: "http://otel-collector:4318"
```
