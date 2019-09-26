set line 120
set pagesize 100
column tn   format a20            heading 'TableSpace|Name'
column Tot  format 999,999,999.99 heading 'Total|(Mb)'
column Free format 999,999,999.99 heading 'Free|(Mb)'
column Used format 999,999,999.99 heading 'Used|(Mb)'
column Pct  format 999,999,999.99 heading 'Pct|(%)'
  SELECT  t.tn,
        t.sizes Tot,
        (t.sizes - f.sizes ) Used,
        (t.sizes - f.sizes) /t.sizes * 100 Pct,
        f.sizes Free
FROM    ( SELECT tablespace_name tn,
                 sum(bytes)/1024/1024 Sizes
          FROM   dba_data_files
          GROUP  BY tablespace_name) t,
        ( SELECT tablespace_name tn,
                 sum(bytes)/1024/1024 sizes
          FROM   dba_free_space
          GROUP BY tablespace_name) f
WHERE t.tn = f.tn
ORDER BY Pct desc
/
