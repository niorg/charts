{{/*
Expand the name objecttypen the chart.
*/}}
{{- define "objecttypen.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "objecttypen.fullname" -}}
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
{{- define "objecttypen.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "objecttypen.commonLabels" -}}
helm.sh/chart: {{ include "objecttypen.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
objecttypen labels
*/}}
{{- define "objecttypen.labels" -}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ include "objecttypen.commonLabels" . }}
{{ include "objecttypen.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "objecttypen.selectorLabels" -}}
app.kubernetes.io/name: {{ include "objecttypen.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "objecttypen.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "objecttypen.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a name for Config cronjob
We truncate at 56 chars in order to provide space for the "-config" suffix
*/}}
{{- define "objecttypen.configName" -}}
{{ include "objecttypen.name" . | trunc 56 | trimSuffix "-" }}-config
{{- end }}

{{/*
Create a default fully qualified name for config.
We truncate at 56 chars in order to provide space for the "-config" suffix
*/}}
{{- define "objecttypen.configFullname" -}}
{{ include "objecttypen.fullname" . | trunc 56 | trimSuffix "-" }}-config
{{- end }}

{{/*
config labels
*/}}
{{- define "objecttypen.configLabels" -}}
{{ include "objecttypen.commonLabels" . }}
{{ include "objecttypen.configSelectorLabels" . }}
{{- end }}

{{/*
config selector labels
*/}}
{{- define "objecttypen.configSelectorLabels" -}}
app.kubernetes.io/name: {{ include "objecttypen.configName" . }}
{{- end }}

{{/*
Ingress annotations
*/}}
{{- define "objecttypen.ingress.annotations" -}}
  {{- range $key, $val := .Values.ingress.annotations }}
  {{ $key }}: {{ $val | quote }}
  {{- end }}
{{- end }}

{{/* vim: set filetype=mustache: */}}
{{/*
Renders a value that contains template.
Usage:
{{ include "objecttypen.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "objecttypen.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}