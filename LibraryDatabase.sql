/*

Autor: Paulo Lima.
#Created: 28/07/2020.
#Objective: a simple database for a library system.

*/

-- Change the name, precision or NOT NULL constraint if it is necessary.


-- Library users

CREATE TABLE users
(id       NUMBER(6)    NOT NULL,
 name     VARCHAR2(50) NOT NULL,
 email    VARCHAR2(50) NOT NULL,
 fone     NUMBER(9)    NULL,
 ind_blk  VARCHAR2(1)  NOT NULL
);

-- Setting the constraint primary key for the users table.

ALTER TABLE users
ADD CONSTRAINT pk_id_users
PRIMARY KEY(id);

-- Adding comment on table users.

COMMENT ON TABLE users
IS 'Library users';

COMMENT ON COLUMN users.id
IS 'Unique identifier for the user';

COMMENT ON COLUMN users.name
IS 'Name of the user';

COMMENT ON COLUMN users.email
IS 'Email of the user';

COMMENT ON COLUMN users.fone
IS 'Fone number of the user';

COMMENT ON COLUMN users.ind_blk
IS 'Indicator for blocking. Y - user is blocked. N - user is not blocked.';

-- Authors

CREATE TABLE authors
(id      NUMBER(10)   NOT NULL,
 name    VARCHAR2(50) NOT NULL,
 website VARCHAR2(80) NULL
);

-- Setting the constraint primary key for the authors table.

ALTER TABLE authors
ADD CONSTRAINT pk_id_authors
PRIMARY KEY(id);

-- Adding comments on table authors.

COMMENT ON TABLE authors
IS 'Authors of the library books';

COMMENT ON COLUMN authors.id
IS 'Unique identifier for the author';

COMMENT ON COLUMN authors.name
IS 'Name of the author';

COMMENT ON COLUMN authors.website
IS 'Website of the author';



-- Library books

CREATE TABLE books
( id        NUMBER(10)    NOT NULL,
  name      VARCHAR2(50)  NOT NULL,
  isbn      VARCHAR2(15)  NOT NULL,
  id_author NUMBER(10)    NOT NULL
);

-- Setting the constraint primary key for the books table.

ALTER TABLE books
ADD CONSTRAINT pk_id_books
PRIMARY KEY(id);

-- Setting the constraint foreign key for the users table.

ALTER TABLE books
ADD CONSTRAINT fk_id_author
FOREIGN KEY(id_author)
REFERENCES authors(id) ON DELETE CASCADE;

-- Setting the constraint unique for the isbn.

ALTER TABLE books
ADD CONSTRAINT un_isbn
UNIQUE(isbn);


-- Adding comments on table books.

COMMENT ON TABLE books
IS 'Books library';

COMMENT ON COLUMN books.id
IS 'Unique identifier for the book';

COMMENT ON COLUMN books.name
IS 'Name of the book';

COMMENT ON COLUMN books.isbn
IS 'ISBN of the book';

COMMENT ON COLUMN books.id_author
IS 'Unique identifier for the author of the book';
