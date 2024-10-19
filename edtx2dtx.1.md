---
title: edtx2dtx
section: 1
header: User Manual
footer: edtx2dtx 0.1.0
date: October 10, 2023
hyphenate: false
---

# NAME
edtx2dtx - Convert .edtx into .dtx


# SYNOPSIS
**edtx2dtx** *filename.edtx* > *filename.dtx*


# DESCRIPTION

This utility wraps code chunks by a (commented and properly indented)
`\begin{macrocode}` and `\end{macrocode}` pair.  A code chunk is any sequence of
lines not introduced by a single (possibly indented) comment character (`%`);
i.e. both non-commented lines and lines introduced by multiple comment
characters count as code, and documentation lines may be indented.

The part(s) of the file which should undergo conversion should be marked by a
`\begin{macrocode}` and `\end{macrocode}` pair (unlike in a `.dtx`, these lines need
not immediately precede and follow the code, respectively).  This convention
allows for the driver to remain as is, and also makes it easy to paste a `.dtx`
file into an `.edtx`, as using this utility on a .dtx does not change the file.

The utility furthermore replaces the first occurrence of `<filename>.edtx` in
the header, followed by an optional parenthesized note, with `<filename>.dtx`,
plus the note on how the file was generated.


# OPTIONS

**-h, \--help**
: Show help and exit.

**-V, \--version**
: Show the version number and exit.

# SEE ALSO

[easydoctex.el](????)
