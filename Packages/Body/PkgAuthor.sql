CREATE OR REPLACE PACKAGE BODY pkg_author
IS

   -- Call the procedure for insert logs in the system log table.

    PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                               p_ind_log IN system_logs.ind_log%TYPE)
    IS
      tip_log CONSTANT VARCHAR2(6) := 'AUTLOG';
    BEGIN

      insert_logs(p_tip_log => tip_log,
                  p_msg     => p_msg,
                  p_ind_log => p_ind_log);

    END call_insert_logs;

    -- Procedure for inserting the authors in authors table.

  PROCEDURE insert_author(p_name    IN authors.name%TYPE,
                          p_website IN authors.website%TYPE)

  IS
    id_author NUMBER;
  BEGIN
    -- Getting a new author id.
    SELECT NVL(MAX(id), 0) + 1
    INTO id_author
    FROM authors;

    INSERT INTO authors
                (id,
                 name,
                 website)
                VALUES
                (id_author,
                 p_name,
                 p_website);
    COMMIT;
    CALL_INSERT_LOGS(p_msg =>  'Author inserted. Id: '|| id_author || '. Name: '|| p_name,
                     p_ind_log => 'S');

  EXCEPTION
    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg =>  'Error while inserting a new author. Details: '|| SQLERRM,
                       p_ind_log => 'E');


  END insert_author;

  -- Procedure for updating authors in authors table.

  PROCEDURE alter_author(p_id_author IN authors.id%TYPE,
                         p_name    IN authors.name%TYPE,
                         p_website IN authors.website%TYPE)
  IS
  BEGIN
    UPDATE authors
    SET name    = NVL(p_name, name),
        website = NVL(p_website, website)
       WHERE id = p_id_author;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Author that has the id '|| p_id_author || 'was updated.',
                     p_ind_log => 'S');
  EXCEPTION
    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg =>  'Error while updating the author that has the id'|| p_id_author ||'. Details: '|| SQLERRM,
                       p_ind_log => 'E');

  END alter_author;

  -- Procedure for deleting authors in authors table

  PROCEDURE delete_author(p_id_author IN authors.id%TYPE)
  IS
  BEGIN

    DELETE FROM authors
    WHERE id = p_id_author;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Author that has the id '|| p_id_author || 'was deleted.',
                     p_ind_log => 'S');

   EXCEPTION
     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg =>  'Error while deleting the author that has the id'|| p_id_author ||'. Details: '|| SQLERRM,
                        p_ind_log => 'E');

  END delete_author;

END pkg_author;
