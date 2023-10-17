EasyDTX is a variant of the DTX format which eliminates the need for all those
pesky `macrocode` environments.  Any line introduced by a single comment counts
as documentation, and documentation lines may be indented. 

An `.edtx` file is converted to a `.dtx` by a little Perl script called
`edtx2dtx`; there is also a rudimentary Emacs mode, implemented in
`easydoctex-mode.el`, which takes care of fontification, indentation, and
forward and inverse search.  (The script does what it should, and would really
deserve version 1.0.0.  The Emacs mode, however, is just something that works
well enough for me.)

# LICENCE

Copyright (c) 2023- Saso Zivanovic <saso.zivanovic@guest.arnes.si>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

The files belonging to this program and covered by GPL are listed in
<texmf>/doc/support/easydtx/FILES.
