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
 fone     NUMBER(11)    NULL,
 ind_blk  VARCHAR2(1)  NOT NULL
);

-- Setting the constraint primary key for the users table.

ALTER TABLE users
ADD CONSTRAINT pk_id_users
PRIMARY KEY(id);

-- Setting the constraint check for the ind_blk column.

ALTER TABLE users
ADD CONSTRAINT ch_ind_blk
CHECK(ind_blk IN ('S', 'N'));

-- Setting the constraint unique for the email column.

ALTER TABLE users
ADD CONSTRAINT un_email
UNIQUE(email);


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
( id             NUMBER(10)    NOT NULL,
  name           VARCHAR2(50)  NOT NULL,
  isbn           VARCHAR2(15)  NOT NULL,
  id_author      NUMBER(10)    NOT NULL,
  id_book_genre  NUMBER(10)    NOT NULL,
  qtd_tot_book   NUMBER(5)     NOT NULL,
  qtd_curr_book  NUMBER(5)     NOT NULL
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

-- Setting the constraint foreign key for the genre table.

ALTER TABLE books
ADD CONSTRAINT fk_id_book_genre
FOREIGN KEY(id_book_genre)
REFERENCES book_genre(id) ON DELETE CASCADE;

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

COMMENT ON COLUMN books.id_book_genre
IS 'Unique identifier for the genre of the book';

COMMENT ON COLUMN books.qtd_tot_book
IS 'Quantities of the book';

COMMENT ON COLUMN books.qtd_curr_book
IS 'Available quantity of the book';



CREATE TABLE book_genre
( id    NUMBER(10)    NOT NULL,
  name  VARCHAR2(50)  NOT NULL
);


-- Setting the constraint primary key for the genres table.


ALTER TABLE book_genre
ADD CONSTRAINT pk_id_book_genre
PRIMARY KEY (id);

-- Setting the constraint unique for the name column.

ALTER TABLE book_genre
ADD CONSTRAINT un_name_genre
UNIQUE(name);

-- Adding comments on table genres.

COMMENT ON TABLE book_genre
IS 'Genres of the books';

COMMENT ON COLUMN book_genre.id
IS 'Unique identifier for the genre';

COMMENT ON COLUMN book_genre.name
IS 'Name of the genre. Ex: Science fiction';

-- Book loan

CREATE TABLE book_loan
( id            NUMBER(10) NOT NULL,
  id_user       NUMBER(10) NOT NULL,
  id_book       NUMBER(10) NOT NULL,
  init_dat      DATE       NOT NULL,
  end_dat       DATE       NOT NULL,
  give_back_dat DATE       NULL,
  ind_renew VARCHAR2(1) NOT NULL
);


-- Setting the constraint primary key for the genres table.

ALTER TABLE book_loan
ADD CONSTRAINT pk_id_loan
PRIMARY KEY(id);


-- Setting the constraint foreign key id_user.


ALTER TABLE book_loan
ADD CONSTRAINT fk_id_user
FOREIGN KEY(id_user)
REFERENCES users(id);


-- Setting the constraint foreign key for the id_book.


ALTER TABLE book_loan
ADD CONSTRAINT fk_id_book
FOREIGN KEY(id_book)
REFERENCES books(id);

-- Setting the constraint check for the ind_renew.

ALTER TABLE book_loan
ADD CONSTRAINT ch_ind_renew CHECK (ind_renew IN ('S', 'N'));


-- Adding comments on table book_loan.

COMMENT ON TABLE book_loan
IS 'Book loan table';


COMMENT ON COLUMN book_loan.id
IS 'Unique identifier for the book loan';

COMMENT ON COLUMN book_loan.id_user
IS 'Unique identifier for the user';

COMMENT ON COLUMN book_loan.id_book
IS 'Unique identifier for the book';

COMMENT ON COLUMN book_loan.init_dat
IS 'Initial date of the loan';

COMMENT ON COLUMN book_loan.end_dat
IS 'End date of the loan';

  COMMENT ON COLUMN book_loan.give_back_dat
  IS 'Date when the user gives back the book';

-- Sytem logs

CREATE TABLE system_logs
( id        NUMBER(10)      NOT NULL,
  type_log  VARCHAR2(6)     NOT NULL,
  dat_log   DATE            NOT NULL,
  msg       VARCHAR2(2000)  NOT NULL,
  ind_log   VARCHAR2(1)     NOT NULL
);

ALTER TABLE system_logs
ADD CONSTRAINT pk_id_logs
PRIMARY KEY(id);

ALTER TABLE system_logs
ADD CONSTRAINT ch_ind_log CHECK( ind_log IN ('E', 'S'));

COMMENT ON TABLE system_logs
IS 'System logs table';

COMMENT ON COLUMN system_logs.id
IS 'Unique identifier for the system logs';

COMMENT ON COLUMN system_logs.type_log
IS 'Type of the log';

COMMENT ON COLUMN system_logs.dat_log
IS 'Date of the log';

COMMENT ON COLUMN system_logs.msg
IS 'Message of the log';

COMMENT ON COLUMN system_logs.ind_log
IS 'Indicator if is a error log (E) or a success log (S)';
