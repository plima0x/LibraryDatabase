CREATE OR REPLACE PACKAGE BODY pkg_book
IS

  PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                             p_ind_log IN system_logs.ind_log%TYPE)
  IS
    tip_log CONSTANT VARCHAR2(6) := 'BOKLOG';
  BEGIN
    -- Call the procedure for insert logs in the system log table.
    insert_logs(p_tip_log => tip_log,
               p_msg     => p_msg,
               p_ind_log => p_ind_log);

  END call_insert_logs;



-- Procedure for inserting books in books table.

  PROCEDURE insert_book(p_name           IN books.name%TYPE,
                        p_isbn           IN books.isbn%TYPE,
                        p_id_author      IN books.id_author%TYPE,
                        p_id_book_genre  IN books.id_book_genre%TYPE,
                        p_qtd_tot_book   IN books.qtd_tot_book%TYPE)
  IS
    id_book NUMBER;
  BEGIN
   -- Getting a new book id.
    SELECT NVL(MAX(id), 0) + 1
    INTO id_book
    FROM books;

    INSERT INTO books
                (id,
                name,
                isbn,
                id_author,
                id_book_genre,
                qtd_tot_book,
                qtd_curr_book)
                VALUES
                (id_book,
                 p_name,
                 p_isbn,
                 p_id_author,
                 p_id_book_genre,
                 p_qtd_tot_book,
                 p_qtd_tot_book);

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book inserted. Id: '|| id_book || '. Name: '|| p_name,
                     p_ind_log  => 'S');

  EXCEPTION

   WHEN OTHERS THEN
     CALL_INSERT_LOGS(p_msg     => 'Error while inserting a new book. Details: '|| SQLERRM,
                     p_ind_log => 'E');

  END insert_book;

-- Procedure for updating books in books table.

  PROCEDURE alter_book(p_id_book       IN books.id%TYPE,
                       p_name          IN books.name%TYPE,
                       p_isbn          IN books.isbn%TYPE,
                       p_id_author     IN books.id_author%TYPE,
                       p_id_book_genre IN books.id_book_genre%TYPE,
                       p_qtd_tot_book  IN books.qtd_tot_book%TYPE)
  IS
  BEGIN

    UPDATE books
    SET name       = NVL(p_name, name),
        isbn       = NVL(p_isbn, isbn),
        id_author  = NVL(p_id_author, id_author),
        id_book_genre   = NVL(p_id_book_genre, id_book_genre),
        qtd_tot_book = NVL(p_qtd_tot_book, qtd_tot_book)
          WHERE id = p_id_book;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book that has the id '|| p_id_book || ' was updated.',
                     p_ind_log => 'S');

  EXCEPTION
    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg     => 'Error while updating the book that has the id '|| p_id_book ||'. Details: '|| SQLERRM,
                       p_ind_log => 'E');

  END alter_book;

-- Procedure for deleting books in books table.

  PROCEDURE delete_book(p_id_book IN books.id%TYPE)
  IS
  BEGIN

    DELETE FROM books
    WHERE id = p_id_book;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book that has the id '|| p_id_book ||' was deleted.',
                     p_ind_log => 'S');

  EXCEPTION
     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg     => 'Error while deleting the book that has the id '|| p_id_book ||'. Details: '|| SQLERRM,
                        p_ind_log => 'E');
  END delete_book;

END pkg_book;
