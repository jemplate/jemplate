package Jemplate::Compiler::Grammar;
our $VERSION = '0.0.1';

use Pegex::Base;
extends 'Pegex::Grammar';

use constant file => './pgx/jemplate.pgx';

sub make_tree {   # Generated/Inlined by Pegex::Grammar (0.75)
  {
    '+toprule' => 'jemplate_stream',
    'LPAREN' => {
      '.rgx' => qr/\G\(/
    },
    'RPAREN' => {
      '.rgx' => qr/\G\)/
    },
    '_' => {
      '.rgx' => qr/\G\s*/
    },
    '__' => {
      '.rgx' => qr/\G\s+/
    },
    'binary_op' => {
      '.rgx' => qr/\G([\|\.\+\-])\s*/
    },
    'double_string' => {
      '.rgx' => qr/\G"((?:\\[\\"]|.)*?)"/
    },
    'expr_any' => {
      '.all' => [
        {
          '.any' => [
            {
              '.ref' => 'double_string'
            },
            {
              '.ref' => 'single_string'
            },
            {
              '.ref' => 'number_value'
            },
            {
              '.ref' => 'paren_expr'
            },
            {
              '.ref' => 'var_ref'
            }
          ]
        },
        {
          '.ref' => '_'
        }
      ]
    },
    'init_text' => {
      '.rgx' => qr/\G([\s\S]*?)(?:\[%([-+=\~]?)\s*|\z)/
    },
    'jemplate_stream' => {
      '.all' => [
        {
          '.ref' => 'init_text'
        },
        {
          '+min' => 0,
          '.any' => [
            {
              '.ref' => 'stmt_code'
            },
            {
              '.ref' => 'stmt_text'
            }
          ]
        }
      ]
    },
    'number_value' => {
      '.rgx' => qr/\G(\-?[0-9]+(?:\.[0-9]+)?)/
    },
    'paren_expr' => {
      '.all' => [
        {
          '.ref' => 'LPAREN'
        },
        {
          '.ref' => 'expr_any'
        },
        {
          '.ref' => 'RPAREN'
        }
      ]
    },
    'single_string' => {
      '.rgx' => qr/\G'((?:\\[\\']|.)*?)'/
    },
    'stmt_assign' => {
      '.all' => [
        {
          '.rgx' => qr/\G([a-zA-Z]\w*)\s*=\s*/
        },
        {
          '.ref' => 'expr_any'
        }
      ]
    },
    'stmt_code' => {
      '.all' => [
        {
          '.any' => [
            {
              '.ref' => 'stmt_set'
            },
            {
              '.ref' => 'stmt_process'
            },
            {
              '.ref' => 'stmt_for'
            },
            {
              '.ref' => 'stmt_assign'
            },
            {
              '.ref' => 'stmt_expr'
            }
          ]
        },
        {
          '.ref' => 'stmt_end'
        }
      ]
    },
    'stmt_end' => {
      '.rgx' => qr/\G\s*(?:;\s*|(?=[-+=\~]?%\]))/
    },
    'stmt_expr' => {
      '.all' => [
        {
          '.ref' => 'expr_any'
        },
        {
          '+min' => 0,
          '-flat' => 1,
          '.all' => [
            {
              '.ref' => 'binary_op'
            },
            {
              '.ref' => 'expr_any'
            }
          ]
        }
      ]
    },
    'stmt_for' => {
      '.rgx' => qr/\GXXX/
    },
    'stmt_process' => {
      '.all' => [
        {
          '.rgx' => qr/\GPROCESS/
        },
        {
          '.ref' => '__'
        },
        {
          '.ref' => 'expr_any'
        },
        {
          '+max' => 1,
          '.ref' => 'var_list'
        }
      ]
    },
    'stmt_set' => {
      '.all' => [
        {
          '.rgx' => qr/\GSET\s+([a-zA-Z]\w*)\s*=\s*/
        },
        {
          '.ref' => 'expr_any'
        }
      ]
    },
    'stmt_text' => {
      '.rgx' => qr/\G([-+=\~]?)%\]([\s\S]*?)(?:\[%([-+=\~]?)\s*|\z)/
    },
    'var_list' => {
      '+min' => 1,
      '.all' => [
        {
          '.rgx' => qr/\G([a-zA-Z]\w*)=/
        },
        {
          '.ref' => 'expr_any'
        }
      ]
    },
    'var_ref' => {
      '.rgx' => qr/\G([a-zA-Z]\w*)/
    }
  }
}

1;
