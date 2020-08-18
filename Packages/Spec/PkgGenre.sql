CREATE OR REPLACE PACKAGE pkg_book_genre IS

-- Procedure for inserting logs in system_logs table.

 PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                            p_ind_log IN system_logs.ind_log%TYPE);

-- Procedure for inserting book genres in book genres table.

 PROCEDURE insert_book_genre(p_name IN book_genre.name%TYPE);

-- Procedure for updating book genres in book genres table.

PROCEDURE alter_book_genre(p_id_book_genre IN book_genre.id%TYPE,
                      p_name    IN book_genre.name%TYPE);

-- Procedure for deleting book genres in book genres table.

PROCEDURE delete_book_genre(p_id_book_genre IN book_genre.id%TYPE);

END pkg_book_genre;
