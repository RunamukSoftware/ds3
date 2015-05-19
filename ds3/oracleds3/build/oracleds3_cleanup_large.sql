
select count(*) as "New Orderlines" from DS3.ORDERLINES where TO_DATE('2009-12-31', 'yyyy-mm-dd') < ORDERDATE;
delete from DS3.ORDERLINES where TO_DATE('2009-12-31', 'yyyy-mm-dd') < ORDERDATE;

select count(*) as "New Orders" from DS3.ORDERS where TO_DATE('2009-12-31', 'yyyy-mm-dd') < ORDERDATE;
delete from DS3.ORDERS where TO_DATE('2009-12-31', 'yyyy-mm-dd') < ORDERDATE;

select count(*) as "New Customers" from DS3.CUSTOMERS where customerid > 200000000;
delete from DS3.CUSTOMERS where customerid > 200000000;


select count(*) as "Reorder table size" from DS3.REORDER;
delete from DS3.REORDER;

delete from DS3.INVENTORY;

-- Sequences


DROP SEQUENCE "DS3"."CUSTOMERID_SEQ";
CREATE SEQUENCE "DS3"."CUSTOMERID_SEQ" 
  INCREMENT BY 1 
--START WITH 20001 
--START WITH 2000001
  START WITH 200000001
  MAXVALUE 1.0E28 
  MINVALUE 1 
  NOCYCLE 
  CACHE 1000000 
  NOORDER
  ;

DROP SEQUENCE "DS3"."ORDERID_SEQ";
CREATE SEQUENCE "DS3"."ORDERID_SEQ" 
  INCREMENT BY 1 
--START WITH 20001
--START WITH 2000001
  START WITH 200000001 
  MAXVALUE 1.0E28 
  MINVALUE 1 
  NOCYCLE 
  CACHE 1000000 
  NOORDER
  ;

DROP SEQUENCE "DS3"."REVIEWID_SEQ";
CREATE SEQUENCE "DS3"."REVIEWID_SEQ"
  INCREMENT BY 1
--START WITH 50001
--START WITH 5000001
  START WITH 500000001
  MAXVALUE 1.0E28
  MINVALUE 1
  NOCYCLE
  CACHE 100000
  NOORDER
  ;

DROP SEQUENCE "DS3"."REVIEWHELPFULNESSID_SEQ";
CREATE SEQUENCE "DS3"."REVIEWHELPFULNESSID_SEQ"
  INCREMENT BY 1
--START WITH 100001
--START WITH 10000001
  START WITH 1000000001
  MAXVALUE 1.0E28
  MINVALUE 1
  NOCYCLE
  CACHE 100000
  NOORDER
  ;

commit;

exit;
