CLEAR SCREEN
SET TERMOUT OFF
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF 
SET TTITLE OFF
SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAPPED
SET DEFINE ON

----------------------------------------------------
-- ou installator
--
-- paprameter 1 values:
--
--  1 - UT full installation
--  2 - Recompile UT code base
--  3 - Create public synonyms for UT
--  4 - Deinstall UT
----------------------------------------------------

DEFINE line1='-------------------------------------------------------------'
DEFINE line2='============================================================='
DEFINE finished='.                            Finished'
DEFINE UT='UT'

------ [PBA] this will not work when we don't have DBA rights or grant select on V$SESSION
COLUMN col NOPRINT NEW_VALUE ut_owner
select USER col from dual;


COLUMN col NOPRINT NEW_VALUE next_script
select decode(&1,1,'ut_i_install',
                 2,'ut_i_recompile',
                 3,'ut_i_synonyms',
                 4,'ut_i_uninstall',
                   'ERROR') col from dual;

COLUMN col NOPRINT NEW_VALUE txt_prompt
select decode(&1,1,'I N S T A L L A T I O N',
                 2,'R E C O M P I L A T I O N',
                 3,'S Y N O N Y M S',
                 4,'D E I N S T A L L A T I O N',
                   'ERROR') col from dual;
------------------------------------------------------
COLUMN col NOPRINT NEW_VALUE v_orcl_vers

SELECT SUBSTR(version,1,3) col
  FROM product_component_version
 WHERE UPPER(PRODUCT) LIKE 'ORACLE7%'
    OR UPPER(PRODUCT) LIKE 'PERSONAL ORACLE%'
    OR UPPER(PRODUCT) LIKE 'ORACLE8%';

COLUMN col NOPRINT NEW_VALUE start81
SELECT DECODE (UPPER('&v_orcl_vers'),
               '8.1', '/* Use 8i code! */',
               '/* Ignore 8i code') col
  FROM dual;

COLUMN col NOPRINT NEW_VALUE end81
SELECT DECODE (upper('&v_orcl_vers'),
               '8.1', '/* Use 8i code! */',
               'Ignore 8i code */') col
  FROM dual;

COLUMN col NOPRINT NEW_VALUE start73
SELECT DECODE (UPPER('&v_orcl_vers'),
               '8.1', '/* Ignore Oracle7 code! ',
               '/* Use Oracle7 code */') col
  FROM dual;

COLUMN col NOPRINT NEW_VALUE end73
SELECT DECODE (UPPER('&v_orcl_vers'),
               '8.1', 'Ignore Oracle7 code! */',
               '/* Use Oracle7 code */') col
  FROM dual;
------------------------------------------------------

SET TERMOUT ON

PROMPT &line2
PROMPT GNU General Public License for utPLSQL
PROMPT
PROMPT Copyright (C) 2000
PROMPT Steven Feuerstein, steven@stevenfeuerstein.com
PROMPT Chris Rimmer, chris@sunset.force9.co.uk
PROMPT
PROMPT
PROMPT This program is free software; you can redistribute it and/or modify
PROMPT it under the terms of the GNU General Public License as published by
PROMPT the Free Software Foundation; either version 2 of the License, or
PROMPT (at your option) any later version.
PROMPT
PROMPT This program is distributed in the hope that it will be useful,
PROMPT but WITHOUT ANY WARRANTY; without even the implied warranty of
PROMPT MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
PROMPT GNU General Public License for more details.
PROMPT
PROMPT You should have received a copy of the GNU General Public License
PROMPT along with this program (see license.txt); if not, write to the Free Software
PROMPT Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
PROMPT &line2
PROMPT

PROMPT [ &txt_prompt ]
@@&next_script
