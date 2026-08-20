# Epic Template — Spec Ingestion

Copy this template to create a new epic for ingestion work. Fill in all **required** fields and as many *optional* fields as applicable.

## Required Fields

### Title

**Format for source onboarding**: `[Domain] Ingest <Source System> into <Target Layer>`  `Minerva: Create the FDP for <DOMAIN> <SOURCE NAME> data`

Examples:

- `Minerva: Create the FDP for RMS Delacon Data`
- `Minerva: Create the FDP for RMS TradeTracker SharePoint`

### Description

Concise summary of scope, business value, and key scope boundaries:

```
Ingest 23 tables from RMS CNC system via Boomi → Kafka streaming 
into LH Raw landing zone. Enable near-real-time animal nutrition 
data for ANH domain.
```

### Epic Link

If nested under a larger initiative, link here. Otherwise, leave blank.

## Ingestion-Specific Fields (Required for Source Onboarding)

### Domain

Which business domain does this source serve?

```
ANH (Animal Nutrition), RMS (Restricted Materials), Finance, Operations, etc.
```

### Project

Project name or identifier (if applicable):

Examples:

- `ANH Bestmix`
- `ANH CNC`
- `ANH Costko`

### Ingestion Type

How is data flowing?

```
- JDBC batch (schedule, watermark column, frequency)
- Kafka streaming (topic, broker, schema registry)
- Flat files (delimiter, naming pattern, delivery cadence)
- REST API (endpoints, auth, pagination)
```

### Database / Table Details

For JDBC sources:

```
Database: prd_internal_anh_cnc
Schema: dbo
Total tables in scope: 23
Key tables: ProductionRuns, QualityChecks, AnimalInfo, NutritionAssessments
Incremental key column(s): LastModified, CreatedDate
```

For flat files:

```
Delivery method: SFTP
Naming pattern: ORDERS_YYYYMMDD_HHmmss.csv
Delimiter: |
Compression: GZIP
Expected volume: ~50K rows/day
```

For Kafka sources:

```
Brokers: kafka-prod-01:9092,kafka-prod-02:9092
Topic(s): rms-delacom-master, rms-delacom-events
Schema registry: https://schema-registry.prod.internal
Message format: Avro (Confluent schema)
Consumer group: spec-ingestion-rms-delacom
Retention: 7 days
Expected throughput: ~3K messages/hour
Replay strategy: offset reset by timestamp for controlled backfill
```

For API sources:

```
Base URL: https://api.partner.internal/v1
Auth method: OAuth2 client credentials
Endpoints in scope: /orders, /order-items, /customers
Pagination: cursor-based (page_size=1000)
Rate limits: 600 requests/minute
Retry/backoff: exponential (max 5 retries)
Expected volume: ~120K records/day
```


### Key Success Metrics

Define how success is measured (3–5):

```
- All 23 tables land in LH Raw within 24 hours of first run
- Data freshness: < 5 minute lag from source to LH Raw
- Zero data loss or duplication in reconciliation checks
- Ingestion pipeline passes enterprise QA criteria
- Data contracts signed off by ANH domain owner
```

## Optional Fields

### Business Value / Why

Explain business impact:

```
Enables near-real-time ANH analytics. Unblocks downstream reporting 
on animal nutrition and ingredient performance. Required for Q2 
product launch.
```

### Reference Links

Link to related discovery and spec documents:

```
- Data contract: `docs/spec/02-source-systems/cnc/data-contracts.md`
- Connection details: `docs/spec/02-source-systems/cnc/connection.md`
- Sample data: `docs/spec/02-source-systems/cnc/sample-data/`
- Design ADR: `docs/spec/02-architecture/adr/0003-cnc-extraction.md`
```

### Dependencies

External systems or teams required:

```
- Boomi integration platform (IT setup and networking)
- Kafka cluster access and topic provisioning (Platform team)
- S3 bucket provisioning (Cloud Infrastructure)
- Database access and credentials (CNC admin)
- Network firewall rule approval for data egress
```

---

## Example (Filled) – Source Onboarding Epic

**Title**: `Minerva: Create the FDP for RMS Delacon Data`

**Description**: Domain: RMS. Project: ANH Delacon. Ingest 21 tables from `prd_internal_anh_delacon` using CDP Managed Ingest - Sqoop to deliver governed ingestion outputs for Spec Portfolio.

**Domain**: RMS

**Project**: ANH Delacon

**Ingestion Type**: CDP Managed Ingest - Sqoop

**Database Details**:
```
Database: prd_internal_anh_delacon
Total tables in scope: 21
```

**Key Success Metrics**:

- All 21 tables are ingested successfully
- Ingestion jobs complete within agreed batch windows
- Data quality checks pass for required columns and row-count reconciliation
- Spec Portfolio stakeholders validate data availability for downstream use

**Business Value**: Enables RMS Delacon data availability through a standardized FDP ingestion path for Spec Portfolio use cases.

**Project Context**:

- Team: Spec Portfolio Ingestion
- Delivery model: CDP Managed Ingest
- Extraction approach: Sqoop batch ingestion

**Goals**:

1. Configure CDP managed ingest for `prd_internal_anh_delacon`
2. Onboard and validate all 21 in-scope tables
3. Execute reconciliation and data quality checks
4. Publish ingestion runbook and support handoff

**Dependencies**:

- CDP managed ingest configuration and access
- Source database connectivity to `prd_internal_anh_delacon`
- Validation support from RMS/ANH data stakeholders

**Acceptance Criteria**:

- ✓ 21 tables are successfully ingested via CDP Managed Ingest - Sqoop
- ✓ Batch runs are repeatable and meet operational run windows
- ✓ Reconciliation checks are completed with no critical discrepancies
- ✓ Ingestion output is confirmed usable by the Spec Portfolio team
