CREATE OR REPLACE PACKAGE BODY pkg_book_genre
IS

  PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                             p_ind_log IN system_logs.ind_log%TYPE)
  IS
    tip_log CONSTANT VARCHAR2(6) := 'GNRLOG';
  BEGIN
    -- Call the procedure for insert logs in the system log table.
    insert_logs(p_tip_log => tip_log,
                p_msg     => p_msg,
                p_ind_log => p_ind_log);

  END call_insert_logs;

-- Procedure for inserting book genres in genres table.

  PROCEDURE insert_book_genre(p_name IN book_genre.name%TYPE)
  IS
    id_book_genre NUMBER;
  BEGIN
   -- Getting a new genre id.
    SELECT NVL(MAX(id), 0) + 1
    INTO id_book_genre
    FROM book_genre;

    INSERT INTO book_genre
                (id,
                name)
                VALUES
                (id_book_genre,
                 p_name);

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book genre inserted. Id: '|| id_book_genre || '. Name: '|| p_name,
                     p_ind_log  => 'S');

  EXCEPTION

   WHEN OTHERS THEN
     CALL_INSERT_LOGS(p_msg     => 'Error while inserting a new book genre. Details: '|| SQLERRM,
                     p_ind_log => 'E');

  END insert_book_genre;

-- Procedure for updating book genres in book genres table.

  PROCEDURE alter_book_genre(p_id_book_genre IN book_genre.id%TYPE,
                            p_name          IN book_genre.name%TYPE)
  IS
  BEGIN

    UPDATE book_genre
    SET name = NVL(p_name, name)
     WHERE id = p_id_book_genre;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book genre that has the id '|| p_id_book_genre || ' was updated.',
                     p_ind_log => 'S');

  EXCEPTION
    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg     => 'Error while updating genre that has the id '|| p_id_book_genre ||'. Details: '|| SQLERRM,
                       p_ind_log => 'E');

  END alter_book_genre;

-- Procedure for deleting book genres in book genres table.

  PROCEDURE delete_book_genre(p_id_book_genre IN book_genre.id%TYPE)
  IS
  BEGIN

    DELETE FROM book_genre
    WHERE id = p_id_book_genre;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book genre that has the id '|| p_id_book_genre ||' was deleted.',
                     p_ind_log => 'S');

  EXCEPTION
     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg     => 'Error while deleting the Book genre that has the id '|| p_id_book_genre ||'. Details: '|| SQLERRM,
                        p_ind_log => 'E');
  END delete_book_genre;

END pkg_book_genre;
