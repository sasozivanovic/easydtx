EasyDTX is a variant of the DTX format which eliminates the need for all those
pesky `macrocode` environments.  Any line introduced by a single comment counts
as documentation, and documentation lines may be indented. 

An `.edtx` file is converted to a `.dtx` by a little Perl script called
`edtx2dtx`; there is also a rudimentary Emacs mode, implemented in
`easydoctex-mode.el`, which takes care of fontification, indentation, and
forward and inverse search.  (The script does what it should, and would really
deserve version 1.0.0.  The Emacs mode, however, is just something that works
well enough for me.)
