# Bowland Widget Factory: Network Policy Standards



## 1. Overview
Bowland Widget Factory operates on a Zero-Trust network model within our OpenShift clusters. By default, namespaces are completely isolated. Developers must explicitly define traffic rules.

## 2. The "Default Deny" Rule
Every namespace MUST contain a NetworkPolicy named `default-deny-all` that blocks all Ingress and Egress traffic by default.
* `podSelector: {}` (Matches all pods)
* `policyTypes: ["Ingress", "Egress"]`
* No ingress or egress rules should be defined in this base policy.

## 3. Allowed Egress: DNS
Because of the default deny rule, pods will not be able to resolve DNS. Developers MUST include a NetworkPolicy named `allow-dns-egress` that allows UDP and TCP traffic on port 53 to the `openshift-dns` namespace.

## 4. Ingress: OpenShift Ingress Controller
If an application requires external access via an OpenShift Route, the developer MUST create a NetworkPolicy named `allow-from-openshift-ingress`.
* This policy must allow ingress traffic from pods matching the namespace selector: `network.openshift.io/policy-group: ingress`

## 5. Intra-Namespace Communication
Applications that need to talk to other microservices within the *same* namespace MUST use a NetworkPolicy named `allow-same-namespace`.
* This policy should allow Ingress where the `podSelector` matches the labels of the target application, and the `from.podSelector` matches the labels of the originating application.