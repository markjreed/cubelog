#!/usr/bin/env python
import boto3, json, os, os.path as op
from boto3.dynamodb.conditions import Key

TableName = 'cubelog'

ddb = boto3.resource('dynamodb')
table = ddb.Table(TableName)

last12 = table.query(KeyConditionExpression=Key('puzzle').eq('3x3x3'),
                     ScanIndexForward=False, Limit=12)['Items']
for n in [12, 5]:
  total = 0
  min_solve = float('inf')
  max_solve = 0
  count = 0
  for item in reversed(last12[0:n]):
    count = count + 1
    if n == 12:
      print(f'{item["timestamp"]}: {item["solve_time"]} ({item["scramble"]})')
    solve = float(item['solve_time'])
    total += solve
    if solve < min_solve:
        min_solve = solve
    if solve > max_solve:
        max_solve = solve

  avg = (total - min_solve - max_solve)/(count - 2)
  print(f'\nAverage of last {n}: {avg:.2f}')
