-- Query 1:
-- Active tenders, their lots, the number of active bids,
-- the lowest bid amount, and the company that made it.

WITH submitted_bid_stats AS (
    SELECT
        lot_id,
        COUNT(*) AS submitted_bids_count,
        MIN(amount) AS lowest_submitted_amount
    FROM bids
    WHERE status = 'submitted'
    GROUP BY lot_id
),
ranked_submitted_bids AS (
    SELECT
        lot_id,
        executor_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY lot_id
            ORDER BY amount ASC, submitted_at ASC
        ) AS bid_rank
    FROM bids
    WHERE status = 'submitted'
)
SELECT
    customer.name AS customer_company,
    t.id AS tender_id,
    t.title AS tender_title,
    l.lot_number,
    l.title AS lot_title,
    l.max_budget,
    COALESCE(stats.submitted_bids_count, 0) AS submitted_bids_count,
    stats.lowest_submitted_amount,
    supplier.name AS lowest_bidder_company
FROM tenders AS t
JOIN companies AS customer
    ON customer.id = t.customer_company_id
JOIN lots AS l
    ON l.tender_id = t.id
LEFT JOIN submitted_bid_stats AS stats
    ON stats.lot_id = l.id
LEFT JOIN ranked_submitted_bids AS ranked_bid
    ON ranked_bid.lot_id = l.id
    AND ranked_bid.bid_rank = 1
LEFT JOIN executors AS executor
    ON executor.id = ranked_bid.executor_id
LEFT JOIN companies AS supplier
    ON supplier.id = executor.company_id
WHERE t.status = 'published'
  AND t.ends_at > CURRENT_TIMESTAMP
ORDER BY t.ends_at, l.lot_number;