BEGIN;

INSERT INTO companies (name, registration_number, company_type) VALUES
    ('Aktobe City Procurement', 'KZ-CUST-001', 'customer'),
    ('Kazakhstan Rail Logistics', 'KZ-CUST-002', 'customer'),
    ('SteppeBuild', 'KZ-SUP-001', 'supplier'),
    ('TechnoSystems', 'KZ-SUP-002', 'supplier'),
    ('EcoLine', 'KZ-SUP-003', 'supplier'),
    ('QazSupply', 'KZ-SUP-004', 'supplier');

INSERT INTO executors (company_id, contact_name, contact_email, rating) VALUES
    (3, 'Ayan Sarsenov', 'ayan@steppebuild.example.com', 4.70),
    (4, 'Dana Karimova', 'dana@technosystems.example.com', 4.85),
    (5, 'Mira Orazova', 'mira@ecoline.example.com', 4.50),
    (6, 'Timur Bekturov', 'timur@qazsupply.example.com', 4.30);

INSERT INTO tenders (
    customer_company_id,
    title,
    description,
    status,
    starts_at,
    ends_at
) VALUES
    (
        1,
        'Road maintenance in Aktobe',
        'Procurement of materials and services for road maintenance.',
        'published',
        CURRENT_TIMESTAMP - INTERVAL '1 day',
        CURRENT_TIMESTAMP + INTERVAL '30 days'
    ),
    (
        2,
        'IT equipment for regional offices',
        'Procurement of laptops and server equipment.',
        'published',
        CURRENT_TIMESTAMP - INTERVAL '2 days',
        CURRENT_TIMESTAMP + INTERVAL '45 days'
    ),
    (
        1,
        'Office furniture procurement',
        'Completed procurement of office chairs.',
        'closed',
        CURRENT_TIMESTAMP - INTERVAL '90 days',
        CURRENT_TIMESTAMP - INTERVAL '30 days'
    );

INSERT INTO lots (
    tender_id,
    lot_number,
    title,
    description,
    quantity,
    unit,
    max_budget
) VALUES
    (1, 1, 'Road asphalt mix', 'Asphalt mix for maintenance works.', 1000, 'tonne', 18000000.00),
    (1, 2, 'Road signs', 'Traffic and warning road signs.', 250, 'piece', 7000000.00),
    (2, 1, 'Business laptops', 'Laptops for office employees.', 80, 'piece', 9000000.00),
    (2, 2, 'Application servers', 'Rack servers for regional offices.', 4, 'piece', 12500000.00),
    (3, 1, 'Ergonomic office chairs', 'Chairs for office workstations.', 100, 'piece', 2500000.00);

INSERT INTO bids (lot_id, executor_id, amount, status, submitted_at) VALUES
    (1, 1, 17500000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '12 hours'),
    (1, 2, 16900000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '10 hours'),
    (1, 3, 17850000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '8 hours'),

    (2, 1, 6500000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '9 hours'),
    (2, 3, 6200000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '7 hours'),
    (2, 4, 7000000.00, 'withdrawn', CURRENT_TIMESTAMP - INTERVAL '6 hours'),

    (3, 2, 8500000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '11 hours'),
    (3, 3, 8200000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '9 hours'),
    (3, 4, 8900000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '5 hours'),

    (4, 1, 12000000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '8 hours'),
    (4, 4, 11800000.00, 'submitted', CURRENT_TIMESTAMP - INTERVAL '4 hours'),

    (5, 1, 2200000.00, 'rejected', CURRENT_TIMESTAMP - INTERVAL '45 days'),
    (5, 3, 2100000.00, 'accepted', CURRENT_TIMESTAMP - INTERVAL '44 days');

COMMIT;