#!/usr/bin/env python
import boto3, json, os, os.path as op

LogFile = op.join( os.getenv('HOME'), '.cubelog' )
TableName = 'cubelog'

def main(puzzle='3x3x3'):
  with open(LogFile) as fh:
    ddb = boto3.resource('dynamodb')
    table = ddb.Table(TableName)
    for line in fh:
      fields = line[0:-1].split(maxsplit=2)
      timestamp = fields[0][0:-1]
      solve_time = fields[1]
      if len(fields) > 2:
        scramble = fields[2]
      else:
        scramble = None
      key = { 'puzzle': puzzle, 'timestamp': timestamp }
      try:
        item = table.get_item( Key = key )['Item']
      except KeyError:
        item = key
        key.update({'solve_time': solve_time, 'scramble': scramble })
        print(json.dumps(item))
        table.put_item( Item = item )

if __name__ == '__main__':
    main()
