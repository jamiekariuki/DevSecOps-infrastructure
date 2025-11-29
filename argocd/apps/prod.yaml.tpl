apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-prod
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "${repo_url}"
    targetRevision: "${target_revision}"
    path: app
    helm:
      valueFiles:
        - values-prod.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true