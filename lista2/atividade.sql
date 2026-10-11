/*1*/
CREATE OR REPLACE VIEW v_staff_performance AS
SELECT
    s.staff_id,
    s.first_name || ' ' || s.last_name AS staff_name,
    ci.city || ', ' || co.country AS store_location,
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    COALESCE(SUM(DISTINCT p.amount), 0) AS total_revenue
FROM staff s
LEFT JOIN store st
    ON s.store_id = st.store_id
LEFT JOIN address a
    ON st.address_id = a.address_id
LEFT JOIN city ci
    ON a.city_id = ci.city_id
LEFT JOIN country co
    ON ci.country_id = co.country_id
LEFT JOIN rental r
    ON s.staff_id = r.staff_id
LEFT JOIN payment p
    ON s.staff_id = p.staff_id
GROUP BY
    s.staff_id,
    s.first_name,
    s.last_name,
    ci.city,
    co.country;
/*2*/
CREATE MATERIALIZED VIEW mv_category_total_sales AS
SELECT
    c.category_id,
    c.name AS category_name,
    COALESCE(SUM(p.amount), 0) AS total_sales
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN inventory i ON fc.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name;

CREATE UNIQUE INDEX idx_mv_category_total_sales
ON mv_category_total_sales (category_id);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_category_total_sales;

/*3*/
CREATE INDEX idx_rental_open
ON rental (rental_date)
WHERE return_date IS NULL;

EXPLAIN ANALYZE
SELECT rental_id, rental_date, customer_id, staff_id
FROM rental
WHERE return_date IS NULL;
/*4*/
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_film_description_trgm
ON film
USING GIN (description gin_trgm_ops);

EXPLAIN ANALYZE
SELECT film_id, title, description
FROM film
WHERE description ILIKE '%documentary%'
   OR description ILIKE '%drama%';
/*5*/
CREATE INDEX idx_payment_customer_date
ON payment (customer_id, payment_date DESC);

EXPLAIN ANALYZE
SELECT *
FROM payment
WHERE customer_id = 1
ORDER BY payment_date DESC;
/*6*/
CREATE INDEX idx_customer_email_lower
ON customer (LOWER(email));

EXPLAIN ANALYZE
SELECT *
FROM customer
WHERE LOWER(email) = LOWER('MARY.SMITH@example.com');
/*7*/
CREATE OR REPLACE FUNCTION validar_datas_rental()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.return_date IS NOT NULL
       AND NEW.return_date < NEW.rental_date THEN
        RAISE EXCEPTION
            'A data de devolução não pode ser anterior à data de locação.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_datas_rental
BEFORE INSERT OR UPDATE ON rental
FOR EACH ROW
EXECUTE FUNCTION validar_datas_rental();