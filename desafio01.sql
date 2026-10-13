

DROP MATERIALIZED VIEW IF EXISTS mv_driver_season_summary;

CREATE MATERIALIZED VIEW mv_driver_season_summary AS
SELECT
    r.year,
    d.driver_id,
    d.full_name AS driver_name,

    COUNT(*) AS total_corridas,

    COUNT(
        CASE WHEN rd.position_number = 1 THEN 1 END
    ) AS vitorias,

    COUNT(
        CASE WHEN rd.position_number <= 3 THEN 1 END
    ) AS podios,

    COUNT(
        CASE WHEN rd.race_reason_retired IS NOT NULL THEN 1 END
    ) AS abandonos,

    COALESCE(SUM(rd.points), 0) AS total_pontos

FROM race_data rd
JOIN race r
    ON r.id = rd.race_id
JOIN driver d
    ON d.id = rd.driver_id

WHERE rd.type = 'RACE_RESULT'

GROUP BY
    r.year,
    d.driver_id,
    d.full_name;



CREATE UNIQUE INDEX idx_mv_driver_season_summary
ON mv_driver_season_summary (year, driver_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_driver_season_summary;

SELECT *
FROM mv_driver_season_summary
WHERE driver_name ILIKE '%Ayrton Senna%'
ORDER BY year DESC
LIMIT 10;


DROP TABLE IF EXISTS points_adjustment_audit;

CREATE TABLE points_adjustment_audit (
    id         SERIAL PRIMARY KEY,
    year       INT NOT NULL,
    driver_id  VARCHAR(100) NOT NULL,
    old_points DECIMAL(8,2),
    new_points DECIMAL(8,2),
    changed_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_points_adjustment()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    
    IF OLD.points IS DISTINCT FROM NEW.points THEN

        INSERT INTO points_adjustment_audit (
            year,
            driver_id,
            old_points,
            new_points,
            changed_at
        )
        VALUES (
            OLD.year,
            OLD.driver_id,
            OLD.points,
            NEW.points,
            NOW()
        );

    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_points_adjustment
ON season_driver_standing;

CREATE TRIGGER trg_audit_points_adjustment
AFTER UPDATE OF points
ON season_driver_standing
FOR EACH ROW
EXECUTE FUNCTION audit_points_adjustment();


UPDATE season_driver_standing sds
SET points = points + 100
WHERE sds.year = 1993
  AND sds.driver_id = (
      SELECT d.id
      FROM driver d
      WHERE d.full_name ILIKE '%Ayrton Senna%'
      LIMIT 1
  );

SELECT *
FROM points_adjustment_audit
WHERE year = 1993
ORDER BY changed_at DESC;

CREATE OR REPLACE FUNCTION prevent_driver_delete_with_history()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF EXISTS (
        SELECT 1
        FROM race_data rd
        WHERE rd.driver_id = OLD.id
    ) THEN

        RAISE EXCEPTION