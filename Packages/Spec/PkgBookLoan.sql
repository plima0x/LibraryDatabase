CREATE OR REPLACE PACKAGE pkg_book_loan IS

-- Procedure for inserting logs in system_logs table.

  PROCEDURE call_insert_logs(p_msg     IN system_logs.msg%TYPE,
                             p_ind_log IN system_logs.ind_log%TYPE);

-- Procedure for inserting book loan in book loan table.

  PROCEDURE insert_book_loan(p_id_book   IN book_loan.id_book%TYPE,
                             p_id_user   IN book_loan.id_user%TYPE);

-- Procedure for updating book loan in book loan.

  PROCEDURE alter_book_loan(p_id_book_loan IN book_loan.id%TYPE,
                           p_id_book       IN book_loan.id_book%TYPE,
                           p_id_user       IN book_loan.id_user%TYPE,
                           p_init_dat      IN book_loan.init_dat%TYPE,
                           p_end_dat       IN book_loan.end_dat%TYPE,
                           p_give_back_dat IN book_loan.give_back_dat%TYPE);

-- Procedure for deleting book loan in book loan table.

  PROCEDURE delete_book_loan(p_id_book_loan IN book_loan.id%TYPE);


  -- Procedure to renew the loan

  PROCEDURE renew_book_loan(p_id_book_loan IN book_loan.id%TYPE);

  -- Procedure to give back the book.

  PROCEDURE give_back_book(p_id_book_loan IN book_loan.id%TYPE);


 -- Procedure to check users that are late in bring back books.

  PROCEDURE check_late_book_loan;

  -- Validate book loan

  FUNCTION  validate_book_loan(p_id_book       IN book_loan.id_book%TYPE,
                               p_id_user       IN book_loan.id_user%TYPE) RETURN BOOLEAN;

END pkg_book_loan;
