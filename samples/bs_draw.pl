#!/use/bin/perl

use strict;
use warnings;

use 5.010;
use GD;
use Math::Vector::Real;

my $w = 400;

my $im = GD::Image->new($w, $w);

my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);
my $red = $im->colorAllocate(255, 0, 0);
my $blue = $im->colorAllocate(0, 0, 255);
my $green = $im->colorAllocate(0, 255, 0);

# $im->transparent($white);
$im->interlaced('true');

sub scl {
    my $p = shift;
    @{$w * (0.3 * $p + [0.5, 0.5])}[0, 1];
}

sub sscl {
    my $s = shift;
    $w * (0.3*$s);
}

while (<>) {
    s/\s+//g;
    if (my ($px, $py, $r, $bx, $by) = /^\w+:\{(-?[\d\.]+),(-?[\d\.]+)\}(?:,\w+:(-?[\d\.]+))?(?:-{(-?[\d\.]+),(-?[\d\.]+)\})?/) {
        my @p = scl(V($px, $py));
        if (defined $r) {
            my $d = sscl($r);
            say "center {$px, $py; $r} => ($p[0], $p[1]; $d)";
            $im->ellipse(@p, 2*$d, 2*$d, $blue);
            $im->filledEllipse(@p, 3, 3, $green);
        }
        elsif (defined $bx) {
            my @b = scl(V($bx, $by));
            say "box {$px, $py}-{$bx, $by} => ($p[0], $p[1])-($b[0], $b[1])";
            $im->rectangle(@p, @b, $blue);
            # $im->ellipse(@p, 100, 100, $blue);
        }
        else {
            say "p {$px, $py} => ($p[0], $p[1])";
            $im->filledEllipse(@p, 3, 3, $red);
        }
    }
    else {
        say "failed to parse $_";
    }
}

open my $fh, ">output.png";
print $fh $im->png;

