package Jemplate::Generator::Python;
use Pegex::Base;

has lookup => [];
has pre_chomp => '';
has post_chomp => '';

use XXX;

sub ind {
    my ($text) = @_;
    $text =~ s/^(.)/    $1/gm;
    return $text;
}

sub generate {
    my ($self, $ast) = @_;
    $self->{num} = 1;

    return <<"...";
from jemplate.runtime import JemplateRuntime

class JemplateClass(JemplateRuntime):
${\ ind $self->generate_methods($ast)}
${\ ind $self->generate_template_dict}
def render(template, data={}):
    return JemplateClass().render(template, data)
...
}

sub generate_methods {
    my ($self, $ast) = @_;
    my $out = '';
    for my $name (sort keys %$ast) {
        my $num = $self->{num}++;
        push @{$self->lookup}, [ $name, $num ];
        my $stmts = $ast->{$name};
        $out .= <<"...";
def f$num(self):
${\ ind $self->generate_body($stmts)}

...
    }
    chomp $out;
    return $out;
}

sub generate_body {
    my ($self, $stmts) = @_;

    my @out = ("o = ''");
    for my $stmt (@$stmts) {
        push @out, $self->generate_stmt($stmt);
    }
    push @out, 'return o';
    return join "\n", @out;
}

sub generate_template_dict {
    my ($self) = @_;
    my @out = (
        'def template_dict(self):',
        '    return {',
    );
    for my $set (@{$self->lookup}) {
        push @out, "        '$set->[0]': self.f$set->[1],";
    }
    push @out, '    }', '';
    return join "\n", @out;
}

sub generate_stmt {
    my ($self, $stmt) = @_;
    my ($type) = keys %$stmt;
    my $method = "generate_$type";

    return $self->$method($stmt->{$type});
}

sub generate_text {
    my ($self, $set) = @_;
    my ($text, $pre_chomp, $post_chomp) = @$set;
    $text = $self->pre_chomp($text, $pre_chomp);
    $text = $self->post_chomp($text, $post_chomp);
    $text =~ s/\n/\\n/g;
    return qq{o += '$text'};
}

sub generate_var {
    my ($self, $var) = @_;
    return qq{o += self.get('$var')};
}

sub generate_process {
    my ($self, $name) = @_;
    return qq{o += self.process('$name')};
}

sub pre_chomp {
    my ($self, $text, $chomp) = @_;
    $text =~ s/\A\s*// if $chomp eq '-';
    return $text;
}

sub post_chomp {
    my ($self, $text, $chomp) = @_;
    $text =~ s/\s*\z// if $chomp eq '-';
    return $text;
}

1;
