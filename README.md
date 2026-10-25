# EcoCompute

**Data-driven data center monitoring and maintenance system**

EcoCompute combines structured operational records in PostgreSQL with telemetry documents in MongoDB. A Streamlit dashboard will provide monitoring summaries and maintenance workflows.

## Team responsibilities

- **Member 1 — Relational Architect:** ER model, SQL schema, sample operational data, `INNER JOIN`, nested subquery, and stored procedure.
- **Member 2 — NoSQL/Data Engineer:** telemetry document schema, 1,000+ mock telemetry records, MongoDB aggregation pipeline.
- **Member 3 — Python/Backend Lead:** modular SQL/MongoDB connectors, exception handling, and methods returning Pandas DataFrames.
- **Member 4 — UI/Presentation Lead:** Streamlit dashboard, charts, forms, validation, and UI testing.

## Repository structure

```text
ecocompute/
├── backend/
├── db_scripts/
│   ├── schema.sql
│   ├── seed.sql
│   └── advanced_queries.sql
├── docs/
├── frontend/
├── tests/
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

## Setup

1. Install Python 3.9 or newer.
2. Install PostgreSQL and create a database named `ecocompute`.
3. Install MongoDB locally or create a MongoDB Atlas cluster.
4. Create a local `.env` file by copying `.env.example`, then fill in your own credentials.
5. Install Python dependencies:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

6. In PostgreSQL, run `db_scripts/schema.sql`, then `db_scripts/seed.sql`.
7. Run the SQL examples in `db_scripts/advanced_queries.sql` individually to inspect the results.

> **Security:** Never commit `.env`, passwords, or a MongoDB connection URI containing credentials. Share secrets only through a secure method.

## Git collaboration

Use short-lived task branches and pull requests. Do not commit directly to `main`.

```bash
git switch -c feature/sql-schema
# make and test changes
git add db_scripts/
git commit -m "Add relational schema and sample data"
git push -u origin feature/sql-schema
```

Open a pull request to `main` and request one teammate's review. After a teammate merges a pull request, sync your local branch:

```bash
git switch main
git pull origin main
```

## Report evidence to collect

- ER diagram and relational schema
- database setup steps and executed DDL
- screenshots of sample records and advanced query outputs
- stored procedure execution and maintenance record insertion
- final dashboard screenshots and usage instructions
- test cases, validation results, and limitations
