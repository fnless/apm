{{/*
Common ClickHouse ENV variables and helpers used by SigNoz
*/}}

{{- define "schemamigrator.url" -}}
{{- printf "%v:%v" ( required "externalClickhouse.host is required" .Values.externalClickhouse.host ) ( default 9000 .Values.externalClickhouse.tcpPort ) -}}
{{- end -}}

{{- define "snippet.clickhouse-env" }}
- name: CLICKHOUSE_HOST
  value: {{ required "externalClickhouse.host is required" .Values.externalClickhouse.host | quote }}
- name: CLICKHOUSE_PORT
  value: {{ default 9000 .Values.externalClickhouse.tcpPort | quote }}
- name: CLICKHOUSE_HTTP_PORT
  value: {{ default 8123 .Values.externalClickhouse.httpPort | quote }}
- name: CLICKHOUSE_CLUSTER
  value: {{ required "externalClickhouse.cluster is required" .Values.externalClickhouse.cluster | quote }}
- name: CLICKHOUSE_DATABASE
  value: {{ default "signoz_metrics" .Values.externalClickhouse.database | quote }}
- name: CLICKHOUSE_TRACE_DATABASE
  value: {{ default "signoz_traces" .Values.externalClickhouse.traceDatabase | quote }}
- name: CLICKHOUSE_LOG_DATABASE
  value: {{ default "signoz_logs" .Values.externalClickhouse.logDatabase | quote }}
- name: CLICKHOUSE_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "clickhouse.secretName" . }}
      key: {{ include "clickhouse.secretUserKey" . }}
- name: CLICKHOUSE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "clickhouse.secretName" . }}
      key: {{ include "clickhouse.secretPasswordKey" . }}
- name: CLICKHOUSE_SECURE
  value: {{ .Values.externalClickhouse.secure | quote }}
- name: CLICKHOUSE_VERIFY
  value: {{ .Values.externalClickhouse.verify | quote }}
{{- end -}}

{{/*
Minimized ClickHouse ENV variables for user credentials
*/}}
{{- define "snippet.clickhouse-credentials" -}}
- name: CLICKHOUSE_HOST
  value: {{ required "externalClickhouse.host is required" .Values.externalClickhouse.host | quote }}
- name: CLICKHOUSE_PORT
  value: {{ default 9000 .Values.externalClickhouse.tcpPort | quote }}
- name: CLICKHOUSE_HTTP_PORT
  value: {{ default 8123 .Values.externalClickhouse.httpPort | quote }}
- name: CLICKHOUSE_CLUSTER
  value: {{ required "externalClickhouse.cluster is required" .Values.externalClickhouse.cluster | quote }}
- name: CLICKHOUSE_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "clickhouse.secretName" . }}
      key: {{ include "clickhouse.secretUserKey" . }}
- name: CLICKHOUSE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "clickhouse.secretName" . }}
      key: {{ include "clickhouse.secretPasswordKey" . }}
- name: CLICKHOUSE_SECURE
  value: {{ .Values.externalClickhouse.secure | quote }}
{{- end -}}

{*
   ------ CLICKHOUSE ------
*}

{{/*
Set Clickhouse tcp port
*/}}
{{- define "clickhouse.tcpPort" -}}
{{- default 9000 .Values.externalClickhouse.tcpPort }}
{{- end -}}

{{/*
Set Clickhouse http port
*/}}
{{- define "clickhouse.httpPort" -}}
{{- default 8123 .Values.externalClickhouse.httpPort }}
{{- end -}}

{{/*
Return the ClickHouse secret
*/}}
{{- define "clickhouse.secretName" -}}
    {{- printf "%s-clickhouse" (include "signoz.fullname" .) -}}
{{- end -}}
{{- define "clickhouse.secretUserKey" -}}
    {{- printf "user" -}}
{{- end -}}
{{- define "clickhouse.secretPasswordKey" -}}
    {{- printf "password" -}}
{{- end -}}

{{/*
Return the ClickHouse http URL
*/}}
{{- define "clickhouse.httpUrl" -}}
{{- $httpUrl := "" -}}
{{- $httpPrefix := "" -}}
  {{- $httpUrl = printf "%s:%s" (required "externalClickhouse.host is required if using external clickhouse" .Values.externalClickhouse.host) ( include "clickhouse.httpPort" .) }}
  {{- if .Values.externalClickhouse.secure }}
    {{- $httpPrefix = "https://" }}
  {{- end }}
{{- printf "%s%s" $httpPrefix $httpUrl }}
{{- end -}}

{{/*
Return the ClickHouse Metrics URL
*/}}
{{- define "clickhouse.metricsUrl" -}}
  tcp://{{ .Values.externalClickhouse.user }}:{{ .Values.externalClickhouse.password }}@{{- required "externalClickhouse.host is required if using external clickhouse" .Values.externalClickhouse.host }}:{{ include "clickhouse.tcpPort" . }}/{{ .Values.externalClickhouse.database -}}
{{- end -}}

{{- define "clickhouse.clickHouseUrl" -}}
  {{- required "externalClickhouse.host is required if using external clickhouse" .Values.externalClickhouse.host }}:{{ include "clickhouse.tcpPort" . }}/?username={{ .Values.externalClickhouse.user }}&password=$(CLICKHOUSE_PASSWORD)
{{- end -}}
