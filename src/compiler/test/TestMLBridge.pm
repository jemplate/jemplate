use strict; use warnings;
package TestMLBridge;
use base 'TestML::Bridge';

use lib 'lib';
use Jemplate::Compiler;
use YAML::PP;
use Capture::Tiny;
use IO::All;
use File::Temp qw/tempfile/;

use XXX;

sub compile {
    my ($self, $jemplate) = @_;

    my $hash;
    if ($jemplate =~ /^\+\+\+\ /m) {
        my @multi =  split /^\+\+\+\ +(\S+)\n/m, $jemplate;
        if ($multi[0] eq '') {
            shift @multi;
        }
        else {
            unshift @multi, 'main.tt';
        }
        $hash = { multi => \@multi };
    }
    else {
        $hash = {
            text => $jemplate,
            name => 'main.tt',
        };
    }
    return Jemplate::Compiler->new->compile($hash);
}

sub render {
    my ($self, $jemplate, $yaml) = @_;
    my $code = $self->compile($jemplate)->to_python;
    my ($code_fh, $code_fn) =
        tempfile("/tmp/jemplateXXXX", SUFFIX => '.py');
    print $code_fh $code;
    my ($yaml_fh, $yaml_fn) =
        tempfile("/tmp/dataXXXX", SUFFIX => '.yaml');
    print $yaml_fh $yaml;
    Capture::Tiny::capture_merged {
        system("test/bin/py-render.sh $code_fn $yaml_fn");
    };
}

sub ast {
    my ($self, $compiler) = @_;
    return $compiler->ast;
}

sub python {
    my ($self, $compiler) = @_;
    return $compiler->to_python;
}

sub n2y {
    my ($self, $ast) = @_;
    my $yaml = YAML::PP::Dump($ast);
    $yaml =~ s/\A---.*\n//;
    return $yaml;
}

sub y2y {
    my ($self, $yaml) = @_;
    $yaml = YAML::PP::Dump YAML::PP::Load $yaml;
    $yaml =~ s/\A---.*\n//;
    return $yaml;
}

1;
