#!perl

use strict;
use warnings;

use Test::More;
use File::Compare;

use App::PrereqGrapher;
use Data::Dumper;
my $grapher;

{ # no depth param

    my $test_file = 'example1.dot';
    my $base_file = 't/base/module-path.dot';

    $grapher = App::PrereqGrapher->new(
        format => 'dot',
        output_file => $test_file,
    );

    $grapher->generate_graph('Module::Path');

    my $fh;
    my @test;

    # read in test output file
    open $fh, '<', $test_file or die $!;
    while (<$fh>){
        chomp;
        next if /Generated by Graph/;
        next if /^$/;
        push @test, $_;
    }
    close $fh;

    # read in base data file
    open $fh, '<', $base_file or die $!;

    my $base_count = 0;

    while (my $line = <$fh>){
        chomp $line;
        next if $line =~ /Generated by Graph/;
        next if $line =~ /^$/;
        $base_count++;

        my @items = grep {$line eq $_} @test;
        is (@items, 1, "$line is in the test file");
    }
    close $fh;

    is (@test, $base_count, "both files have the same num of lines");

    chmod(0600, $test_file);
    ok(unlink($test_file), "remove graph after running test");
}
{ # no depth param

    my $test_file = 'example2.dot';
    my $base_file = 't/base/module-path-depth-2.dot';

    $grapher = App::PrereqGrapher->new(
        format => 'dot',
        depth => 2,
        output_file => $test_file,
    );

    $grapher->generate_graph('Module::Path');

    my $fh;
    my @test;

    # read in test output file
    open $fh, '<', $test_file or die $!;
    while (<$fh>){
        chomp;
        next if /Generated by Graph/;
        next if /^$/;
        push @test, $_;
    }
    close $fh;

    # read in base data file
    open $fh, '<', $base_file or die $!;

    my $base_count = 0;

    while (my $line = <$fh>){
        chomp $line;
        next if $line =~ /Generated by Graph/;
        next if $line =~ /^$/;
        $base_count++;

        my @items = grep {$line eq $_} @test;
        is (@items, 1, "$line is in the test file in depth 2");
    }
    close $fh;

    is (@test, $base_count, "both files have the same num of lines, depth 2");

    chmod(0600, $test_file);
    ok(unlink($test_file), "remove graph after running test");
}

done_testing();
