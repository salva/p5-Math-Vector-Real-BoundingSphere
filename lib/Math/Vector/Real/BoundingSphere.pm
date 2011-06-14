package Math::Vector::Real::BoundingSphere;

use 5.010;
use strict;
use warnings;

use Math::Vector::Real;

use Sort::Key::Top qw(nkeytail nkeyhead);

sub bounding_sphere {
    my $class = shift;
    my @v = @_;
    my ($top, $bottom) = Math::Vector::Real->box(@v);
    my $center = 0.5 * ($top + $bottom);
    say "box: $top-$bottom";
    for (1..2000) {
        my @d2 = map $center->dist2($_), @v;
        say "d: ", join(", ", map sqrt($_), @d2);
        my $farthest = $v[0];
        my $d2 = $d2[0];
        for (1..$#d2) {
            if ($d2[$_] > $d2) {
                $d2 = $d2[$_];
                $farthest = $v[$_];
            }
        }
        # my $farthest = nkeytail { $center->dist2($_) } @v;
        # my $d2 = $center->dist2($farthest);
        say "center: $center, d: " , sqrt($d2);
        my $u = ($farthest - $center)->versor;
        # map { say "\$_: $_" } @v;
        my $l = nkeyhead {
            #say "\$_: $_";
            my $op = $_ - $center;
            sqrt($u->decompose($op)->abs2 + $d2) + $op * $u;
        } @v;
        my $op = $l - $center;
        my $delta = $u * 0.5 * (sqrt($u->decompose($op)->abs2 + $d2) + $op * $u);
        if ($delta->abs2 / $d2 < 0.001) {
            return ($center, sqrt($d2))
        }
        $center += $delta;
    }
}


# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Math::Vector::Real::BoundingSphere - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Math::Vector::Real::BoundingSphere;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Math::Vector::Real::BoundingSphere, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Salvador Fandino, E<lt>salva@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Salvador Fandino

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
