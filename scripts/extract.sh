#!/usr/bin/env bash

hadoop fs -rm -r /user/livy/SRC_ATM_TRANS

sqoop import \
--connect jdbc:mysql://upgraddetest.cyaielc9bmnf.us-east-1.rds.amazonaws.com/testdatabase \
--table SRC_ATM_TRANS \
--username student --password STUDENT123 \
--target-dir /user/livy/SRC_ATM_TRANS \
-m 1
