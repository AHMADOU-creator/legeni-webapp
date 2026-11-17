# Legeni WebApp – Chaîne CI/CD complète

**Projet Final DevOps – LEGENI CONSULTING**

Chaîne entièrement automatisée : du `git push` jusqu’à la production Kubernetes, sans action manuelle (sauf validation humaine avant la prod).

## Architecture

```
Développeur → GitHub (PR) → Jenkins (Multibranch + webhook)
                              │
                              ├─ Tests + lint + couverture (parallèle)
                              ├─ Build image multi-stage
                              ├─ Scan Trivy
                              └─ Push Docker Hub (tag VERSION-BUILD)
                                      │
                                      ▼
                              Ansible deploy.yml
                                      │
                         ┌────────────┴────────────┐
                         ▼                         ▼
                  legeni-staging              legeni-prod
                  (Namespace K8s)             (Namespace K8s)
```

## Prérequis

- Docker + Minikube (driver docker)
- Ansible + collections `kubernetes.core`, `community.docker`
- Compte Docker Hub
- Jenkins (installé via `provision.yml`)

## Démarrage rapide

```bash
# 1. Cloner
git clone <url-du-depot> && cd legeni-webapp

# 2. Provisionner l’infrastructure (sur une machine vierge)
cd ansible
ansible-playbook -i inventory.ini provision.yml --ask-vault-pass

# 3. Déployer en staging
ansible-playbook -i inventory.ini deploy.yml -e target_env=staging --ask-vault-pass
```

## Structure du dépôt

| Dossier / Fichier | Rôle |
|-------------------|------|
| `app.py`, `tests/`, `requirements*.txt` | Application Flask + Redis (fournie) |
| `Dockerfile`, `.dockerignore` | Conteneurisation multi-stage |
| `VERSION` | Version sémantique (ex. 1.0.0) |
| `Jenkinsfile` | Pipeline CI/CD (Multibranch) |
| `ansible/` | Infrastructure as Code + déploiement K8s |
| `docs/rapport.md` | Rapport final |

## Lots

- **Lot 0** – Organisation Git (ce dépôt)
- **Lot 1** – Conteneurisation
- **Lot 2** – Infrastructure as Code (Ansible)
- **Lot 3** – Déploiement Kubernetes
- **Lot 4** – Intégration continue (Jenkins)
- **Lot 5** – Déploiement continu

## Licence

Travail académique – LEGENI CONSULTING / Formation DevOps
