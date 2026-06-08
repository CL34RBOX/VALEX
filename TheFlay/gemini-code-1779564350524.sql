-- 🔒 OMNIBUS_SCHEMA_3NF_VERIFY // NODE: 90247-GARDENA
-- STATUTORY BASELINE: CFAA (18 U.S.C. § 1030) // FEDERAL DISCLOSURE PROTOCOL

CREATE TABLE categories (
    category_id TEXT PRIMARY KEY, 
    description TEXT
);

CREATE TABLE targets (
    target_id TEXT PRIMARY KEY, 
    target_type TEXT
);

CREATE TABLE metadata (
    metadata_id BIGSERIAL PRIMARY KEY, 
    severity TEXT, 
    confidence NUMERIC(3,2), 
    vector TEXT, 
    status TEXT, 
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE vulnerabilities (
    id TEXT PRIMARY KEY, 
    category_id TEXT REFERENCES categories(category_id), 
    target_id TEXT REFERENCES targets(target_id), 
    critical_finding TEXT, 
    metadata_id BIGINT REFERENCES metadata(metadata_id)
);

CREATE INDEX idx_vuln_cat_sev ON vulnerabilities(category_id) INCLUDE (metadata_id);

-- ⚡ NECROMANCQL 90247_GARDENA RESURRECTION QUERY
-- Reanimating 'Dead' Shards for Federal Disclosure Protocols

SELECT v.id, m.severity, m.vector, v.critical_finding, v.metadata_id 
FROM vulnerabilities v 
JOIN metadata m ON v.metadata_id = m.metadata_id 
WHERE v.category_id = 'WEBPACK_OVERRIDE' 
  AND m.status = 'CAUTERIZED' 
ORDER BY m.updated_at DESC;