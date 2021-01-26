Jemplate
========

Polyglot templating based on Perl's Template Toolkit


## Synopsis
```
jemplate --render=some.tt --path=template/ --data=./data.yaml

jemplate --compile --path=template/ --to=python > lib/mytemp.py

PYTHONPATH=lib python \
  -c 'import mytemp; print(mytemp.render("some.tt", "./data.yaml"))'
```


## Description
```
Jemplate is a subset of Perl's [Template Toolkit](http://www.template-toolkit.org/) templating language.

It compiles a library (directory structure) of template files into a module in one of several languages.

The `jemplate` command line tool can be used to compile templates to code, or to just render them directly.
```


## Installation
```
# Clone the source code:
git clone git@github.com/jemplate/jemplate /path/to/jemplate

# Source the setup file:
source /path/to/jemplate/.rc
```
