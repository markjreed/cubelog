#!/usr/bin/env python
import boto3, json, os, os.path as op

LogFile = op.join( os.getenv('HOME'), '.cubelog' )
TableName = 'cubelog'

def main(cubelog=LogFile):
  with open(cubelog) as fh:
    ddb = boto3.resource('dynamodb')
    table = ddb.Table(TableName)
    for line in fh:
      fields = line[0:-1].split(maxsplit=3)
      timestamp = fields[0]
      puzzle = fields[1][1:-2]
      solve_time = fields[2]
      if len(fields) > 3:
        scramble = fields[3]
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
