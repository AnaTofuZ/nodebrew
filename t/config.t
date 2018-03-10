use strict;
use warnings;
use Test::More;
use FindBin;
use File::Read;

require 'nodebrew';

is_deeply Nodebrew::Config::_parse('
foo = bar=baz
hoge = fuga = piyo
'), { foo => 'bar=baz', hoge => 'fuga = piyo' };

is_deeply Nodebrew::Config::_parse('
foo = bar
hoge=fuga
'), { foo => 'bar', hoge => 'fuga' };

my $config = Nodebrew::Config::_strigify({
    foo => 'bar',
    hoge => 'fuga',
});
like $config, qr/foo = bar\n/;
like $config, qr/hoge = fuga\n/;

my $config_file = "$FindBin::Bin/_config";
my $config = Nodebrew::Config->new($config_file);

ok !-e $config_file;
is_deeply $config->get_all(), {};
is $config->get('foo'), undef;
is $config->set('foo', 'bar'), 1;
is $config->get('foo'), 'bar';
is $config->set('hoge', 'fuga'), 1;
is $config->get('hoge'), 'fuga';
is $config->del('hoge'), 1;
is $config->get('hoge'), undef;
is_deeply $config->get_all(), { foo => 'bar' };
is $config->save(), 1;
ok -e $config_file;
is read_file($config_file), "foo = bar\n";

unlink $config_file;

done_testing;
