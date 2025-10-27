🛍️ Retail Analytics
Industrialiser l’analyse de données omnicanales pour le Retail et le Luxe

🎯 Objectif du projet

Retail Analytics est un projet d’Analytics Engineering conçu pour simuler l’architecture analytique d’une maison de luxe ou d’un retailer omnicanal (Hermès, Dior, Lacoste…).

L’objectif est de centraliser, fiabiliser et industrialiser les données issues de plusieurs canaux de vente :

🛒 E-commerce

🏬 Boutiques physiques

Le projet met en œuvre les bonnes pratiques de l’Analytics Engineering moderne (tests, CI/CD, documentation, modularité) afin de produire des modèles de données fiables, réutilisables et prêts à la décision.

🧱 Architecture technique : 
🔸 Data Warehouse

Supabase (PostgreSQL) sert de Data Warehouse principal :

Environnement de dev/prod différencié

Tables structurées par schéma logique

🔸 Transformation

Réalisée avec dbt Core :

Structure en 3 couches (stg_, int_, mart_)

Tests automatiques (not_null, unique, relationships)

Macros et CTE pour une logique transparente

🔸 Orchestration

Industrialisation via GitHub Actions (CI/CD) :

Lancement automatique des tests SQLFluff et dbt à chaque pull request

Build et déploiement automatisé sur prod après validation

Respect des conventions Gitflow (feature/, fix/, chore/, etc.)

🔸 Visualisation

Tableau Public pour la restitution métier :

Dashboards thématiques

Analyses client, produit, et rétention

Vue 360° sur la performance omnicanale

🧮 Modélisation analytique

Approche Kimball / dbt-first, articulée autour de trois couches :

1️⃣ stg_ — Staging Layer

Nettoyage, typage et standardisation des données brutes.

2️⃣ int_ — Intermediate Layer

Enrichissement logique et préparation des faits et dimensions :

Calculs intermédiaires (première commande, délai moyen, panier moyen)

Jointures logiques entre entités (orders, products, customers)

3️⃣ mart_ — Business Layer

Tables prêtes à la consommation BI :

mart_sales_daily_agg : ventes quotidiennes agrégées

mart_customer_360 : profil complet client (RFM, LTV, omnicanal)

mart_product_360 : performance produit

Granularité :

mart_sales_daily_agg → jour, store_id

mart_customer_360 → client

mart_product_360 → produit

💼 Cas d’usage métier

Le projet Retail Analytics s’articule autour de 4 axes d’analyse clés, représentatifs des besoins d’une maison de luxe ou d’un retailer omnicanal :

1️⃣ 📈 Résumé / Performance Commerciale

Objectif : offrir une vue synthétique des indicateurs globaux à travers les ventes, le chiffre d’affaires et la contribution des canaux.

2️⃣ 👜 Vue 360 Produit

Objectif : analyser la performance produit (ventes, catégories, collections, matières) et identifier les best-sellers et opportunités.

3️⃣ 👩‍💼 Vue 360 Customer & Segmentation RFM

Objectif : comprendre la base client et identifier les segments stratégiques via une approche RFM (Récence, Fréquence, Montant).

4️⃣ 🔁 Customer Rétention

Objectif : mesurer la fidélité client dans le temps et analyser les comportements de réachat et de churn.

⚙️ Industrialisation & Qualité
🔸 CI/CD (GitHub Actions)

Chaque push ou pull request déclenche un pipeline complet :

Linting SQLFluff → conformité du code SQL/dbt

Build & Test dbt → compilation + tests automatiques

Déploiement → promotion vers prod après validation

🔸 Linter SQLFluff

Dialecte : postgres

Templater : dbt

Règles personnalisées (exclude_rules, warning_rules)

Intégré dans la CI pour éviter tout merge non conforme

🔸 Tests de qualité

not_null sur les clés primaires

relationships pour valider les jointures

📊 Visualisation

Les dashboards Tableau s’articulent autour des 4 volets d’analyse :

Performance Commerciale → suivi global des ventes

Produit 360 → analyse des collections et catégories

Client 360 / RFM → segmentation et omnicanalité

Rétention → cohorte et fidélisation

🧩 Exemples d’insights :

Les 60 premiers jours après achat sont une fenêtre clé de réachat

Moins de nouveaux clients, mais une fidélité en nette progression

Stack Technique :

Data Warehouse : Supabase (PostgreSQL) - Stockage & centralisation
Transformation : dbt Core -	Modélisation & tests
Orchestration :  GitHub Actions - CI/CD automatisée
Qualité :	SQLFluff - Lint SQL & standards
Visualisation : Tableau Public - Dashboards interactifs
Versioning : Git + GitHub - Collaboration & tracking

Kevin S.
Consultant Data Analyst / Analytics Engineer
linkedin.com/in/kevin-semedo-guiolet
