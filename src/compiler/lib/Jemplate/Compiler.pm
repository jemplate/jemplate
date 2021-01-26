package Jemplate::Compiler;
use Pegex::Base;

our $VERSION = '0.0.1';

use Pegex::Parser;
use Jemplate::Compiler::Grammar;
use Jemplate::Compiler::AST;
use IO::All;

has 'ast' => {};

use XXX;

sub compile {
    my ($self, $opts) = @_;
    my $ast;

    if (my $files = $opts->{files}) {
        my $base = $opts->{base};
        $ast = $self->compile_files($base, $files);
    }
    elsif (my $text = $opts->{text}) {
        my $name = $opts->{name} || 'main';
        $ast = $self->compile_text($text, $name);
    }
    elsif (my $multi = $opts->{multi}) {
        $ast = $self->compile_multi($multi);
    }
    else {
        die;
    }

    $self->ast($ast);

    return $self;
}

sub compile_files {
    my ($self, $base, $files) = @_;
    my $ast = {};
    for my $file (@$files) {
        my $path = "$base/$file";
        my $text = io($path)->all;
        my ($name, $data) = %{$self->compile_text($text, $file)};
        $ast->{$name} = $data;
    }
    return $ast;
}

sub compile_text {
    my ($self, $text, $name) = @_;

    my $parser = Pegex::Parser->new(
        grammar => Jemplate::Compiler::Grammar->new,
        receiver => Jemplate::Compiler::AST->new,
        debug => $ENV{JEMPLATE_COMPILER_DEBUG},
    );

    return {
        $name => $parser->parse($text)->ast,
    };
}

sub compile_multi {
    my ($self, $multi) = @_;

    my $ast = {};
    while (@$multi) {
        my ($name, $text) = splice(@$multi, 0, 2);
        my $hash = $self->compile_text($text, $name);
        my ($key) = keys %$hash;
        $ast->{$key} = $hash->{$key};
    }

    return $ast;
}

sub to_python {
    my ($self, $ast) = @_;
    $ast //= $self->ast;
    require Jemplate::Generator::Python;
    Jemplate::Generator::Python->new->generate($ast);
}

1;
