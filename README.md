## blott

An implementation of Normalization by Evaluation & semantic type checking for Martin-Löf Type Theory
with dependent products, dependent sums, natural numbers, id, box, and a cumulative hierarchy. This
implementation correctly handles eta for box, pi, and sigma.

Once built, the executable `blott` may be used to type check and normalize programs. A program
consists of a series of definitions: `let x : tp = term` and commands to normalize programs:
`normalize def name` or `normalize term at tp`. For examples, see the `test/` directory.

It is based on the implementation of NbE to be found (with a detailed
explanation) in [nbe-for-mltt](http://github.com/jozefg/nbe-for-mltt).


## building


```
$ git clone https://github.com/jozefg/nbe-for-guarded-mltt
$ cd nbe-for-guarded-mltt
$ opam update
$ opam pin add -y blott . # the first time you build
$ opam upgrade            # after packages change
```
