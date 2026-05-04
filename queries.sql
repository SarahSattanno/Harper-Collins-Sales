-- Queries related to the lifecycle of books.
-- Find contract information for all books written by Julia Quinn.
SELECT *
FROM "contracts"
WHERE "author_id" = (
    SELECT "id" FROM "authors"
    WHERE "first_name" = 'Julia' and "last_name" = 'Quinn'
);

-- Find warehouse location and quantity in stock for Katabasis by R.F. Kuang.
SELECT "warehouse_location", "quantity_in_stock"
FROM "production"
WHERE "book_id" = (
    SELECT "id" FROM "books"
    WHERE "title" = 'Katabasis'
);

-- List book title, warehouse location, and quantity in stock for all books set to release next month, April 2026.
-- Order by release date, earliest release first, and then by title alphabetically.
SELECT "title", "warehouse_location", "quantity_in_stock"
FROM "books"
JOIN "production" ON "books"."id" = "production"."book_id"
WHERE "release_date" LIKE '%2026-04-%'
ORDER BY "release_date", "title";

-- Queries related to sales of books.
-- The team is gearing up for the release of R.F. Kuang's new book, Taipei story.

-- 5 out of 6 of Kuang's published books have been in the fantasy genre, while her new book is in the style of Literary Fiction.
-- The team wants to know how the genre of Lit Fic is selling in 2025 compared to other genres.
-- Find total number of books sold by genre and total revenue by genre in 2025.
-- Order by highest number of books sold to least, then by highest to least total revenue, and then by genre aplabetically.
SELECT "genre", SUM("quantity_sold") AS "total_books_sold", ROUND(SUM("revenue"), 2) AS "total_revenue"
FROM "books"
JOIN "sales" ON "books"."id" = "sales"."book_id"
WHERE "sales"."date" LIKE '2025%'
GROUP BY "genre"
ORDER BY SUM("quantity_sold") DESC, SUM("revenue") DESC, "genre";

-- The team is considering the cities in which they should schedule Author Events for Kuang's upcoming book.
-- Find sales data by city for Kuang's last three published books.

-- First, find the last three books Kuang published.
SELECT "title"
FROM "books"
JOIN "authored" ON "books"."id" = "authored"."book_id"
JOIN "authors" ON "authored"."author_id" = "authors"."id"
WHERE "first_name" = 'R.F.' and "last_name" = 'Kuang'
and "release_date" < '2026-03-07'
ORDER BY "release_date" DESC
LIMIT 3;

-- We find the last 3 books published by Kuang are Babel, Katabasis and Yellowface.
-- Now, find the top 10 cities where the highest number of these three books were sold.
SELECT "city", "state", SUM("quantity_sold") AS "total_books_sold", ROUND(SUM("revenue"), 2) AS "total_revenue"
FROM "stores"
JOIN "sales" ON "stores"."id" = "sales"."store_id"
JOIN "books" ON "sales"."book_id" = "books"."id"
WHERE "title" IN ('Babel', 'Katabasis', 'Yellowface')
GROUP BY "city", "state"
ORDER BY SUM("quantity_sold") DESC, SUM("revenue") DESC, "city"
LIMIT 10;

-- csv data generation:
-- Generate realistic CSV data simulating books published by HarperCollins.
-- Include: 101 real HarperCollins authors, 300+ real books written by the 101 authors, realistic publication dates and genres, and multiple co-authors for some books.
-- Include contracts for all authors and books. Include titles that were released in 2025 and are to be released in the year 2026. Make sure there is data in the production table for all books in our dataset. Keep store data set within the U.S. having at least 500 stores. For the sales table, include at least 1,000 rows of data from the time span of January 2023 through March 2026. Ensure the csv data matches the schema exactly.

--Insert a book.
INSERT INTO "books" ("ISBN", "title", "genre", "language", "imprint", "release_date")
VALUES ('978-1-6680-9190-1', 'Untitled', 'Fantasy', 'English', 'HarperCollins', ' ');

--Insert book-author relationship.
INSERT INTO "authored" ("book_id", "author_id")
VALUES (364, 101),

--Insert a contract.
INSERT INTO "contracts" ("book_id", "author_id", "advance_paid", "base_royalty_rate", "royalty_split", "royalty_details")
VALUES (364, 101, 150000, 0.1186, '100%', 'Tiered digital/print split')

--Insert a retailer.
INSERT INTO "retailers" ("name")
VALUES ("Lizs Book Bar");

--Update release date of a book.
UPDATE "books" SET "release_date" = '2027-04-05'
WHERE "id" = 364;

--Update production information of a book.
UPDATE "production" SET "quantity_in_stock" = 28000
WHERE "book_id" = 1;

--Delete a store that's no longer in business.
DELETE FROM "stores" WHERE "store_id" = 273;
