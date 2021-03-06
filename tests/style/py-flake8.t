#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use Test::Differences qw( eq_or_diff );

use File::Find::Object ();
use String::ShellQuote qw/ shell_quote /;

my %skip = (
    map { $_ => 1 }
        qw(
        pysollib/games/__init__.py
        pysollib/games/mahjongg/__init__.py
        pysollib/games/mahjongg/mahjongg1.py
        pysollib/games/mahjongg/mahjongg2.py
        pysollib/games/mahjongg/mahjongg3.py
        pysollib/games/special/__init__.py
        pysollib/games/ultra/__init__.py
        pysollib/htmllib2.py
        pysollib/mfxutil.py
        pysollib/pysoltk.py
        pysollib/tile/ttk.py
        pysollib/ui/tktile/Canvas2.py
        scripts/all_games.py
        )
);

my $tree = File::Find::Object->new( {}, '.' );
my @filenames;
while ( my $r = $tree->next_obj )
{
    my $fn = $r->path;
    if ( $fn eq '.git' or $fn eq 'tests/individually-importing' )
    {
        $tree->prune;
    }
    elsif ( $fn =~ /\.py\z/ and !exists( $skip{$fn} ) )
    {
        push @filenames, $fn;
    }
}

my $cmd = shell_quote( 'flake8', @filenames );

# diag("<$cmd>");

# TEST
eq_or_diff( scalar(`$cmd`), '', "flake8 is happy with the code." );

__END__

=head1 COPYRIGHT AND LICENSE

This file is part of Freecell Solver. It is subject to the license terms in
the COPYING.txt file found in the top-level directory of this distribution
and at http://fc-solve.shlomifish.org/docs/distro/COPYING.html . No part of
Freecell Solver, including this file, may be copied, modified, propagated,
or distributed except according to the terms contained in the COPYING file.

Copyright (c) 2016 Shlomi Fish

=cut

