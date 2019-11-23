#!/bin/bash
echo "DROP DATABASE IF EXISTS perftest; CREATE DATABASE perftest" | mysql
mysql perftest < perftest.sql
time mysql perftest < query-select-problem.sql
mysql perftest < explain-query-select-problem.sql
