package Jemplate::Compiler::AST;

use Pegex::Base;
extends 'Pegex::Tree';

# use Tie::IxHash;

has ast => [];

use XXX;

sub final {
    my ($self, $got) = @_;
    my ($head, $list) = @$got;
    unshift @$list, $head;

    $self->ast($list);

    $self;
}

sub got_init_text {
    my ($self, $got) = @_;
    my ($text, $post_chomp) = @$got;
    return { text => [ $text, '', $post_chomp // '' ] };
    return { text => $text };
}

sub got_stmt_text {
    my ($self, $got) = @_;
    my ($pre_chomp, $text, $post_chomp) = @$got;
    return { text => [ $text, $pre_chomp // '', $post_chomp // '' ] };
}

sub got_stmt_code {
    my ($self, $got) = @_;
    while (ref($got) eq 'ARRAY' and @$got == 1) {
        $got = $got->[0];
    }
    return $got;
}

sub got_stmt_process {
    my ($self, $got) = @_;
    return { process => $got->[0][0] };
}

sub got_expr_any {
    my ($self, $got) = @_;
    $got;
}

sub got_single_string {
    my ($self, $got) = @_;
    $got;
}

sub got_var_ref {
    my ($self, $var) = @_;
    return {var => $var};
}

1;
