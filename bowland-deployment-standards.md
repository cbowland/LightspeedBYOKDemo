# Bowland Widget Factory: Container Deployment Standards

## 1. Overview
All containerized applications running on OpenShift must adhere to strict security and resource management guidelines. 

## 2. Replica Requirements
* All deployments MUST have `replicas` set to a minimum of `2` for high availability.

## 3. Security Context Constraints (SCC)
Pods and Containers must be configured to run with least privilege. The following `securityContext` settings are MANDATORY for all containers in a Pod:
* `allowPrivilegeEscalation: false`
* `runAsNonRoot: true`
* `capabilities.drop: ["ALL"]`
* `seccompProfile.type: RuntimeDefault`

## 4. Resource Management
Containers MUST NOT be deployed without resource requests and limits. If a developer does not specify them, use the following defaults:
* **Requests:** `cpu: 100m`, `memory: 128Mi`
* **Limits:** `cpu: 500m`, `memory: 512Mi`

## 5. Probes
All containers MUST define both `livenessProbe` and `readinessProbe`. If the protocol is unknown, default to a simple TCP socket check on the container's primary port.

## 6. Example Conforming Deployment Structure
When creating deployments, apply the global metadata standards (environment, business-unit, app-name) to both the Deployment metadata and the Pod template metadata.