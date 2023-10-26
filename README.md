# entropy-finder

A CLI utility to find high-entropy strings in files.

## About

`entropy-finder` is a tool to search text files for high-entropy strings. Why
you might care about such things is that secrets, such as private keys, authenticiation
tokens, passwords, and connection strings are often high-entropy. While there's no
guarantee that this tool will find all secrets or that it will avoid false positives
it can still be a helpful way to identify potentially sensitive information
without looking at every single line by hand.

This tool is written in Ruby because I like Ruby and it's either already installed
on or easy to install on most systems.

## Usage

With Ruby installed you should be able to just run it like so:

```bash
$ <path>/<to>/entropy_finder.rb -h
Usage: find_entropy.rb [options] [<files and/or directories>]
    -t, --threshold VALUE            Set the entropy threshold to report on (default: 4.2)
    -i, --include VALUE              Scan only files matching the value or values, e.g. ".cs" or ".rb,.json"
    -e, --exclude VALUE              Do not scan files matching extension e.g. ".css" or ".yml,.html"
    -x, --exclude_dir VALUE          Do not scan files within matching directories e.g. "bin" or "obj,cache"
```
The default threshold of 4.2 is pretty low and will likely identify lots of strings that aren't
secret (like URLs or complex string concatinations). I've found most true secrets start around
5.3 and I've found running with a threshold of 5 is a good compromise.

## Examples

These are using the files in this directory so you should be able to try them for yourself.

### Run it against a single file

```bash
$ ./entropy_finder.rb sample.rb
sample.rb
  Line:5 (4.7) ''abcdefghijklmnopqrstuvwxyz''
  Line:9 (5.1) 'HEdOt8Yjl8Sq_9pMgunr6nlsLDZ78J8vV2T_DeWS0wU','
  Line:10 (5.6) 'BKhSM-bUKX3eqc9kc46sialHnuPLMmmxnAfuUQd3-2H5EZf-vMGSP8TqB1yvO_NNgP9air_g...'
```

In that output you can see the name of the file where high-entropy strings were found is listed and
then the lines with those strings are printed out. So `sample.rb` has a string with entropy of 4.7
on line 5. It has a string of entropy 5.6 on line 10.

So, the `sample.rb` file was scanned using the default threshold of 4.2 and found three strings with
fairly high entropy. Both of the strings it found with an entropy of over 5 are in fact secrets (in
this case public/private VAPID keys). You can run it with a threshold set to 0 to see the entropy of
all the strings.

```bash
$ ./entropy_finder.rb sample.rb -t 0
sample.rb
  Line:1 (3.7) 'frozen_string_literal:'
  Line:1 (2.0) 'true'
  Line:3 (2.0) 'Just'
  Line:3 (2.0) 'some'
  Line:3 (2.6) 'sample'
  Line:3 (2.5) 'strings'
  ... and so on.
```

I find this fun to do. I'm not sure why. If we try it with a slightly lower value we can see some
other strings that come close to being suspiciously secret.

```bash
$ ./entropy_finder.rb sample.rb -t 3.5
sample.rb
  Line:1 (3.7) 'frozen_string_literal:'
  Line:5 (4.7) ''abcdefghijklmnopqrstuvwxyz''
  Line:8 (3.9) ''http://www.example.com/','
  Line:9 (5.1) 'HEdOt8Yjl8Sq_9pMgunr6nlsLDZ78J8vV2T_DeWS0wU','
  Line:10 (5.6) 'BKhSM-bUKX3eqc9kc46sialHnuPLMmmxnAfuUQd3-2H5EZf-vMGSP8TqB1yvO_NNgP9air_g...'
  Line:11 (3.8) '"#{SOME_CONSTANT}+#{SOME_CONSTANT}-#{SOME_CONSTANT}*#{SOME_CONSTANT}/#{S...'
```

URLs and complex concatinations are things that show up a lot when I use the tool, so when I get
more results than I want I'll slowly raise the threshold until I'm seeing a manageable amount of
information.

### Running against a directory

```bash
$ ./entropy_finder.rb .
./README.md
  Line:42 (4.6) '''abcdefghijklmnopqrstuvwxyz'''
  ...
./entropy_finder.rb
  Line:40 (4.2) 'Math.log2(frequency))'
  ...
./sample.rb
  Line:5 (4.7) ''abcdefghijklmnopqrstuvwxyz''
  ...
```

You'll see familiar output if you run it against this repository directory without additional
parameters. For the sake of argument let's say we want to exclude the contents of the README
file because we know it contains the same strings we're finding in the other files. There are
two ways of doing this, first exclude by file type:

```bash
$ ./entropy_finder.rb . -e .md
...
```

or just specify all the files to scan on the command line:

```bash
$ ./entropy_finder.rb entropy_finder.rb sample.rb 
...
```

It should be noted that supplying a list of parameters is different for the include and exclude
parameters than the list of files and or directories the program operates on. The include
and exclude parameters are comma separated, but the operating list is space separated (to be
shell friendly). A complicated example might look like so:

```bash
$ ./entropy_finder.rb repo1 repo2 -e .sql,.json -x tmp,bin,obj -t 5
...
```

## Feedback

If you have feedback you can leave it as an issue on the
[github repository](https://github.com/michaellitherland/entropy-finder). I feel like I'm still
not an 'idiomatic' Ruby dev, so feedback of that sort is welcome. I'll also accept PRs if they
seem helpful.

## License

It's MIT, you can read the `LICENSE` file for more.
