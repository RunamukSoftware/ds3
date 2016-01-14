
-- sqlserverds3_create_ind.sql: DS Database Index Build Script - SQL Server version
-- Copyright (C) 2007 Dell, Inc. <davejaffe7@gmail.com> and <tmuirhead@vmware.com>
-- Last updated 1/4/16


USE DS3
GO

ALTER TABLE CATEGORIES ADD CONSTRAINT PK_CATEGORIES PRIMARY KEY CLUSTERED 
  (
  CATEGORY
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE CUSTOMERS ADD CONSTRAINT PK_CUSTOMERS PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_CUST_FG 
GO

CREATE UNIQUE INDEX IX_CUST_UN_PW ON CUSTOMERS 
  (
  USERNAME, 
  PASSWORD
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID ON CUST_HIST
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID ON CUST_HIST 
  (
  CUSTOMERID ASC,
  PROD_ID ASC
  )
  ON DS_IND_FG
GO

ALTER TABLE CUST_HIST
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE ORDERS ADD CONSTRAINT PK_ORDERS PRIMARY KEY CLUSTERED 
  (
  ORDERID
  )  
  ON DS_ORDERS_FG 
GO

CREATE INDEX IX_ORDER_CUSTID ON ORDERS
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

ALTER TABLE ORDERLINES ADD CONSTRAINT PK_ORDERLINES PRIMARY KEY CLUSTERED 
  (
  ORDERID,
  ORDERLINEID
  )  
  ON DS_ORDERS_FG 
GO

ALTER TABLE ORDERLINES ADD CONSTRAINT FK_ORDERID FOREIGN KEY (ORDERID)
  REFERENCES ORDERS (ORDERID)
  ON DELETE CASCADE
GO

ALTER TABLE INVENTORY ADD CONSTRAINT PK_INVENTORY PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

ALTER TABLE PRODUCTS ADD CONSTRAINT PK_PRODUCTS PRIMARY KEY CLUSTERED 
  (
  PROD_ID
  )  
  ON DS_MISC_FG 
GO

CREATE INDEX IX_PROD_PRODID ON PRODUCTS 
  (
  PROD_ID ASC
  )
  INCLUDE (TITLE)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_PRODID_COMMON_PRODID ON PRODUCTS 
  (
  PROD_ID ASC,
  COMMON_PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR)
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL_CATEGORY_PRODID ON PRODUCTS 
  (
  SPECIAL ASC,
  CATEGORY ASC,
  PROD_ID ASC
  )
  INCLUDE (TITLE, ACTOR, PRICE, COMMON_PROD_ID)
  ON DS_IND_FG
GO


EXEC sp_fulltext_database 'enable'
EXEC sp_fulltext_catalog  'FULLTEXTCAT_DSPROD', 'create', '{FULLTEXTCAT_PATH}'     --Added a placeholder by GSK --This placeholder will be replaced by perl script with the paths given by user
EXEC sp_fulltext_table    'PRODUCTS',           'create', 'FULLTEXTCAT_DSPROD', 'PK_PRODUCTS'
EXEC sp_fulltext_column   'PRODUCTS',           'ACTOR', 'add'
EXEC sp_fulltext_column   'PRODUCTS',           'TITLE', 'add'
EXEC sp_fulltext_table    'PRODUCTS',           'activate'
EXEC sp_fulltext_catalog  'FULLTEXTCAT_DSPROD', 'start_full'
GO

CREATE INDEX IX_PROD_CATEGORY ON PRODUCTS 
  (
  CATEGORY
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_SPECIAL ON PRODUCTS
  (
  SPECIAL
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_PROD_MEMBERSHIP ON PRODUCTS
  (
  MEMBERSHIP_ITEM
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_INV_PROD_ID on INVENTORY
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

ALTER TABLE MEMBERSHIP ADD CONSTRAINT PK_MEMBERSHIP PRIMARY KEY CLUSTERED 
  (
  CUSTOMERID
  )  
  ON DS_IND_FG 
GO

ALTER TABLE MEMBERSHIP
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS (CUSTOMERID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS ADD CONSTRAINT PK_REVIEWS PRIMARY KEY CLUSTERED 
  (
  REVIEW_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS
  ADD CONSTRAINT FK_REVIEWS_PROD_ID FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS (PROD_ID)
  ON DELETE CASCADE
GO

ALTER TABLE REVIEWS
  ADD CONSTRAINT FK_REVIEWS_CUSTOMERID FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS (CUSTOMERID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_PROD_ID ON REVIEWS
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_STARS ON REVIEWS
  (
  STARS
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_PRODSTARS ON REVIEWS
  (
  PROD_ID,STARS
  )
  ON DS_IND_FG
GO

ALTER TABLE REVIEWS_HELPFULNESS ADD CONSTRAINT PK_REVIEWS_HELPFULNESS PRIMARY KEY CLUSTERED 
  (
  REVIEW_HELPFULNESS_ID
  )  
  ON DS_REVIEW_FG 
GO

ALTER TABLE REVIEWS_HELPFULNESS
  ADD CONSTRAINT FK_REVIEW_ID FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS (REVIEW_ID)
  ON DELETE CASCADE
GO

CREATE INDEX IX_REVIEWS_HELP_REVID ON REVIEWS_HELPFULNESS
  (
  REVIEW_ID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REVIEWS_HELP_CUSTID ON REVIEWS_HELPFULNESS
  (
  CUSTOMERID
  )
  ON DS_IND_FG
GO

CREATE INDEX IX_REORDER_PRODID ON REORDER
  (
  PROD_ID
  )
  ON DS_IND_FG
GO

CREATE NONCLUSTERED INDEX IX_REVIEWS_PRODID_REVID_DATE ON REVIEWS
  (
  PROD_ID ASC,
  REVIEW_ID ASC,
  REVIEW_DATE ASC
  )
  INCLUDE (STARS,CUSTOMERID,REVIEW_SUMMARY,REVIEW_TEXT)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go

CREATE NONCLUSTERED INDEX IX_REVIEWSHELPFULNESS_ID_HELPID ON [dbo].[REVIEWS_HELPFULNESS]
  (
  REVIEW_ID ASC,
  REVIEW_HELPFULNESS_ID ASC
  )
  INCLUDE (HELPFULNESS)
  WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
  ON DS_IND_FG
go



CREATE STATISTICS stat_cust_cctype_username ON CUSTOMERS(CREDITCARDTYPE, USERNAME)
GO
CREATE STATISTICS stat_cust_cctype_customerid ON CUSTOMERS(CREDITCARDTYPE, CUSTOMERID)
GO
CREATE STATISTICS stat_prod_prodid_special ON PRODUCTS(PROD_ID, SPECIAL)
GO
CREATE STATISTICS stat_prod_category_prodid ON PRODUCTS(CATEGORY, PROD_ID)
GO
CREATE STATISTICS stat_reviews_reviewid_stars ON REVIEWS(REVIEW_ID, STARS)
GO
CREATE STATISTICS stat_reviews_prodid_custid ON REVIEWS(PROD_ID, CUSTOMERID)
GO
CREATE STATISTICS stat_reviews_reviewid_date ON REVIEWS(REVIEW_ID, REVIEW_DATE)
GO
CREATE STATISTICS stat_reviews_date_prodid ON REVIEWS(REVIEW_DATE, PROD_ID)
GO
CREATE STATISTICS stat_reviews_prodid_stars_reviewid ON REVIEWS(PROD_ID, STARS, REVIEW_ID)
GO