apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-dev
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "${repo_url}"
    targetRevision: "${target_revision}"
    path: app
    helm:
      valueFiles:
        - values-dev.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

