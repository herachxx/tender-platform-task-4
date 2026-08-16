BEGIN;

CREATE TABLE companies (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    registration_number VARCHAR(32) NOT NULL UNIQUE,
    company_type VARCHAR(20) NOT NULL
        CHECK (company_type IN ('customer', 'supplier', 'both')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE executors (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id BIGINT NOT NULL UNIQUE
        REFERENCES companies(id) ON DELETE RESTRICT,
    contact_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255) NOT NULL UNIQUE,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 0
        CHECK (rating >= 0 AND rating <= 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tenders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_company_id BIGINT NOT NULL
        REFERENCES companies(id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'closed', 'cancelled')),
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (ends_at > starts_at)
);

CREATE TABLE lots (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tender_id BIGINT NOT NULL
        REFERENCES tenders(id) ON DELETE CASCADE,
    lot_number SMALLINT NOT NULL CHECK (lot_number > 0),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    quantity NUMERIC(14, 3) NOT NULL DEFAULT 1
        CHECK (quantity > 0),
    unit VARCHAR(30) NOT NULL DEFAULT 'item',
    max_budget NUMERIC(14, 2) NOT NULL
        CHECK (max_budget >= 0),
    UNIQUE (tender_id, lot_number)
);

CREATE TABLE bids (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lot_id BIGINT NOT NULL
        REFERENCES lots(id) ON DELETE CASCADE,
    executor_id BIGINT NOT NULL
        REFERENCES executors(id) ON DELETE RESTRICT,
    amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'submitted'
        CHECK (status IN ('submitted', 'withdrawn', 'accepted', 'rejected')),
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (lot_id, executor_id)
);

CREATE INDEX idx_tenders_customer_company_id
    ON tenders (customer_company_id);

CREATE INDEX idx_tenders_status_ends_at
    ON tenders (status, ends_at);

CREATE INDEX idx_bids_executor_id
    ON bids (executor_id);

CREATE INDEX idx_bids_lot_submitted_amount
    ON bids (lot_id, amount)
    WHERE status = 'submitted';

COMMIT;