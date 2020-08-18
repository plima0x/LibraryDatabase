CREATE OR REPLACE PACKAGE pkg_user IS

-- Procedure for inserting logs in system_logs table.

 PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                            p_ind_log IN system_logs.ind_log%TYPE);

-- Procedure for inserting users in users table.

 PROCEDURE insert_user(p_name  IN users.name%TYPE,
                       p_email IN users.email%TYPE,
                       p_fone  IN users.fone%TYPE);

-- Procedure for updating users in users table.

PROCEDURE alter_user(p_id_user IN users.id%TYPE,
                     p_name    IN users.name%TYPE,
                     p_email   IN users.email%TYPE,
                     p_fone    IN users.fone%TYPE);

-- Procedure for deleting users in users table.

PROCEDURE delete_user(p_id_user IN users.id%TYPE);


END pkg_user;
