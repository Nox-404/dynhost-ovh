{{/*
Expand the name of the chart.
*/}}
{{- define "dynhost-ovh.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dynhost-ovh.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dynhost-ovh.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dynhost-ovh.labels" -}}
helm.sh/chart: {{ include "dynhost-ovh.chart" . }}
{{ include "dynhost-ovh.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dynhost-ovh.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dynhost-ovh.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dynhost-ovh.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dynhost-ovh.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "dynhost-ovh.cronjobApiVersion" -}}
{{- default "batch/v1" .Values.cronjobApiVersion -}}
{{- end }}

{{- define "dynhost-ovh.secretConfig" -}}
{{- default (include "dynhost-ovh.fullname" .) .Values.dynhost.externalSecretName -}}
{{- end }}
