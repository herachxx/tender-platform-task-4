-- Query 2:
-- Executor performance and ranking by bid results.

WITH executor_metrics AS (
    SELECT
        executor.id AS executor_id,
        company.name AS executor_company,
        COUNT(bid.id) AS total_bids,
        COUNT(bid.id) FILTER (
            WHERE bid.status = 'submitted'
        ) AS active_bids,
        COUNT(bid.id) FILTER (
            WHERE bid.status = 'accepted'
        ) AS won_bids,
        COUNT(bid.id) FILTER (
            WHERE bid.status = 'rejected'
        ) AS rejected_bids,
        COALESCE(
            SUM(bid.amount) FILTER (
                WHERE bid.status = 'accepted'
            ),
            0
        ) AS won_amount,
        ROUND(AVG(bid.amount), 2) AS average_bid_amount
    FROM executors AS executor
    JOIN companies AS company
        ON company.id = executor.company_id
    LEFT JOIN bids AS bid
        ON bid.executor_id = executor.id
    GROUP BY executor.id, company.name
)
SELECT
    executor_company,
    total_bids,
    active_bids,
    won_bids,
    rejected_bids,
    won_amount,
    average_bid_amount,
    ROUND(
        100.0 * won_bids / NULLIF(total_bids, 0),
        2
    ) AS win_rate_percent,
    RANK() OVER (
        ORDER BY won_bids DESC, won_amount DESC, average_bid_amount ASC
    ) AS performance_rank
FROM executor_metrics
ORDER BY performance_rank, executor_company;