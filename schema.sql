-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Represent books published by Harper Collins.
CREATE TABLE "books" (
    "id" INTEGER,
    "ISBN" TEXT NOT NULL UNIQUE,
    "title" TEXT NOT NULL,
    "genre" TEXT,
    "language" TEXT,
    "imprint" TEXT,
    "release_date" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- Represent authors who have published under Harper Collins.
CREATE TABLE "authors" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent books authored by authors.
CREATE TABLE "authored" (
    "book_id" INTEGER,
    "author_id" INTEGER,
    FOREIGN KEY("book_id") REFERENCES "books"("id"),
    FOREIGN KEY("author_id") REFERENCES "authors"("id")
);

-- Represent retailers that sell books published by Harper Collins.
CREATE TABLE "retailers" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent store locations that sell books published by Harper Collins.
CREATE TABLE "stores" (
    "id" INTEGER,
    "retailer_id" INTEGER,
    "city" TEXT,
    "state" TEXT,
    "region" TEXT,
    "zip" TEXT,
    "country" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("retailer_id") REFERENCES "retailers"("id")
);

-- Represent sales transactions of books published by Harper Collins.
CREATE TABLE "sales" (
    "id" INTEGER,
    "book_id" INTEGER,
    "format" TEXT,
    "retailer_id" INTEGER,
    "store_id" INTEGER,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "price" REAL NOT NULL,
    "quantity_sold" INTEGER NOT NULL,
    "revenue" REAL,
    PRIMARY KEY("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id"),
    FOREIGN KEY("retailer_id") REFERENCES "retailers"("id"),
    FOREIGN KEY("store_id") REFERENCES "stores"("id")
);

-- Represent inventory of physical books in production process.
CREATE TABLE "production" (
    "id" INTEGER,
    "book_id" INTEGER,
    "print_run" TEXT,
    "quantity_in_stock" INTEGER,
    "warehouse_location" TEXT,
    "unit_production_cost" REAL NOT NULL,
    "reorder_point" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);

-- Represent contract information for authors signed with Harper Collins.
CREATE TABLE "contracts" (
    "id" INTEGER,
    "book_id" INTEGER,
    "author_id" INTEGER,
    "advance_paid" REAL NOT NULL,
    "base_royalty_rate" REAL NOT NULL,
    "royalty_split" TEXT,
    "royalty_details" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id"),
    FOREIGN KEY("author_id") REFERENCES "authors"("id")
);

-- Create indexes to speed common searches.
CREATE INDEX "author_name_search" ON "authors" ("first_name", "last_name");
CREATE INDEX "book_title_search" ON "books" ("title");

-- Create view of books to be released in 2026.
CREATE VIEW "2026" AS
SELECT "id", "title"
FROM "books"
WHERE "release_date" LIKE '2026%';

