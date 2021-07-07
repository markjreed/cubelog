#!/usr/bin/env perl
use v5.16;
use JSON;
use Paws::DynamoDB;
use File::Spec::Functions;

our $LogFile = catfile $ENV{HOME}, '.cubelog';
our $TableName = 'cubelog';

sub main {
  my $puzzle = shift // '3x3x3';
  open my $fh, '<', $LogFile;
  my $ddb = Paws->service('DynamoDB', region => $ENV{AWS_DEFAULT_REGION} // 'us-east-1');
  while (chomp(my $line = <$fh>)) {
    my ($timestamp, $solve_time, $scramble)  = split ' ', $line, 3;
    chop($timestamp);
    my %key = ( 'puzzle' => { S => $puzzle }, 'timestamp' => { S => $timestamp } );
    my $item = $ddb->GetItem(TableName => $TableName, Key => \%key);
    unless ($item->Item) {
      my %item = (%key, solve_time => { S => $solve_time },
                 scramble => { S => $scramble} );
      $ddb->PutItem(TableName => $TableName, Item => \%item) or
        die "Failed to put item: $@\n";
    }
  }
}

main(@ARGV);
