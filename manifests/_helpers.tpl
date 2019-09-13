{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Values.appName .Values.nameOverride | trunc 63 | trimSuffix "-" | replace "_" "-" -}}
{{- end -}}

{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | replace "_" "-"}}
{{- end -}}

{{/*
Needed if not using exposecontroller
*/}}

{{- define "domain" -}}
{{- if contains "pre" .Release.Namespace  }}
{{- printf "%s" "alpha.curefit.co" -}}
{{- else if contains "stage" .Release.Namespace   }}
{{- printf "%s" "stage.curefit.co" -}}
{{- else if contains "test" .Release.Namespace   }}
{{- printf "%s" "test.curefit.co" -}}
{{- else -}}
{{- printf "%s" "curefit.co" -}}
{{- end -}}
{{- end -}}

{{- define "url" -}}
{{- printf "%s.curefit.co" .Release.Namespace | trunc 63 | trimSuffix "-" | trimPrefix "dev-" -}}
{{- end -}}
