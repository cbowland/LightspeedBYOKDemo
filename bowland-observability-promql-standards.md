# Bowland Widget Factory: Application Observability and PromQL Standards



## 1. Overview
All applications deployed to Bowland Widget Factory clusters are automatically scraped by the OpenShift cluster monitoring stack. Developers should use these standard PromQL queries to build their Grafana dashboards and Prometheus alerts to monitor the "Golden Signals."

## 2. Golden Signals: Resource Utilization
* **CPU Usage (per pod):**
  `sum(rate(container_cpu_usage_seconds_total{namespace="<YOUR_NAMESPACE>", container!="POD", container!=""}[5m])) by (pod)`
* **Memory Usage (per pod):**
  `sum(container_memory_working_set_bytes{namespace="<YOUR_NAMESPACE>", container!="POD", container!=""}) by (pod)`

## 3. Golden Signals: Application Health
* **Pod Restarts (last 1 hour):**
  `sum(changes(kube_pod_status_ready{condition="true", namespace="<YOUR_NAMESPACE>"}[1h])) by (pod)`
* **Pod Availability Percentage:**
  `(sum(kube_pod_status_phase{namespace="<YOUR_NAMESPACE>", phase="Running"}) / sum(kube_pod_status_phase{namespace="<YOUR_NAMESPACE>"})) * 100`

## 4. Network Traffic (If ServiceMesh is enabled)
* **HTTP Error Rate (5xx errors):**
  `sum(rate(istio_requests_total{reporter="destination", destination_workload_namespace="<YOUR_NAMESPACE>", response_code=~"5.*"}[5m])) / sum(rate(istio_requests_total{reporter="destination", destination_workload_namespace="<YOUR_NAMESPACE>"}[5m]))`