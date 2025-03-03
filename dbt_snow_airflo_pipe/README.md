# Documentation de la partie DBT

## Table des matières
1. [Vue d'ensemble](#vue-densemble)
2. [Architecture](#architecture)
3. [Structure des modèles](#structure-des-modèles)
4. [Organisation des schémas](#organisation-des-schémas)
5. [Implémentation technique](#implémentation-technique)
6. [Processus de construction](#processus-de-construction)
7. [Bonnes pratiques](#bonnes-pratiques)
8. [Maintenance et évolution](#maintenance-et-évolution)

## Vue d'ensemble

Ce document décrit l'architecture et l'implémentation d'un projet de transformation de données utilisant DBT (Data Build Tool). Le projet suit une approche de modélisation en couches, permettant une transformation progressive et maintainable des données brutes en modèles analytiques exploitables.

## Architecture

L'architecture du projet est construite selon un pattern de modélisation en couches, offrant une séparation claire des responsabilités et une progression logique des transformations :

### Couche Staging
La première couche de transformation qui prend en charge le nettoyage et la standardisation des données brutes. Cette couche assure que toutes les données suivent des conventions cohérentes avant leur utilisation dans les couches supérieures.

### Couche Marts
La couche de transformation finale qui produit des modèles analytiques prêts à l'emploi. Cette couche combine les données standardisées de la couche staging et y ajoute les calculs métier nécessaires.

## Structure des modèles

### Modèles Staging
Les modèles de la couche staging sont implémentés sous forme de vues pour optimiser les performances :

- **stg_tpch_line_items**
  - Objectif : Transformation des données brutes des items de commande
  - Matérialisation : Vue
  - Transformations principales : Standardisation des noms de colonnes, nettoyage des données

- **stg_tpch_orders**
  - Objectif : Transformation des données brutes des commandes
  - Matérialisation : Vue
  - Transformations principales : Standardisation des noms de colonnes, nettoyage des données

### Modèles Marts
Les modèles de la couche marts sont implémentés sous forme de tables pour optimiser les performances de requête :

- **fact_orders**
  - Objectif : Modèle combiné enrichi des données de commandes
  - Matérialisation : Table
  - Transformations principales : Jointures, calculs métier, agrégations

## Organisation des schémas

L'organisation des schémas suit une structure logique qui facilite la gestion des droits et la maintenance :

### Schéma Staging
- Nom : `staging`
- Contenu : Vues intermédiaires
- Objectif : Isolation des transformations de base

### Schéma Marts
- Nom : `marts_fact_schema`
- Contenu : Tables de fait finales
- Objectif : Stockage des modèles analytiques

## Implémentation technique

### Gestion des clés
- Utilisation de clés surrogate générées via `dbt_utils.generate_surrogate_key`
- Garantit l'unicité et l'intégrité des données

### Gestion des valeurs NULL
- Utilisation systématique de `COALESCE` pour le traitement des valeurs NULL
- Définition de valeurs par défaut appropriées selon le contexte métier

### Conventions de nommage
- Noms de colonnes standardisés et cohérents
- Préfixes clairs selon la nature des champs

### Structure du code
- Utilisation extensive des Common Table Expressions (CTEs)
- Organisation claire et modulaire du code

## Processus de construction

Le processus de construction suit une séquence logique en trois étapes :

1. **Transformation initiale**
   - Chargement des données sources
   - Application des transformations de base dans la couche staging

2. **Combinaison des données**
   - Jointure des différentes sources via les modèles staging
   - Création des relations entre les données

3. **Enrichissement analytique**
   - Ajout des calculs métier
   - Création des agrégations nécessaires

## Bonnes pratiques

### Documentation
- Documentation complète dans schema.yml
- Description détaillée des transformations
- Documentation des règles métier appliquées

### Tests
- Tests automatisés sur les colonnes critiques
- Validation des contraintes d'intégrité
- Tests de cohérence des données

### Conventions de code
- Style de code cohérent
- Nommage explicite des transformations
- Commentaires pertinents

## Maintenance et évolution

### Points d'attention
- Surveillance des performances des transformations
- Gestion explicite des types de données
- Maintenance de la documentation

### Avantages de l'architecture
L'architecture mise en place offre plusieurs avantages clés :
- Facilité de maintenance grâce à la séparation claire des responsabilités
- Performances optimisées via des stratégies de matérialisation appropriées
- Traçabilité complète des transformations
- Évolutivité facilitée par la modularité de la structure

### Évolution future
- Ajout de modèles de dimension pour enrichir l'analyse
- Intégration de nouveaux jeux de données pour une vision plus complète
- Automatisation des processus de déploiement et de surveillance avec apache airflow