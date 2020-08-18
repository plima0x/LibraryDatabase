CREATE OR REPLACE PACKAGE pkg_author
IS
  -- Procedure for inserting logs in system_logs table.

  PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                             p_ind_log IN system_logs.ind_log%TYPE);

  -- Procedure for inserting the authors in authors table.

  PROCEDURE insert_author(p_name    IN authors.name%TYPE,
                          p_website IN authors.website%TYPE);

 -- Procedure for updating authors in authors table.

  PROCEDURE alter_author(p_id_author IN authors.id%TYPE,
                         p_name      IN authors.name%TYPE,
                         p_website   IN authors.website%TYPE);

   -- Procedure for deleting authors in authors table

  PROCEDURE delete_author(p_id_author IN authors.id%TYPE);

END pkg_author;
