package Tie::Diamond;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.01'; # VERSION

sub TIEARRAY {
    my $class = shift;

    bless { size=>0, eof=>0 }, $class;
}

sub FETCH {
    my $self  = shift;
    my $index = shift;

    #print "FETCH($index)\n";
    if ($self->{eof}) {
        return undef;
    } else {
        return $self->{rec};
    }
}

sub FETCHSIZE {
    my $self = shift;

    my $size;
    if ($self->{eof}) {
        $size = $self->{size};
    } elsif (my $rec = <>) {
        $size = ++$self->{size};
        $self->{rec} = $rec;
    } else {
        $self->{eof}++;
        $size = $self->{size};
    }
    #print "FETCHSIZE() -> $size\n";
    $size;
}

1;
# ABSTRACT: Iterate the diamond operator via a Perl array


__END__
=pod

=head1 NAME

Tie::Diamond - Iterate the diamond operator via a Perl array

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use Tie::Diamond;
 tie my(@ary), "Tie::Diamond" or die;
 while (my ($idx, $item) = each @ary) {
     ...
 }

=head1 DESCRIPTION

This module lets you iterate the diamond operator via a Perl array.

=head1 FAQ

=head2 Why?

So you can treat the diamond operator as an array. One of my modules,
L<Data::Unixish>, uses this. A function can be passed a real array (to iterate
over a Perl array), or a tied array (to iterate lines from STDIN or files
mentioned in arguments); they don't have to change their iteration syntax.

=head2 Can I do this?

 @other = @ary; # or print @ary

Currently no. But since you are slurping all lines anyway, you might as well
just do:

 @other = <>; # or print <>

=head1 SEE ALSO

L<Iterator::Diamond>

L<Tie::File>

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

