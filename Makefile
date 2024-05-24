.PHONY: kafka
kafka:
	# helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install my-kafka bitnami/kafka --version 28.3.0 -n kafka --create-namespace

.PHONY: kafka-info
kafka-info:
	@helm status my-kafka -n kafka
	# @echo password=$(shell kubectl get secret my-kafka-user-passwords --namespace kafka -o jsonpath='{.data.client-passwords}' | base64 -d | cut -d , -f 1)

.PHONY: kafka-delete
kafka-delete:
	@helm delete my-kafka -n kafka

.PHONY: minio
minio:
	@rm -rf ~/minio && \
    docker rm -fv minio 2> /dev/null || true && \
    docker run -ti -d \
	-p 9999:9000 \
	-p 9001:9001 \
	--name minio \
         -v ~/minio/data:/data \
         -e "MINIO_ROOT_USER=minio" \
         -e "MINIO_ROOT_PASSWORD=minio123" \
         quay.io/minio/minio server /data --console-address ":9001"

.PHONY: minio-delete
minio-delete:
	@docker rm -fv minio 2> /dev/null || true

.PHONY: clickhouse-keeper
clickhouse-keeper:
	helm install clickhouse-keeper ./charts/clickhouse-keeper -n clickhouse  --create-namespace

.PHONY: clickhouse
clickhouse:
	helm install clickhouse ./charts/clickhouse -n clickhouse --create-namespace

.PHONY: signoz
signoz:
	helm install signoz ./charts/signoz -n signoz --create-namespace
