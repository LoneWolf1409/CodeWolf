/* Formatted on 2001/07/13 12:29 (RevealNet Formatter v4.4.1) */
CREATE OR REPLACE PACKAGE BODY uttestcase
IS
   
/************************************************************************
GNU General Public License for utPLSQL

Copyright (C) 2000-2003 
Steven Feuerstein and the utPLSQL Project
(steven@stevenfeuerstein.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program (see license.txt); if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
************************************************************************
$Log$
************************************************************************/

   FUNCTION name_from_id (id_in IN ut_testcase.id%TYPE)
      RETURN ut_testcase.name%TYPE
   IS
      retval   ut_testcase.name%TYPE;
   BEGIN
      SELECT name
        INTO retval
        FROM ut_testcase
       WHERE id = id_in;
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   FUNCTION id_from_name (name_in IN ut_testcase.name%TYPE)
      RETURN ut_testcase.id%TYPE
   IS
      retval   ut_testcase.id%TYPE;
   BEGIN
      SELECT name
        INTO retval
        FROM ut_testcase
       WHERE name = UPPER (name_in);
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   PROCEDURE ADD (
      test_in       IN   INTEGER,
      testcase_in   IN   VARCHAR2,
      desc_in       IN   VARCHAR2 := NULL,
      seq_in        IN   PLS_INTEGER := NULL
   )
   IS
      &start81 PRAGMA AUTONOMOUS_TRANSACTION; &end81
      v_id   ut_testcase.id%TYPE;
   BEGIN
      &start81 v_id := utplsql.seqval ('ut_testcase'); &end81
      &start73 SELECT ut_testcase_seq.NEXTVAL INTO v_id FROM dual; &end73
      INSERT INTO ut_testcase
                  (id, test_id, name, description,
                   seq)
           VALUES (v_id, test_in, UPPER (testcase_in), desc_in,
                   NVL (seq_in, 1));
   &start81 COMMIT; &end81
   EXCEPTION
      WHEN OTHERS
      THEN
         utplsql.pl (   'Add test error: '
                     || SQLERRM);
         &start81 ROLLBACK; &end81
         RAISE;
   END;

   PROCEDURE ADD (
      test_in       IN   VARCHAR2,
      testcase_in   IN   VARCHAR2,
      desc_in       IN   VARCHAR2 := NULL,
      seq_in        IN   PLS_INTEGER := NULL
   )
   IS
   BEGIN
      ADD (uttest.id_from_name (test_in), testcase_in, desc_in, seq_in);
   END;

   PROCEDURE rem (test_in IN INTEGER, testcase_in IN VARCHAR2)
   IS
   &start81 PRAGMA AUTONOMOUS_TRANSACTION; &end81
   BEGIN
      DELETE FROM ut_testcase
            WHERE test_id = test_in
              AND name LIKE UPPER (testcase_in);
   &start81 COMMIT; &end81
   EXCEPTION
      WHEN OTHERS
      THEN
         utplsql.pl (   'Remove test error: '
                     || SQLERRM);
         &start81 ROLLBACK; &end81
         RAISE;
   END;

   PROCEDURE rem (test_in IN VARCHAR2, testcase_in IN VARCHAR2)
   IS
   BEGIN
      rem (uttest.id_from_name (test_in), testcase_in);
   END;

   PROCEDURE upd (
      test_in         IN   INTEGER,
      testcase_in     IN   VARCHAR2,
      start_in             DATE,
      end_in               DATE,
      successful_in        BOOLEAN
   )
   IS
      &start81 PRAGMA AUTONOMOUS_TRANSACTION; &end81
      v_failure   PLS_INTEGER := 0;
   BEGIN
      IF NOT successful_in
      THEN
         v_failure := 1;
      END IF;

      UPDATE ut_testcase
         SET last_start = start_in,
             last_end = end_in,
             executions =   executions
                          + 1,
             failures =   failures
                        + v_failure
       WHERE test_id = test_in
         AND name = UPPER (testcase_in);
   &start81 COMMIT; &end81
   EXCEPTION
      WHEN OTHERS
      THEN
         utplsql.pl (   'Update test error: '
                     || SQLERRM);
         &start81 ROLLBACK; &end81
         RAISE;
   END;

   PROCEDURE upd (
      test_in         IN   VARCHAR2,
      testcase_in     IN   VARCHAR2,
      start_in             DATE,
      end_in               DATE,
      successful_in        BOOLEAN
   )
   IS
   BEGIN
      upd (
         uttest.id_from_name (test_in),
         testcase_in,
         start_in,
         end_in,
         successful_in
      );
   END;
END uttestcase;
/
