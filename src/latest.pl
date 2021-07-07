#!/usr/bin/env perl
use v5.16;
use JSON;
use Paws::DynamoDB;

our $TableName = 'cubelog';

my $ddb = Paws->service('DynamoDB', region => $ENV{AWS_DEFAULT_REGION} // 'us-east-1');

my $result = $ddb->Query(TableName => $TableName,
                         ExpressionAttributeValues => { ":3x3" => { S => '3x3x3' } },
                         KeyConditionExpression => 'puzzle = :3x3',
                         ScanIndexForward => 0, Limit => 12);

my @last12 = @{$result->Items};

foreach my $n (12, 5) {
  my $total = 0;
  my $min_solve = 'inf';
  my $max_solve = '-inf';
  my $count = 0;
  foreach my $item (reverse @last12[0..$n-1]) {
    my %data = (map { $_ => $item->{Map}{$_}{S} } keys %{$item->{Map}});
    $count++;
    say "$data{timestamp}: $data{solve_time} ($data{scramble})" if $n == 12;
    $total += (my $solve = $data{solve_time});
    $min_solve = $solve if $solve < $min_solve;
    $max_solve = $solve if $solve > $max_solve;
  }

  my $avg = ($total - $min_solve - $max_solve)/($count - 2);
  printf "\nAverage of last $n: %.2f\n", $avg;
}
