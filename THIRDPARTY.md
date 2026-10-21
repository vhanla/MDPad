# Third-party components and licenses

MDPad itself is released under the MIT License; see `LICENSE` next to this
file. It is built with, and embeds, the open-source components listed below.
Their copyright notices and license terms are reproduced here, or pointed at
where the full text lives (the MPL, LGPL and GPL are long and must be taken
from their canonical sources; the upstream projects ship the exact copies).

This file is installed next to the program (`/usr/lib/mdpad/THIRDPARTY.md` in
the distribution packages, the program folder in the portable builds). The
About window shows a summary of the same list.

---

## MyWiki / WikiConverter

The native Markdown -> HTML engine of the default preview (`MyWiki.MarkdownConverter`).

- Upstream: https://github.com/htdt/WikiConverter
- License: MIT
- Copyright (c) 2025 MASUDA Takashi

```
MIT License

Copyright (c) 2025 MASUDA Takashi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Markdown4D

The canvas preview backend and its second native CommonMark/GFM parser and
HTML renderer (the `markdown4d_lcl` package, built from the FPC port of the
library).

- Upstream: https://github.com/gdk-apps/Markdown4D (GDK Software)
- License: MIT
- Copyright (c) 2026 GDK Software

```
MIT License

Copyright (c) 2026 GDK Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## THtmlViewer (FrameViewer09)

The cross-platform HTML preview (`HtmlView`).

- Upstream: https://github.com/BerndGabriel/HtmlViewer
- License: MIT-style (the "MIT License" text as published by the project)
- Copyright (c) 1995-2008 L. David Baldwin
- Copyright (c) 2008-2009 Sebastian Zierer (Delphi 2009 port)
- Copyright (c) 2008-2010 Arvid Winkelsdorf (fixes)
- Copyright (c) 2009-2022 Bernd Gabriel (fixes, enhancements)

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## ATSynEdit

The editor control (`TATSynEdit`) and its EControl adapter.

- Upstream: https://github.com/Alexey-T/ATSynEdit
- License: dual-licensed, MPL 2.0 or LGPL. The text of both licenses is in the
  ATSynEdit repository (`license.txt`) and at
  https://www.mozilla.org/MPL/2.0/ and
  https://www.gnu.org/licenses/lgpl-2.1.html
- Copyright (C) Alexey Torgashin (UVviewsoft.com)

## EControl Syntax Editor SDK

The syntax parser, grammar parser, regex engine and lexer manager behind the
editor's highlighting and the lexer library (`lib.lxl`).

- Upstream: https://github.com/Alexey-T/EControl
- Copyright (c) 2004-2015 EControl (Michael Zakharov)
- Copyright for changed/added parts (c) 2015-2026 Alexey Yu. Torgashin
  (UVviewsoft.com)

Used under the permission the original author gave for ATSynEdit: the code may
be used **only inside open-source projects**, and may not be used in closed
source software (a commercial license has to be bought from the original
author for that). MDPad is open source under the MIT License, and the modified
EControl sources are available from the upstream repository above.

## JavaScript Markdown engines (Windows preview)

The embedded-browser preview on Windows can run one of five JavaScript
Markdown converters. They are stored, unmodified, in `pagedown.inc`.

### PageDown

- Upstream: https://github.com/StackExchange/pagedown
- License: MIT-style
- Copyright (c) 2004-2005 John Gruber (original Markdown)
- Copyright (c) 2007 John Fraser (original Showdown code)
- Copyright (c) 2009 Dana Robinson (modifications and bugfixes)
- Copyright (c) 2009-2014 Stack Exchange Inc. (modifications and bugfixes)

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

### markdown-js

- Upstream: https://github.com/evilstreak/markdown-js
- License: MIT
- Copyright (c) 2009-2011 Dominic Baggott, Ash Berlin and contributors

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Marked

- Upstream: https://github.com/markedjs/marked
- License: MIT, and the Markdown (John Gruber) BSD-style license for the
  Markdown grammar/implementation it carries
- Copyright (c) 2018+ MarkedJS (https://github.com/markedjs/)
- Copyright (c) 2011-2018 Christopher Jeffrey (https://github.com/chjj/)

The full LICENSE of the project covers both the MIT part and the Markdown
part; it is reproduced at https://github.com/markedjs/marked/blob/master/LICENSE
and quoted here:

```
## Marked

Copyright (c) 2018+, MarkedJS (https://github.com/markedjs/)
Copyright (c) 2011-2018, Christopher Jeffrey (https://github.com/chjj/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Markdown

Copyright (c) 2004, John Gruber
http://daringfireball.net/
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name "Markdown" nor the names of its contributors may be used
  to endorse or promote products derived from this software without specific
  prior written permission.

This software is provided by the copyright holders and contributors "as is"
and any express or implied warranties, including, but not limited to, the
implied warranties of merchantability and fitness for a particular purpose
are disclaimed. In no event shall the copyright owner or contributors be
liable for any direct, indirect, incidental, special, exemplary, or
consequential damages (including, but not limited to, procurement of
substitute goods or services; loss of use, data, or profits; or business
interruption) however caused and on any theory of liability, whether in
contract, strict liability, or tort (including negligence or otherwise)
arising in any way out of the use of this software, even if advised of the
possibility of such damage.
```

### ShowDown

- Upstream: https://github.com/showdownjs/showdown
- License: MIT
- Copyright (c) 2018-2026 ShowdownJS

```
MIT License

Copyright (c) 2018-2026 ShowdownJS

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### markdown-it

- Upstream: https://github.com/markdown-it/markdown-it
- License: MIT
- Copyright (c) 2014 Vitaly Puzrin, Alex Kocharin

```
Copyright (c) 2014 Vitaly Puzrin, Alex Kocharin.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
```

## Free Pascal Compiler and Runtime Library

The compiler and the RTL/FCL the program is built with.

- Upstream: https://www.freepascal.org
- The compiler is GPL 2.0; the runtime and component libraries are LGPL 2.1
  with the FPC linking exception, which allows linking them into a program
  under another license. The license files ship with FPC
  (`compiler/COPYING`, `rtl/COPYING.FPC`, `packages/COPYING`).

## Lazarus Component Library

The widgetset-independent LCL, LazUtils, the printer package
(`printer4lazarus`) and the build tooling.

- Upstream: https://www.lazarus-ide.org
- License: modified LGPL 2.1 (the LCL exception allows static linking into a
  program under another license). The text is in `COPYING.LCL`,
  `COPYING.modifiedLGPL` and `COPYING.LGPL` in the Lazarus sources.

## FreeType

Through the Lazarus `freetypelaz` package, Markdown4D's canvas painter uses
FreeType to outline glyphs (SVG text and measurements).

- Upstream: https://freetype.org
- License: FreeType License (FTL) or GPL 2.0, at the user's choice. The text is
  in the FreeType distribution (`docs/FTL.TXT` and `docs/GPLv2.TXT`) and at
  https://gitlab.freedesktop.org/freetype/freetype/-/blob/master/docs/FTL.TXT
- Copyright (c) 1996-2026 David Turner, Robert Wilhelm and Werner Lemberg.

## OpenSSL

Used at run time by FPC's `fphttpclient` for the HTTPS update check on
platforms other than Windows. The OpenSSL unit loads the system library
dynamically; MDPad neither links it nor ships it.

- Upstream: https://www.openssl.org
- License: Apache License 2.0 (OpenSSL 3.x). The text is in the OpenSSL
  distribution (`LICENSE.txt`) and at
  https://www.apache.org/licenses/LICENSE-2.0

On Windows the update check uses WinInet, part of the operating system, and no
OpenSSL library is involved.
