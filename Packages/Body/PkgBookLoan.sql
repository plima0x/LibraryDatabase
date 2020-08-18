CREATE OR REPLACE PACKAGE BODY pkg_book_loan
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

    COMMIT;

  END call_insert_logs;


-- Procedure for inserting book loan in book loan table.

  PROCEDURE insert_book_loan(p_id_book   IN book_loan.id_book%TYPE,
                             p_id_user   IN book_loan.id_user%TYPE)
  IS
    id_book_loan NUMBER;
    qtd_curr_book NUMBER;
  BEGIN

   IF validate_book_loan(p_id_book => p_id_book,
                        p_id_user  => p_id_user) THEN

    -- Getting a new book loan id.
     SELECT NVL(MAX(id), 0) + 1
     INTO id_book_loan
     FROM book_loan;

     INSERT INTO book_loan
                 (id,
                  id_book,
                  id_user,
                  init_dat,
                  end_dat,
                  give_back_dat,
                  ind_renew)
                 VALUES
                 (id_book_loan,
                  p_id_book,
                  p_id_user,
                  SYSDATE,        -- The start loan date will be today.
                  SYSDATE + 14,    -- The end loan date will be abount 2 weeks.
                  NULL,
                  'N');

     UPDATE books
     SET qtd_curr_book = qtd_curr_book - 1
     WHERE id = p_id_book;

     COMMIT;



     CALL_INSERT_LOGS(p_msg     => 'Book loan inserted. Id book: '|| p_id_book || '. Id user: '|| p_id_user,
                      p_ind_log  => 'S');

   END IF;

  EXCEPTION

   WHEN OTHERS THEN
     CALL_INSERT_LOGS(p_msg     => 'Error while inserting a new book loan. Details: '|| SQLERRM,
                     p_ind_log => 'E');

  END insert_book_loan;

-- Procedure for updating book loan in book loan table.

  PROCEDURE alter_book_loan(p_id_book_loan IN book_loan.id%TYPE,
                            p_id_book      IN book_loan.id_book%TYPE,
                            p_id_user      IN book_loan.id_user%TYPE,
                            p_init_dat     IN book_loan.init_dat%TYPE,
                            p_end_dat      IN book_loan.end_dat%TYPE,
                            p_give_back_dat IN book_loan.give_back_dat%TYPE)
  IS
  BEGIN

    UPDATE book_loan
    SET id_book   = NVL(p_id_book, id_book),
        id_user   = NVL(p_id_user, id_user),
        init_dat  = NVL(p_init_dat, init_dat),
        end_dat   = NVL(p_end_dat, end_dat),
        give_back_dat = NVL(p_give_back_dat, give_back_dat)
         WHERE id = p_id_book_loan;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book loan that has the id '|| p_id_book_loan || ' was updated.',
                     p_ind_log => 'S');

  EXCEPTION
    WHEN OTHERS THEN
    CALL_INSERT_LOGS(p_msg     => 'Error while updating the book loan that has the id '|| p_id_book_loan ||'. Details: '|| SQLERRM,
                     p_ind_log => 'E');

  END alter_book_loan;

-- Procedure for deleting book loan in book loan table.

  PROCEDURE delete_book_loan(p_id_book_loan IN book_loan.id%TYPE)
  IS
  BEGIN

    DELETE FROM book_loan
    WHERE id = p_id_book_loan;

    COMMIT;

    CALL_INSERT_LOGS(p_msg     => 'Book that has the id '|| p_id_book_loan ||' was deleted.',
                     p_ind_log => 'S');

  EXCEPTION
     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg     => 'Error while deleting the book loan that has the id '|| p_id_book_loan ||'. Details: '|| SQLERRM,
                        p_ind_log => 'E');
  END delete_book_loan;

  Procedure renew_book_loan(p_id_book_loan IN book_loan.id%TYPE)
  IS
    l_verify_ind_renew  VARCHAR2(1);
  BEGIN

   BEGIN


    -- First, get the ind_renew to know if the loan has been renowed(ind_renew = 'S').
     SELECT ind_renew
     INTO l_verify_ind_renew
     FROM book_loan
     WHERE id = p_id_book_loan;

   EXCEPTION
     -- book loan id references an id that is not exists.
     WHEN NO_DATA_FOUND THEN
       CALL_INSERT_LOGS(p_msg     => 'There is not a book loan that has the id  '|| p_id_book_loan,
                        p_ind_log => 'E');

     WHEN OTHERS THEN
       CALL_INSERT_LOGS(p_msg  => 'Error while getting the ind_renew from book_loan table. Details: '|| SQLERRM,
                        p_ind_log => 'E');

   END;

   -- Verifying the ind_renew value.

   IF l_verify_ind_renew = 'N' THEN

     UPDATE book_loan
     SET ind_renew = 'S',
         init_dat  = SYSDATE,
         end_dat   = SYSDATE + 14
     WHERE id = p_id_book_loan;

     COMMIT;

     CALL_INSERT_LOGS(p_msg     => 'Book loan that has the id '|| p_id_book_loan || ' was renewed.',
                      p_ind_log => 'S');


   ELSE

    CALL_INSERT_LOGS(p_msg => 'The book loan that has the id '|| p_id_book_loan || ' cannot be renewed anymore.',
                     p_ind_log => 'E');

   END IF;


   EXCEPTION
     WHEN OTHERS THEN
     CALL_INSERT_LOGS(p_msg => 'Error in the book loan renew process. Book loan id: '|| p_id_book_loan || '. Details: '||SQLERRM,
                      p_ind_log => 'E');

  END renew_book_loan;

  PROCEDURE give_back_book(p_id_book_loan IN book_loan.id%TYPE)
  IS

  BEGIN
    UPDATE book_loan
    SET give_back_dat = SYSDATE
    WHERE id = p_id_book_loan;

   UPDATE books b
   SET b.qtd_curr_book = b.qtd_curr_book + 1
   WHERE b.id = (SELECT bl.id_book FROM book_loan bl
                 WHERE bl.id = p_id_book_loan );

  COMMIT;

  EXCEPTION

    WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg     => 'Error while setting the give back date of the book loan that has the id  '|| p_id_book_loan,
                       p_ind_log => 'E');

  END give_back_book;


  PROCEDURE check_late_book_loan
  IS
  BEGIN
   -- Block users that does not gives back the book.

    UPDATE users usu
    SET usu.ind_blk = 'S'
    WHERE usu.id IN
     (SELECT bk.id_user FROM book_loan bk
      WHERE (bk.end_dat - bk.init_dat) > 14
      AND bk.give_back_dat IS NULL);

    COMMIT;

  END check_late_book_loan;

  -- Validate book loan

  FUNCTION  validate_book_loan(p_id_book       IN book_loan.id_book%TYPE,
                               p_id_user       IN book_loan.id_user%TYPE) RETURN BOOLEAN
  IS
    l_qtd_curr_book books.qtd_curr_book%TYPE;
    l_ind_block  users.ind_blk%TYPE := 'S';
    l_bol  BOOLEAN;
  BEGIN

   BEGIN
     SELECT ind_blk
     INTO l_ind_block
     FROM users
     WHERE id = p_id_user;

   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      CALL_INSERT_LOGS(p_msg     => 'Error in the  book loan process. User that has the id  '|| p_id_user || ' not found.',
                     p_ind_log => 'E');
      l_bol := FALSE;
   WHEN OTHERS THEN
      CALL_INSERT_LOGS(p_msg     => 'Error in the  book loan process while searching the indicator of user blocked of the user '|| p_id_user,
                       p_ind_log => 'E');
        l_bol := FALSE;
   END;

   IF l_ind_block = 'S' THEN
      l_bol := FALSE;
  ELSE
    BEGIN
      SELECT qtd_curr_book
      INTO   l_qtd_curr_book
      FROM books
      WHERE id = p_id_book;

      IF l_qtd_curr_book > 0 THEN
        l_bol := TRUE;
      ELSE
        l_bol := FALSE;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        CALL_INSERT_LOGS(p_msg     => 'Error in the  book loan process. Book that has the id  '|| p_id_book || ' not found.',
                        p_ind_log => 'E');
        l_bol := FALSE;
      WHEN OTHERS THEN
        CALL_INSERT_LOGS(p_msg     => 'Error in the  book loan process while searching the quantity of book that has the id '|| p_id_book,
                        p_ind_log => 'E');
        l_bol := FALSE;

    END;

  END IF;

  RETURN l_bol;

END validate_book_loan;


END pkg_book_loan;
