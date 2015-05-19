OPTIONS(DIRECT=TRUE, PARALLEL=FALSE)

UNRECOVERABLE

LOAD DATA

APPEND

INTO TABLE ds3.reviews

FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'

TRAILING NULLCOLS

(REVIEW_ID integer external,
PROD_ID integer external,
REVIEW_DATE date "yyyy/mm/dd", 
STARS integer external,
CUSTOMERID integer external,
REVIEW_SUMMARY char,
REVIEW_TEXT char(1000))
