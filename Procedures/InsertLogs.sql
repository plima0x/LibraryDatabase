-- Procedure for inserting logs in system_logs table.

CREATE OR REPLACE PROCEDURE insert_logs (p_tip_log IN system_logs.type_log%TYPE,
                                         p_msg     IN system_logs.msg%TYPE,
                                         p_ind_log IN system_logs.ind_log%TYPE)
 IS
   id_log system_logs.id%TYPE;
 BEGIN

   -- Getting the new id. If the tables has no rows, max function returns null, so nvl is used.

   SELECT NVL(MAX(id), 0) + 1
   INTO id_log
   FROM system_logs;

  -- Insert log only if the p_msg is not null.

   IF p_msg IS NOT NULL THEN
     INSERT INTO system_logs
                 (id,
                  type_log,
                  dat_log,
                  msg,
                  ind_log)
                 VALUES
                 (id_log,
                  p_tip_log,
                  SYSDATE,
                  p_msg,
                  p_ind_log);
   END IF;

 EXCEPTION

   WHEN OTHERS THEN
      DECLARE
       l_error_msg VARCHAR2(4000) := SQLERRM;

      BEGIN

     -- If there is an error, insert a default log.
     INSERT INTO system_logs
                (id,
                type_log,
                dat_log,
                msg,
                ind_log)
                VALUES
              (id_log,
               'INLOG',
               SYSDATE,
               'Error while inserting in the system logs table. Details: '|| l_error_msg,
               'E');

               COMMIT;
        END;

 END insert_logs;
