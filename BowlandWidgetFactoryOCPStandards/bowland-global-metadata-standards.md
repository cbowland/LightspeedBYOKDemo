# Bowland Widget Factory: Global Kubernetes Metadata Standards

## 1. Overview
To ensure proper cost allocation, observability, and automated governance, all Kubernetes and OpenShift objects deployed to Bowland Widget Factory clusters MUST adhere to the following metadata standards.

## 2. Mandatory Labels
Every Kubernetes object (Deployments, Pods, Services, NetworkPolicies, etc.) MUST include the following labels in their `metadata.labels` section:

* `bowland.com/environment`: Must be one of `dev`, `qa`, `staging`, or `prod`.
* `bowland.com/business-unit`: The department owning the service (e.g., `retail`, `finance`, `platform`).
* `bowland.com/app-name`: The logical name of the application.

## 3. Mandatory Annotations
All Deployments and StatefulSets MUST include the following annotation:
* `bowland.com/support-contact`: A valid email address for the team responsible for the application (e.g., `team-alpha@bowland.com`).