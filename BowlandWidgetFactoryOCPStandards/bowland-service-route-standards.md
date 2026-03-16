# Bowland Widget Factory: Service and Route Standards



## 1. Overview
This document outlines the standard methods for exposing applications within the cluster (Services) and externally to the internet or corporate network (Routes).

## 2. Service Standards
* **Type:** All Services MUST be of type `ClusterIP`. Using `NodePort` or `LoadBalancer` types is explicitly FORBIDDEN to prevent bypassing the OpenShift Ingress controller.
* **Selectors:** Services MUST use explicit label selectors that exactly match the target Deployment's pod template labels (`bowland.com/app-name`).
* **Ports:** Port definitions MUST include a descriptive `name` (e.g., `name: http`, `name: metrics`), the `port`, and the `targetPort`.

## 3. Route Standards
* **TLS Requirement:** HTTP-only routes are FORBIDDEN. All OpenShift Routes MUST configure TLS termination.
* **Termination Policies:**
    * **Standard Web Apps:** Use `edge` termination.
    * **Sensitive/Financial Apps:** Use `reencrypt` or `passthrough` termination for end-to-end encryption.
* **Insecure Traffic:** All routes MUST set `insecureEdgeTerminationPolicy: Redirect` to force HTTP traffic to upgrade to HTTPS automatically.
* **Labels:** Routes MUST inherit the global metadata standards (`environment`, `business-unit`, `app-name`).