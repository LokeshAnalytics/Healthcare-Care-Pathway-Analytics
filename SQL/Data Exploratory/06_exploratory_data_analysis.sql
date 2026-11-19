-- Exploratory data analysis

-- 1.Overall business overview

SELECT *
FROM authorizations_staging;

#total_members
SELECT COUNT(DISTINCT member_id) AS total_member
FROM members_staging;

#total_employers
SELECT COUNT(DISTINCT employer_id) AS total_employers
FROM employers_staging;

#total_providers
SELECT COUNT(DISTINCT provider_id) AS total_providers
FROM providers_staging;

#total_member_events
SELECT COUNT(*) AS total_member_events
FROM member_events_staging;

#total_authorization_request
SELECT COUNT(*) AS total_authorizations_request
FROM authorizations_staging;

#Approved,Rejected and Pending request
SELECT authorization_status, 
       COUNT(*) AS total_authorization_request
FROM authorizations_staging
GROUP BY authorization_status;

#unique_member_with-events
SELECT COUNT(DISTINCT member_id) AS unique_member_with_events
FROM member_events_staging;

#unique_member_with_authorization
SELECT COUNT(DISTINCT member_id) AS unique_member_with_authorization
FROM authorizations_staging;

-- 2.Member engagement analysis 

#members with at least one event

SELECT DISTINCT member_id
FROM member_events_staging;

#members wihout any recorded event

SELECT M1.member_id
FROM members_staging AS M1
LEFT JOIN member_events_staging AS M2
         ON M1.member_id = M2.member_id
WHERE M2.member_id IS NULL;
      
#total events by event type

SELECT event_type,
       COUNT(*) AS total_events
FROM member_events_staging
GROUP BY event_type;

#Average events per member

WITH avg_CTE AS
(
    SELECT member_id,
           COUNT(event_type) AS event_participate
     FROM member_events_staging
     GROUP BY member_id
)
SELECT  AVG(event_participate) AS average_events_per_member
FROM avg_CTE;

#memebrs with highest number of events

WITH member_event_count AS
(
     SELECT member_id,
			COUNT(*) AS total_events
	FROM member_events_staging
    GROUP BY member_id
)
SELECT member_id
FROM member_event_count
WHERE total_events = (
                       SELECT MAX(total_events)
                       FROM member_event_count
);

#event distribution by month

SELECT YEAR(event_date) AS event_year,
       MONTH(event_date) AS event_month,
       COUNT(*) AS total_events
FROM member_events_staging
GROUP BY YEAR(event_date), MONTH(event_date)
ORDER BY YEAR(event_date), MONTH(event_date) ;


-- 3.authorization performance

#how many authorization approved,reject and pending

SELECT authorization_status,
       COUNT(*) AS status_count
FROM authorizations_staging
GROUP BY authorization_status;

#what is the approval rate

WITH approval_CTE AS
(
    SELECT COUNT(authorization_status) AS approved_authorization
    FROM authorizations_staging 
    WHERE authorization_status = 'Approved'
),
total_CTE AS
(
    SELECT COUNT(*) AS total_authorization
    FROM authorizations_staging
)
SELECT ROUND((approved_authorization / total_authorization) * 100, 2) AS approval_rate
FROM approval_CTE 
JOIN total_CTE;

#what is rejection rate

WITH rejection_CTE AS
(
    SELECT COUNT(authorization_status) AS rejection_authorization
    FROM authorizations_staging 
    WHERE authorization_status = 'Rejected'
),
total_CTE AS
(
    SELECT COUNT(*) AS total_authorization
    FROM authorizations_staging
)
SELECT ROUND((rejection_authorization / total_authorization) * 100, 2) AS rejection_rate
FROM rejection_CTE 
JOIN total_CTE;

#what is pending rate

WITH pending_CTE AS
(
    SELECT COUNT(authorization_status) AS pending_authorization
    FROM authorizations_staging 
    WHERE authorization_status = 'Pending'
),
total_CTE AS
(
    SELECT COUNT(*) AS total_authorization
    FROM authorizations_staging
)
SELECT ROUND((pending_authorization / total_authorization) * 100, 2) AS pending_rate
FROM pending_CTE 
JOIN total_CTE;

#Average authorization decision time

SELECT ROUND( 
               AVG(DATEDIFF(decision_date, request_date) ), 2
               ) AS avg_decision_days
FROM authorizations_staging
WHERE decision_date IS NOT NULL;

#Highest approved providers

WITH highest_CTE AS
(
   SELECT PRO.provider_id AS provider_id,
		  PRO.provider_name AS provider_name,
          COUNT(*) AS approved_count
	FROM providers_staging AS PRO
    JOIN authorizations_staging AS AU
       ON PRO.provider_id = AU.provider_id
	WHERE authorization_status = 'Approved'
    GROUP BY PRO.provider_id, PRO.provider_name
)
SELECT provider_id,
       provider_name,
       approved_count
FROM highest_CTE
WHERE approved_count = (
                         SELECT MAX(approved_count)
                         FROM highest_CTE
);
    
    
-- 4.Care pathway analysis

#number of members at each care pathway stage

SELECT
    event_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT member_id) AS unique_members
FROM member_events_staging
GROUP BY event_type
ORDER BY unique_members DESC;

#percentage of members participating in each stage

SELECT
    event_type,
    COUNT(DISTINCT member_id) AS unique_members,
    ROUND(
        COUNT(DISTINCT member_id) * 100.0 /
        (SELECT COUNT(*) FROM members_staging),
        2
    ) AS participation_rate
FROM member_events_staging
GROUP BY event_type
ORDER BY participation_rate DESC;

#monthly healthcare activity

SELECT
    DATE_FORMAT(event_date, '%Y-%m') AS event_month,
    COUNT(*) AS total_events,
    COUNT(DISTINCT member_id) AS active_members
FROM member_events_staging
GROUP BY DATE_FORMAT(event_date, '%Y-%m')
ORDER BY event_month;

-- 5.Provider performance analysis

#authorization requests handled by each provider

SELECT
    P.provider_id,
    P.provider_name,
    P.provider_type,
    P.state,
    COUNT(A.authorization_id) AS total_requests
FROM providers_staging AS P
LEFT JOIN authorizations_staging AS A
    ON P.provider_id = A.provider_id
GROUP BY
    P.provider_id,
    P.provider_name,
    P.provider_type,
    P.state
ORDER BY total_requests DESC;

#provider approval and rejection rates

SELECT
    P.provider_id,
    P.provider_name,
    COUNT(A.authorization_id) AS total_requests,

    SUM(CASE
        WHEN A.authorization_status = 'Approved' THEN 1
        ELSE 0
    END) AS approved_requests,

    SUM(CASE
        WHEN A.authorization_status = 'Rejected' THEN 1
        ELSE 0
    END) AS rejected_requests,

    SUM(CASE
        WHEN A.authorization_status = 'Pending' THEN 1
        ELSE 0
    END) AS pending_requests,

    ROUND(
        SUM(CASE
            WHEN A.authorization_status = 'Approved' THEN 1
            ELSE 0
        END) * 100.0 /
        NULLIF(COUNT(A.authorization_id), 0),
        2
    ) AS approval_rate

FROM providers_staging AS P
LEFT JOIN authorizations_staging AS A
    ON P.provider_id = A.provider_id
GROUP BY P.provider_id, P.provider_name
ORDER BY approval_rate DESC;

#average authorization decision time by provider

SELECT
    P.provider_id,
    P.provider_name,
    COUNT(A.authorization_id) AS total_requests,

    ROUND(
        AVG(DATEDIFF(A.decision_date, A.request_date)),
        2
    ) AS avg_decision_days

FROM providers_staging AS P
LEFT JOIN authorizations_staging AS A
    ON P.provider_id = A.provider_id
GROUP BY P.provider_id, P.provider_name
ORDER BY avg_decision_days;

-- 6.Employer and benefit plan analysis

#number of members by employer

SELECT
    E.employer_id,
    E.employer_name,
    E.benefit_plan,
    COUNT(M.member_id) AS total_members
FROM employers_staging AS E
LEFT JOIN members_staging AS M
    ON E.employer_id = M.employer_id
GROUP BY
    E.employer_id,
    E.employer_name,
    E.benefit_plan
ORDER BY total_members DESC;

#member distribution by benefit plan

SELECT
    E.benefit_plan,
    COUNT(M.member_id) AS total_members,
    COUNT(DISTINCT E.employer_id) AS total_employers
FROM employers_staging AS E
LEFT JOIN members_staging AS M
    ON E.employer_id = M.employer_id
GROUP BY E.benefit_plan
ORDER BY total_members DESC;

#member engagement by employer

SELECT
    E.employer_id,
    E.employer_name,
    COUNT(DISTINCT M.member_id) AS total_members,
    COUNT(DISTINCT ME.member_id) AS members_with_events,
    ROUND(
        COUNT(DISTINCT ME.member_id) * 100.0 /
        NULLIF(COUNT(DISTINCT M.member_id), 0),
        2
    ) AS engagement_rate
FROM employers_staging AS E
LEFT JOIN members_staging AS M
    ON E.employer_id = M.employer_id
LEFT JOIN member_events_staging AS ME
    ON M.member_id = ME.member_id
GROUP BY E.employer_id, E.employer_name
ORDER BY engagement_rate DESC;

#authorization performance by benefit plan

WITH plan_authorizations AS
(
    SELECT
        E.benefit_plan,
        COUNT(A.authorization_id) AS total_requests,

        SUM(CASE
            WHEN A.authorization_status = 'Approved' THEN 1
            ELSE 0
        END) AS approved_requests,

        SUM(CASE
            WHEN A.authorization_status = 'Rejected' THEN 1
            ELSE 0
        END) AS rejected_requests,

        SUM(CASE
            WHEN A.authorization_status = 'Pending' THEN 1
            ELSE 0
        END) AS pending_requests

    FROM employers_staging AS E
    JOIN members_staging AS M
        ON E.employer_id = M.employer_id
    JOIN authorizations_staging AS A
        ON M.member_id = A.member_id
    GROUP BY E.benefit_plan
)
SELECT
    benefit_plan,
    total_requests,
    approved_requests,
    rejected_requests,
    pending_requests,
    ROUND(
        approved_requests * 100.0 /
        NULLIF(total_requests, 0),
        2
    ) AS approval_rate
FROM plan_authorizations
ORDER BY approval_rate DESC;


-- 7.Member demographics analysis

#members by age group

SELECT
    age_group,
    COUNT(*) AS total_members
FROM members_staging
GROUP BY age_group
ORDER BY total_members DESC;

#members by country

SELECT
    country,
    COUNT(*) AS total_members
FROM members_staging
GROUP BY country
ORDER BY total_members DESC;

#monthly member enrollment trend

SELECT
    DATE_FORMAT(enrollment_date, '%Y-%m') AS enrollment_month,
    COUNT(*) AS new_members
FROM members_staging
GROUP BY DATE_FORMAT(enrollment_date, '%Y-%m')
ORDER BY enrollment_month;

