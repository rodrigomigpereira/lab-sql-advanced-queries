## LAB | SQL Advanced queries

## In this lab, you will be using the Sakila database of movie rentals.

use sakila; ## Use the database sakila 

## Instructions
## List each pair of actors that have worked together.

select * from actor; ## columns --- actor_id, first_name, last_name, last_update
select * from film_actor; ## columns --- actor_id, film_id, last_update

SELECT DISTINCT a1.actor_id AS actor1_id, a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
                a2.actor_id AS actor2_id, a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name
	FROM film_actor fa1
		JOIN film_actor fa2 
        ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
			JOIN actor a1 
            ON fa1.actor_id = a1.actor_id
				JOIN actor a2 
                ON fa2.actor_id = a2.actor_id
					ORDER BY a1.actor_id, a2.actor_id;

## For each film, list actor that has acted in more films.

WITH actor_film_counts AS (
    SELECT fa.actor_id, COUNT(fa.film_id) AS film_count
    FROM film_actor fa
    GROUP BY fa.actor_id
	),
		film_actor_rankings AS (
			SELECT f.film_id, f.title, a.actor_id, a.first_name, a.last_name, afc.film_count,
				RANK() OVER (PARTITION BY f.film_id ORDER BY afc.film_count DESC) AS actor_rank
				FROM film f
					JOIN film_actor fa 
                    ON f.film_id = fa.film_id
						JOIN actor a 
                        ON fa.actor_id = a.actor_id
							JOIN actor_film_counts afc 
                            ON a.actor_id = afc.actor_id
			)
				SELECT film_id, title, actor_id, first_name, last_name, film_count
					FROM film_actor_rankings
						WHERE actor_rank = 1
							ORDER BY film_id;

