#!/usr/bin/env bash

wget "https://de-mysql-connector.s3.amazonaws.com/mysql-connector-java-8.0.25.tar.gz"
sudo rm /usr/lib/sqoop/lib/mysql-connector-java-8.0.25.jar
sudo tar -xvf mysql-connector-java-8.0.25.tar.gz --strip-components=1 --directory /usr/lib/sqoop/lib/ mysql-connector-java-8.0.25/mysql-connector-java-8.0.25.jar
