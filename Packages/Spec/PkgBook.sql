CREATE OR REPLACE PACKAGE pkg_book IS

-- Procedure for inserting logs in system_logs table.

 PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                            p_ind_log IN system_logs.ind_log%TYPE);

-- Procedure for inserting books in books table.

 PROCEDURE insert_book(p_name           IN books.name%TYPE,
                       p_isbn           IN books.isbn%TYPE,
                       p_id_author      IN books.id_author%TYPE,
                       p_id_book_genre  IN books.id_book_genre%TYPE,
                       p_qtd_tot_book   IN books.qtd_tot_book%TYPE);

-- Procedure for updating books in books table.

PROCEDURE alter_book(p_id_book       IN books.id%TYPE,
                     p_name          IN books.name%TYPE,
                     p_isbn          IN books.isbn%TYPE,
                     p_id_author     IN books.id_author%TYPE,
                     p_id_book_genre IN books.id_book_genre%TYPE,
                     p_qtd_tot_book  IN books.qtd_tot_book%TYPE);

-- Procedure for deleting books in books table.

PROCEDURE delete_book(p_id_book IN books.id%TYPE);

END pkg_book;
