# Challenge 1 - Most Profiting Authors

SELECT au_id, royalty_aggreg + advance AS total_profits
	FROM (SELECT au_id, title_id, sum(sales_royalty) AS royalty_aggreg, advance
		FROM (SELECT au.au_id, ti.title_id, 
		ti.advance * ta.royaltyper / 100 AS advance,
		ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 AS sales_royalty
		FROM authors AS au
		JOIN titleauthor AS ta ON au.au_id = ta.au_id
		JOIN titles AS ti ON ta.title_id = ti.title_id
		JOIN sales AS sa ON ti.title_id = sa.title_id) AS total_royalties
	GROUP BY au_id, title_id
	ORDER BY sum(sales_royalty) DESC) AS author_profits
ORDER BY total_profits DESC;


#Challenge 2 - Aggregate total royalties for each title and author

CREATE TEMPORARY TABLE total_royalty
SELECT au.au_id, ti.title_id, 
ti.advance * ta.royaltyper / 100 AS advance,
ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 AS sales_royalty
FROM authors AS au
JOIN titleauthor AS ta ON au.au_id = ta.au_id
JOIN titles AS ti ON ta.title_id = ti.title_id
JOIN sales AS sa ON ti.title_id = sa.title_id;

CREATE TEMPORARY TABLE author_profits
SELECT au_id, title_id, sum(sales_royalty) AS royalty_aggreg, advance
FROM total_royalty
GROUP BY au_id, title_id, advance
ORDER BY sum(sales_royalty) DESC;


SELECT au_id, royalty_aggreg + advance AS total_profits
FROM author_profits
ORDER BY total_profits DESC;


# Challenge 3

CREATE TABLE `most_profiting_authors`
SELECT au_id, royalty_aggreg + advance AS total_profits
	FROM (SELECT au_id, title_id, sum(sales_royalty) AS royalty_aggreg, advance
		FROM (SELECT au.au_id, ti.title_id, 
		ti.advance * ta.royaltyper / 100 AS advance,
		ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 AS sales_royalty
		FROM authors AS au
		JOIN titleauthor AS ta ON au.au_id = ta.au_id
		JOIN titles AS ti ON ta.title_id = ti.title_id
		JOIN sales AS sa ON ti.title_id = sa.title_id) AS total_royalties
	GROUP BY au_id, title_id
	ORDER BY sum(sales_royalty) DESC) AS author_profits
ORDER BY total_profits DESC;