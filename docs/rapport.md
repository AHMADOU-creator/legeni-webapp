# Rapport – Projet Final DevOps : Chaîne CI/CD Legeni WebApp

**Auteurs :** [Nom1] & [Nom2]  
**Date :** [Date]  
**Formation :** DevOps – LEGENI CONSULTING

---

## 1. Introduction et contexte

[Décrire le problème initial : déploiements manuels, risques, absence de traçabilité…]

## 2. Architecture cible

[Insérer le schéma mermaid ou une image de l’architecture]

### Choix techniques justifiés

| Composant | Choix | Justification |
|-----------|-------|---------------|
| Orchestrateur CI/CD | Jenkins Multibranch | … |
| Infrastructure | Ansible + Minikube | … |
| Orchestration conteneurs | Kubernetes | … |
| Registre | Docker Hub | … |

## 3. Lot 1 – Conteneurisation

[Explication du Dockerfile multi-stage, non-root, HEALTHCHECK, gestion de la version…]

## 4. Lot 2 – Infrastructure as Code

[provision.yml, rôles, idempotence, Ansible Vault…]

## 5. Lot 3 – Déploiement Kubernetes

[Namespaces, StatefulSet Redis, probes, RollingUpdate, rollback automatique…]

## 6. Lot 4 & 5 – Pipeline CI/CD

[Description stage par stage du Jenkinsfile, webhook, quality gates, validation humaine…]

## 7. Démonstration du scénario de soutenance

1. Livraison nominale
2. Code défectueux
3. Déploiement raté + rollback
4. …

## 8. Difficultés rencontrées et solutions

| Problème | Solution |
|----------|----------|
| … | … |

## 9. Pistes d’amélioration / Bonus réalisés

- [ ] Ingress + TLS
- [ ] HPA
- [ ] Prometheus + Grafana
- [ ] Argo CD (GitOps)
- [ ] …

## 10. Conclusion

[…]

## Annexes

- Captures d’écran (Stage View, kubectl get all, Trivy, etc.)
- Lien vers le dépôt GitHub
