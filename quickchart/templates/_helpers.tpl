{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "helm.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 55 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm.chart" -}}
{{- printf "%s-%s" (include "helm.name" .) .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "helm.labels" -}}
app: {{ include "helm.name" . }}
helm.sh/chart: {{ include "helm.chart" . }}
{{ include "helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: service
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "helm.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "helm.name" . }}
{{- end -}}

{{- define "helm.job.labels" -}}
helm.sh/chart: {{ include "helm.chart" . }}
{{ include "helm.job.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "helm.job.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ include "helm.name" . }}-job
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "helm.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "helm.imagePullSecrets" -}}
{{- coalesce .Values.imagePullSecrets .Values.global.imagePullSecrets | toYaml }}
{{- end -}}

{{- define "helm.namespace" -}}
{{ default .Release.Namespace .Values.namespace }}
{{- end -}}

{{- define "helm.storageClass" -}}
{{- if .Values.storageClassName -}}
  {{- .Values.storageClassName -}}
{{- else if .Values.global.storageClassName -}}
  {{ .Values.global.storageClassName }}
{{- end -}}
{{- end -}}

{{- define "helm.image.url" -}}
{{- if .Values.image -}}
{{- $repository := coalesce .Values.image.repository .Values.global.repository -}}
{{- $imageName := default (include "helm.name" .) .Values.image.name -}}
{{- if $repository -}}
{{- printf "%s/%s:%s" $repository $imageName .Values.image.tag -}}
{{- else -}}
{{- printf "%s:%s" $imageName .Values.image.tag -}}
{{- end -}}
{{- end -}}
{{- end -}}
