vimbrain
========

Vimbrain is a brain transplant for the Vim editor. A Ruby library and object model for Vim.

I've had this lying around for a long time. Finally got around to putting it
out. But I've only just started. There's more coming soon.

The tests and how to run them
-----------------------------

The tests are written in Ruby Test::Unit and use Ruby mocha for
mock objects. In case anyone is wondering, I know there are other frameworks,
and I would probably use them today, but this code is somewhat old.

The tricky part of running the tests is the fact that some depend on Vim's
internal Ruby interface (the VIM module),
which only available when running Ruby inside Vim. I have tried to keep as many
tests as possible independent of the VIM module. I have named the test files
systematically. The ones that must be run inside Vim are called 
`*_vimtest.rb`. 

I run these from the command line with a command that pops up a GUI Window
and leaves the test result in the terminal:

```
vim -gc 'rubyfile foo_vimtest.rb' -c qall!
```

The ones that can be run outside Vim are named `*_test.rb` and can be run in
a more usual way:

```
ruby foo_test.rb
```
