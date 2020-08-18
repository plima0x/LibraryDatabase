CREATE OR REPLACE PACKAGE BODY pkg_user
IS

  PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                             p_ind_log IN system_logs.ind_log%TYPE)
  IS
    tip_log CONSTANT VARCHAR2(6) := 'USRLOG';
  BEGIN
    -- Call the procedure for insert logs in the system log table.
    insert_logs(p_tip_log => tip_log,
                p_msg     => p_msg,
                p_ind_log => p_ind_log);

  END call_insert_logs;



-- Procedure for inserting users in users table.

  PROCEDURE insert_user(p_name  IN users.name%TYPE,
                        p_email IN users.email%TYPE,
                        p_fone  IN users.fone%TYPE)
  IS
    id_user NUMBER;
  BEGIN
   -- Getting a new user id.
    SELECT NVL(MAX(id), 0) + 1
    INTO id_user
    FROM users;

    INSERT INTO users
                (id,
                name,
                email,
                fone,
                ind_blk)
                VALUES
                (id_user,
                 p_name,
                 p_email,
                 p_fone,
                 'N');

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'User inserted. Id: '|| id_user || '. Name: '|| p_name,
                     p_ind_log  => 'S');

  EXCEPTION

   WHEN OTHERS THEN
     CALL_INSERT_LOGS(p_msg     => 'Error while inserting a new user. Details: '|| SQLERRM,
                     p_ind_log => 'E');

  END insert_user;

-- Procedure for updating users in users table.

  PROCEDURE alter_user(p_id_user IN users.id%TYPE,
                       p_name    IN users.name%TYPE,
                       p_email   IN users.email%TYPE,
                       p_fone    IN users.fone%TYPE)
  IS
  BEGIN

    UPDATE users
    SET name  = NVL(p_name, name),
        email = NVL(p_email, email),
        fone  = NVL(p_fone, fone)
          WHERE id = p_id_user;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'User that has the id '|| p_id_user || ' was updated.',
                   p_ind_log => 'S');

  EXCEPTION
    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg     => 'Error while updating a user that has the id '|| p_id_user ||'. Details: '|| SQLERRM,
                       p_ind_log => 'E');

  END alter_user;

-- Procedure for deleting users in users table.

  PROCEDURE delete_user(p_id_user IN users.id%TYPE)
  IS
  BEGIN

    DELETE FROM users
    WHERE id = p_id_user;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'User that has the id '|| p_id_user ||' was deleted.',
                     p_ind_log => 'S');

  EXCEPTION
     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg     => 'Error while deleting user that has the id '|| p_id_user ||'. Details: '|| SQLERRM,
                        p_ind_log => 'E');
  END delete_user;


END pkg_user;
