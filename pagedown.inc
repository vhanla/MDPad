{
  This file contains the HTML generated templates as well the javascript
  markdown engines, the usage should be as follows:

  HEADER + CSS + DEMOTEXT + ENGINE + FOOTER
  Alternatively
  HEADER + CSS + ANYHTML TEXT + FOOTER

  ENGINES
  - PAGEDOWN
  - MARKDOWNJS
  - MARKED
  - SHOWDOWN (seems that it doesn't work well)
  - MARKDOWNIT
}
CONST
// HTML starting template - it OPENS HEAD TAG but doesn't close!!!!
HEADER = '<!DOCTYPE html>'
+#13''
+#13'<html>'
+#13''
+#13'    <head>'
+#13'        <title>PageDown Demo Page</title>'
+#13'	<meta http-equiv="X-UA-Compatible" content="IE=9" >'
+#13'	<meta charset="utf-8" />'
+#13'        ';

BODY = '<body>'
+#13'  <textarea class="wmd-input" id="wmd-input" onkeyup="update()" style="display:none">';
BODY2 = #13'  </textarea>'
+#13'  <div id="readme">'
+#13'	   <div class="md" id="resultado" cols="80" rows="20" readonly="readonly"></div>	'
+#13'  </div>'
+#13'	';

OPENCONTAINER = '<body>'
+#13' <div id="readme">'
+#13'	<div class="md" id="resultado" cols="80" rows="20" readonly="readonly">';
CLOSECONTAINER = '</div>	'
+#13'        </div>'
+#13'	';
// USE it after close the HEAD tag!!! STYLE CSS closes it
// it opens BODY tag, doesn't CLOSE!!!, footer does!
DEMOTEXT = '# MDPad v1.1 '
+#13''
+#13'[MDPad](http://apps.codigobit.info/2012/06/markdown-pad-markdown-textfile-editor.html) is a free MarkDown files viewer and editor for Windows.'
+#13''
+#13'The goal is to facilitate editing and viewing  your offline markdown files'
+#13'offering a HTML preview and export features.'
+#13''
+#13'**Attention:** MDPad is based on [Pagedown](https://code.google.com/p/pagedown/ "A ShowDown based markdown conversor used at stackoverflow").'
+#13''
+#13''
+#13'## How to install'
+#13''
+#13'**Only Windows**'
+#13''
+#13'There is no need to install it, it is a standalone application.'
+#13'However, if you want to register your files with .md .mkd .markdown extensions'
+#13'to open directly from Windows Explorer, you need to do the following.'
+#13''
+#13'    Make sure you have this application in a reliable folder.'
+#13'    Then go to menu '
+#13'        File->Preferences'
+#13'        And Register file extensions'
+#13''
+#13'## How to use'
+#13''
+#13'You only need to write in the editor following the markdown guidelines.'
+#13''
+#13'As you can see, this text you''re reading now, has been rendered with the internal conversor:'
+#13''
+#13'    /*This is a code demo*/'
+#13'    var JavaScript = ''Javascrip demo'';'
+#13'    alert(JavaScript);'
+#13''
+#13'    '
+#13''
+#13'## Thanks to'
+#13''
+#13'* Stackoverflow PageDown script.'
+#13'* Daring Fireball'
+#13''
+#13'## Help'
+#13''
+#13'If you''re not familiar with Markdown, you should spend 15 minutes and go over the excelent'
+#13'[Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) at Daring Fireball.'
+#13''
+#13'## License'
+#13'( The MIT License )'
+#13''
+#13'Copyright (c) 2012 Victor Alberto Gil [vhanla]'
+#13''
+#13'Permission is hereby granted, free of charge, to any person obtaining'
+#13'a copy of this software and associated documentation files (the'
+#13'"Software"), to deal in the Software without restriction, including'
+#13'without limitation the rights to use, copy, modify, merge, publish,'
+#13'distribute, sublicense, and/or sell copies of the Software, and to'
+#13'permit persons to whom the Software is furnished to do so, subject to'
+#13'the following conditions:'
+#13''
+#13'The above copyright notice and this permission notice shall be'
+#13'included in all copies or substantial portions of the Software.'
+#13''
+#13'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,'
+#13'EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF'
+#13'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND'
+#13'NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE'
+#13'LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION'
+#13'OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION'
+#13'WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';


// LAST PART OF THE HTML, since it closes BODY tag, before that makes some
// adjustments to the webbrowser, like no popup or select text
FOOTER ='	<script type="text/javascript">'
+#13'   document.onkeydown = function(e) {'
+#13'      // keycode for F5 function'
+#13'      if (e.keyCode === 116) {'
+#13'        return false;'
+#13'      }'
+#13'      // keycode for backspace'
+#13'      if (e.keyCode === 8) {'
+#13'        // try to cancel the backspace        '
+#13'        if(document.getElementById(''wmd-input'') == document.activeElement){'
+#13'          //document.body.style.backgroundColor=''#234'';'
+#13'        }else        '
+#13'        return false;'
+#13''
+#13'      }'
+#13'      //disable ctrl-l, ctrl-o, ctrl-n'
+#13'      var keyPressed = (e)?e.which:window.event.keyCode;'
+#13'      var ctrlPressed = (e)?(e.ctrlKey):window.event.ctrlKey;'
+#13'      if(ctrlPressed){'
+#13'        switch(keyPressed){          '
+#13'          case 43: //+ zoom in'
+#13'          case 45: //- zoom out'
+#13'          case 70: //F'
+#13'          case 76: //L'
+#13'          case 78: //N'
+#13'          case 79: //O'
+#13'          case 80: //P'
+#13'            window.event.keyCode = 0;'
+#13'            return false;          '
+#13'        }'
+#13'      }'
+#13'    };'
+#13'//context menu'
+#13'    document.addEventListener("contextmenu", function(event) {      '
+#13'        event.preventDefault();      '
+#13'    }, false);    '
+#13'    '
+#13'  </script>'
+#13'    </body>'
+#13'</html>';

// STYLE TO INCLUDE IN HEAD TAG

CSS = '<style type="text/css">'
+#13'.md{padding-top:10px;padding-bottom:10px;}'
+#13'.md{font-size:14px;line-height:1.6;}'
+#13'.md>*:first-child{margin-top:0!important;}'
+#13'.md>*:last-child{margin-bottom:0!important;}'
+#13'.md a.absent{color:#c00;}'
+#13'.md a.anchor{display:block;padding-left:30px;margin-left:-30px;cursor:pointer;position:absolute;top:0;left:0;bottom:0;}'
+#13'.md h1,.md h2,.md h3,.md h4,.md h5,.md h6{margin:20px 0 10px;padding:0;font-weight:bold;-webkit-font-smoothing:antialiased;cursor:text;position:relative;}'
+#13'.md h1 .mini-icon-link,.md h2 .mini-icon-link,.md h3 .mini-icon-link,.md h4 .mini-icon-link,.md h5 .mini-icon-link,.md h6 .mini-icon-link{display:none;color:#000;}'
+#13'.md h1:hover a.anchor,.md h2:hover a.anchor,.md h3:hover a.anchor,.md h4:hover a.anchor,.md h5:hover a.anchor,.md h6:hover a.anchor{text-decoration:none;line-height:36px;padding-left:0;margin-left:-22px;}'
+#13'.md h1:hover a.anchor .mini-icon-link,.md h2:hover a.anchor .mini-icon-link,.md h3:hover a.anchor .mini-icon-link,.md h4:hover a.anchor .mini-icon-link,.md h5:hover a.anchor .mini-icon-link,.md h6:hover a.anchor .mini-icon-link{display:inline-block;}'
+#13'.md h1 tt,.md h1 code,.md h2 tt,.md h2 code,.md h3 tt,.md h3 code,.md h4 tt,.md h4 code,.md h5 tt,.md h5 code,.md h6 tt,.md h6 code{font-size:inherit;}'
+#13'.md h1{font-size:28px;color:#000;}'
+#13'.md h2{font-size:24px;border-bottom:1px solid #ccc;color:#000;}'
+#13'.md h3{font-size:18px;}'
+#13'.md h4{font-size:16px;}'
+#13'.md h5{font-size:14px;}'
+#13'.md h6{color:#777;font-size:14px;}'
+#13'.md p,.md blockquote,.md ul,.md ol,.md dl,.md li,.md table,.md pre{margin:15px 0;}'
+#13'.md hr{background:transparent url("https://a248.e.akamai.net/assets.github.com/images/modules/pulls/dirty-shade.png?643ff063") repeat-x 0 0;border:0 none;color:#ccc;height:4px;padding:0;}'
+#13'.md>h2:first-child,.md>h1:first-child,.md>h1:first-child+h2,.md>h3:first-child,.md>h4:first-child,.md>h5:first-child,.md>h6:first-child{margin-top:0;padding-top:0;}'
+#13'.md a:first-child h1,.md a:first-child h2,.md a:first-child h3,.md a:first-child h4,.md a:first-child h5,.md a:first-child h6{margin-top:0;padding-top:0;}'
+#13'.md h1+p,.md h2+p,.md h3+p,.md h4+p,.md h5+p,.md h6+p{margin-top:0;}'
+#13'.md li p.first{display:inline-block;}'
+#13'.md ul,.md ol{padding-left:30px;}'
+#13'.md ul li>:first-child,.md ol li>:first-child{margin-top:0;}'
+#13'.md ul li>:last-child,.md ol li>:last-child{margin-bottom:0;}'
+#13'.md dl{padding:0;}'
+#13'.md dl dt{font-size:14px;font-weight:bold;font-style:italic;padding:0;margin:15px 0 5px;}'
+#13'.md dl dt:first-child{padding:0;}'
+#13'.md dl dt>:first-child{margin-top:0;}'
+#13'.md dl dt>:last-child{margin-bottom:0;}'
+#13'.md dl dd{margin:0 0 15px;padding:0 15px;}'
+#13'.md dl dd>:first-child{margin-top:0;}'
+#13'.md dl dd>:last-child{margin-bottom:0;}'
+#13'.md blockquote{border-left:4px solid #DDD;padding:0 15px;color:#777;}'
+#13'.md blockquote>:first-child{margin-top:0;}'
+#13'.md blockquote>:last-child{margin-bottom:0;}'
+#13'.md table{padding:0;}'
+#13'.md table tr{border-top:1px solid #ccc;background-color:#fff;margin:0;padding:0;}'
+#13'.md table tr:nth-child(2n){background-color:#f8f8f8;}'
+#13'.md table tr th{font-weight:bold;}'
+#13'.md table tr th,.md table tr td{border:1px solid #ccc;text-align:left;margin:0;padding:6px 13px;}'
+#13'.md table tr th>:first-child,.md table tr td>:first-child{margin-top:0;}'
+#13'.md table tr th>:last-child,.md table tr td>:last-child{margin-bottom:0;}'
+#13'.md img{max-width:100%;}'
+#13'.md span.frame{display:block;overflow:hidden;}'
+#13'.md span.frame>span{border:1px solid #ddd;display:block;float:left;overflow:hidden;margin:13px 0 0;padding:7px;width:auto;}'
+#13'.md span.frame span img{display:block;float:left;}'
+#13'.md span.frame span span{clear:both;color:#333;display:block;padding:5px 0 0;}'
+#13'.md span.align-center{display:block;overflow:hidden;clear:both;}'
+#13'.md span.align-center>span{display:block;overflow:hidden;margin:13px auto 0;text-align:center;}'
+#13'.md span.align-center span img{margin:0 auto;text-align:center;}'
+#13'.md span.align-right{display:block;overflow:hidden;clear:both;}'
+#13'.md span.align-right>span{display:block;overflow:hidden;margin:13px 0 0;text-align:right;}'
+#13'.md span.align-right span img{margin:0;text-align:right;}'
+#13'.md span.float-left{display:block;margin-right:13px;overflow:hidden;float:left;}'
+#13'.md span.float-left span{margin:13px 0 0;}'
+#13'.md span.float-right{display:block;margin-left:13px;overflow:hidden;float:right;}'
+#13'.md span.float-right>span{display:block;overflow:hidden;margin:13px auto 0;text-align:right;}'
+#13'.md code,.md tt{margin:0 2px;padding:0 5px;white-space:nowrap;border:1px solid #eaeaea;background-color:#f8f8f8;border-radius:3px;}'
+#13'.md pre>code{margin:0;padding:0;white-space:pre;border:none;background:transparent;}'
+#13'.md .highlight pre,.md pre{background-color:#f8f8f8;border:1px solid #ccc;font-size:13px;line-height:19px;overflow:auto;padding:6px 10px;border-radius:3px;}'
+#13'.md pre code,.md pre tt{background-color:transparent;border:none;}'
+#13'#readme .md,#readme .plain{background-color:#fff;border:1px solid #CACACA;padding:30px;}'
+#13''
+#13'	</style>'
+#13'    </head>'
+#13'    ';

{ENGINES}


//OLD PAGEDOWN https://github.com/ujifgc/pagedown 22jun2015
PAGEDOWN ='<script type="text/javascript">'
+#13'"use strict";var Markdown;Markdown="object"==typeof exports&&"function"==typeof ' +
'require?exports:{},function(){function u(u){return u}function e(u){return!1}func' +
'tion a(){}function r(){}a.prototype={chain:function(e,a){var r=this[e];if(!r)thr' +
'ow new Error("unknown hook "+e);r===u?this[e]=a:this[e]=function(u){var e=Array.' +
'prototype.slice.call(arguments,0);return e[0]=r.apply(null,e),a.apply(null,e)}},' +
'set:function(u,e){if(!this[u])throw new Error("unknown hook "+u);this[u]=e},addN' +
'oop:function(e){this[e]=u},addFalse:function(u){this[u]=e}},Markdown.HookCollect' +
'ion=a,r.prototype={set:function(u,e){this["s_"+u]=e},get:function(u){return this' +
'["s_"+u]}},Markdown.Converter=function(e){function n(u){return u=u.replace(/^[ ]' +
'{0,3}\[([^\[\]]+)\]:[ \t]*\n?[ \t]*<?(\S+?)>?(?=\s|$)[ \t]*\n?[ \t]*((\n*)["(](.' +
'+?)[")][ \t]*)?(\n+)/gm,function(u,e,a,r,n,t,c){return e=e.toLowerCase(),O.set(e' +
',x(a)),n?r+c:(t&&Q.set(e,t.replace(/"/g,"&quot;")),"")})}function t(u){return u=' +
'u.replace(/^(<(p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|f' +
'ieldset|iframe|math|ins|del)\b[^\r]*?\n<\/\2>[ \t]*(?=\n+))/gm,f),u=u.replace(/^' +
'(<(p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|fieldset|ifra' +
'me|math)\b[^\r]*?.*<\/\2>[ \t]*(?=\n+)\n)/gm,f),u=u.replace(/\n[ ]{0,3}((<(hr)\b' +
'([^<>])*?\/?>)[ \t]*(?=\n{2,}))/g,f),u=u.replace(/\n\n[ ]{0,3}(<!(--(?:|(?:[^>-]' +
'|-[^>])(?:[^-]|-[^-])*)--)>[ \t]*(?=\n{2,}))/g,f),u=u.replace(/(?:\n\n)([ ]{0,3}' +
'(?:<([?%])[^\r]*?\2>)[ \t]*(?=\n{2,}))/g,f)}function c(u){return u=u.replace(/(^' +
'\n+|\n+$)/g,""),"\n\n~K"+(z.push(u)-1)+"K\n\n"}function f(u,e){return c(e)}funct' +
'ion o(u,e,a){u=K.preBlockGamut(u,T),u=h(u);var r="<hr />\n";return u=u.replace(/' +
'^[ ]{0,2}([ ]?\*[ ]?){3,}[ \t]*$/gm,r),u=u.replace(/^[ ]{0,2}([ ]?-[ ]?){3,}[ \t' +
']*$/gm,r),u=u.replace(/^[ ]{0,2}([ ]?_[ ]?){3,}[ \t]*$/gm,r),u=v(u),u=_(u),u=S(u' +
'),u=K.postBlockGamut(u,T),u=t(u),u=A(u,e,a)}function d(u){return u=K.preSpanGamu' +
't(u),u=$(u),u=p(u),u=W(u),u=b(u),u=i(u),u=N(u),u=u.replace(/~P/g,"://"),u=x(u),u' +
'=P(u),u=u.replace(/  +\n/g," <br>\n"),u=K.postSpanGamut(u)}function p(u){var e=/' +
'(<[a-z\/!$]("[^"]*"|''[^'']*''|[^''">])*>|<!(--(?:|(?:[^>-]|-[^>])(?:[^-]|-[^-])*)--' +
')>)/gi;return u=u.replace(e,function(u){var e=u.replace(/(.)<\/?code>(?=.)/g,"$1' +
'`");return e=D(e,"!"==u.charAt(1)?"\\`*_/":"\\`*_")})}function i(u){return-1===u' +
'.indexOf("[")?u:(u=u.replace(/(\[((?:\[[^\]]*\]|[^\[\]])*)\][ ]?(?:\n[ ]*)?\[(.*' +
'?)\])()()()()/g,l),u=u.replace(/(\[((?:\[[^\]]*\]|[^\[\]])*)\]\([ \t]*()<?((?:\(' +
'[^)]*\)|[^()\s])*?)>?[ \t]*(([''"])(.*?)\6[ \t]*)?\))/g,l),u=u.replace(/(\[([^\[\' +
']]+)\])()()()()()/g,l))}function l(u,e,a,r,n,t,c,f){void 0==f&&(f="");var o=e,d=' +
'a.replace(/:\/\//g,"~P"),p=r.toLowerCase(),i=n,l=f;if(""==i)if(""==p&&(p=d.toLow' +
'erCase().replace(/ ?\n/g," ")),i="#"+p,void 0!=O.get(p))i=O.get(p),void 0!=Q.get' +
'(p)&&(l=Q.get(p));else{if(!(o.search(/\(\s*\)$/m)>-1))return o;i=""}i=q(i);var b' +
'=''<a href="''+i+''"'';return""!=l&&(l=g(l),l=D(l,"*_"),b+='' title="''+l+''"''),b+=">"+' +
'd+"</a>"}function b(u){return-1===u.indexOf("![")?u:(u=u.replace(/(!\[(.*?)\][ ]' +
'?(?:\n[ ]*)?\[(.*?)\])()()()()/g,s),u=u.replace(/(!\[(.*?)\]\s?\([ \t]*()<?(\S+?' +
')>?[ \t]*(([''"])(.*?)\6[ \t]*)?\))/g,s))}function g(u){return u.replace(/>/g,"&g' +
't;").replace(/</g,"&lt;").replace(/"/g,"&quot;").replace(/''/g,"&#39;")}function ' +
's(u,e,a,r,n,t,c,f){var o=e,d=a,p=r.toLowerCase(),i=n,l=f;if(l||(l=""),""==i){if(' +
'""==p&&(p=d.toLowerCase().replace(/ ?\n/g," ")),i="#"+p,void 0==O.get(p))return ' +
'o;i=O.get(p),void 0!=Q.get(p)&&(l=Q.get(p))}d=D(g(d),"*_[]()"),i=D(i,"*_");var b' +
'=''<img src="''+i+''" alt="''+d+''"'';return l=g(l),l=D(l,"*_"),b+='' title="''+l+''"'',b+' +
'=" />"}function h(u){return u=u.replace(/^(.+)[ \t]*\n=+[ \t]*\n+/gm,function(u,' +
'e){return"<h1>"+d(e)+"</h1>\n\n"}),u=u.replace(/^(.+)[ \t]*\n-+[ \t]*\n+/gm,func' +
'tion(u,e){return"<h2>"+d(e)+"</h2>\n\n"}),u=u.replace(/^(\#{1,6})[ \t]*(.+?)[ \t' +
']*\#*\n+/gm,function(u,e,a){var r=e.length;return"<h"+r+">"+d(a)+"</h"+r+">\n\n"' +
'})}function v(u,e){u+="~0";var a=/^(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(~0|\n{' +
'2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/gm;return B?u=u.replace(a,function(u' +
',a,r){var n,t=a,c=r.search(/[*+-]/g)>-1?"ul":"ol";"ol"===c&&(n=parseInt(r,10));v' +
'ar f=m(t,c,e);f=f.replace(/\s+$/,"");var o="<"+c;return n&&1!==n&&(o+='' start="''' +
'+n+''"''),f=o+">"+f+"</"+c+">\n"}):(a=/(\n\n|^\n?)(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[' +
'^\r]+?(~0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/g,u=u.replace(a,functio' +
'n(u,e,a,r){var n,t=e,c=a,f=r.search(/[*+-]/g)>-1?"ul":"ol";"ol"===f&&(n=parseInt' +
'(r,10));var o=m(c,f),d="<"+f;return n&&1!==n&&(d+='' start="''+n+''"''),o=t+d+">\n"+' +
'o+"</"+f+">\n"})),u=u.replace(/~0/,"")}function m(u,e,a){B++,u=u.replace(/\n{2,}' +
'$/,"\n"),u+="~0";var r=Z[e],n=new RegExp("(^[ \\t]*)("+r+")[ \\t]+([^\\r]+?(\\n+' +
'))(?=(~0|\\1("+r+")[ \\t]+))","gm"),t=!1;return u=u.replace(n,function(u,e,a,r){' +
'var n=r,c=/\n\n$/.test(n),f=c||n.search(/\n{2,}/)>-1,d=f||t;return n=o(G(n),!0,!' +
'd),t=c,"<li>"+n+"</li>\n"}),u=u.replace(/~0/g,""),B--,u}function _(u){return u+=' +
'"~0",u=u.replace(/(?:\n\n|^\n?)((?:(?:[ ]{4}|\t).*\n+)+)(\n*[ ]{0,3}[^ \t\n]|(?=' +
'~0))/g,function(u,e,a){var r=e,n=a;return r=w(G(r)),r=L(r),r=r.replace(/^\n+/g,"' +
'"),r=r.replace(/\n+$/g,""),r="<pre><code>"+r+"\n</code></pre>","\n\n"+r+"\n\n"+n' +
'}),u=u.replace(/~0/,"")}function $(u){return u=u.replace(/(^|[^\\`])(`+)(?!`)([^' +
'\r]*?[^`])\2(?!`)/gm,function(u,e,a,r,n){var t=r;return t=t.replace(/^([ \t]*)/g' +
',""),t=t.replace(/[ \t]*$/g,""),t=w(t),t=t.replace(/:\/\//g,"~P"),e+"<code>"+t+"' +
'</code>"})}function w(u){return u=u.replace(/&/g,"&amp;"),u=u.replace(/</g,"&lt;' +
'"),u=u.replace(/>/g,"&gt;"),u=D(u,"*_{}[]\\",!1)}function C(u){return-1===u.inde' +
'xOf("*")&&-1===u.indexOf("_")?u:(u=I(u),u=u.replace(/(^|[\W_])(?:(?!\1)|(?=^))(\' +
'*|_)\2(?=\S)([^\r]*?\S)\2\2(?!\2)(?=[\W_]|$)/g,"$1<strong>$3</strong>"),u=u.repl' +
'ace(/(^|[\W_])(?:(?!\1)|(?=^))(\*|_)(?=\S)((?:(?!\2)[^\r])*?\S)\2(?!\2)(?=[\W_]|' +
'$)/g,"$1<em>$3</em>"),M(u))}function k(u){return-1===u.indexOf("*")&&-1===u.inde' +
'xOf("_")?u:(u=I(u),u=u.replace(/(?=[^\r][*_]|[*_])(^|(?=\W__|(?!\*)[\W_]\*\*|\w\' +
'*\*\w)[^\r])(\*\*|__)(?!\2)(?=\S)((?:|[^\r]*?(?!\2)[^\r])(?=\S_|\w|\S\*\*(?:[\W_' +
']|$)).)(?=__(?:\W|$)|\*\*(?:[^*]|$))\2/g,"$1<strong>$3</strong>"),u=u.replace(/(' +
'?=[^\r][*_]|[*_])(^|(?=\W_|(?!\*)(?:[\W_]\*|\D\*(?=\w)\D))[^\r])(\*|_)(?!\2\2\2)' +
'(?=\S)((?:(?!\2)[^\r])*?(?=[^\s_]_|(?=\w)\D\*\D|[^\s*]\*(?:[\W_]|$)).)(?=_(?:\W|' +
'$)|\*(?:[^*]|$))\2/g,"$1<em>$3</em>"),M(u))}function S(u){return u=u.replace(/((' +
'^[ \t]*>[ \t]?.+\n(.+\n)*\n*)+)/gm,function(u,e){var a=e;return a=a.replace(/^[ ' +
'\t]*>[ \t]?/gm,"~0"),a=a.replace(/~0/g,""),a=a.replace(/^[ \t]+$/gm,""),a=o(a),a' +
'=a.replace(/(^|\n)/g,"$1  "),a=a.replace(/(\s*<pre>[^\r]+?<\/pre>)/gm,function(u' +
',e){var a=e;return a=a.replace(/^  /gm,"~0"),a=a.replace(/~0/g,"")}),c("<blockqu' +
'ote>\n"+a+"\n</blockquote>")})}function A(u,e,a){u=u.replace(/^\n+/g,""),u=u.rep' +
'lace(/\n+$/g,"");for(var r=u.split(/\n{2,}/g),n=[],t=/~K(\d+)K/,c=r.length,f=0;c' +
'>f;f++){var o=r[f];t.test(o)?n.push(o):/\S/.test(o)&&(o=d(o),o=o.replace(/^([ \t' +
']*)/g,a?"":"<p>"),a||(o+="</p>"),n.push(o))}if(!e){c=n.length;for(var f=0;c>f;f+' +
'+)for(var p=!0;p;)p=!1,n[f]=n[f].replace(/~K(\d+)K/g,function(u,e){return p=!0,z' +
'[e]})}return n.join("\n\n")}function x(u){return u=u.replace(/&(?!#?[xX]?(?:[0-9' +
'a-fA-F]+|\w+);)/g,"&amp;"),u=u.replace(/<(?![a-z\/?!]|~D)/gi,"&lt;")}function W(' +
'u){return u=u.replace(/\\(\\)/g,R),u=u.replace(/\\([`*_{}\[\]()>#+-.!])/g,R)}fun' +
'ction E(u,e,a,r){if(e)return u;if(")"!==r.charAt(r.length-1))return"<"+a+r+">";f' +
'or(var n=r.match(/[()]/g),t=0,c=0;c<n.length;c++)"("===n[c]?0>=t?t=1:t++:t--;var' +
' f="";if(0>t){var o=new RegExp("\\){1,"+-t+"}$");r=r.replace(o,function(u){retur' +
'n f=u,""})}if(f){var d=r.charAt(r.length-1);X.test(d)||(f=d+f,r=r.substr(0,r.len' +
'gth-1))}return"<"+a+r+">"+f}function N(u){u=u.replace(F,E);var e=function(u,e){v' +
'ar a=q(e);return''<a href="''+a+''">''+K.plainLinkText(e)+"</a>"};return u=u.replace' +
'(/<((https?|ftp):[^''">\s]+)>/gi,e)}function y(u){return u=u.replace(/~E(\d+)E/g,' +
'function(u,e){var a=parseInt(e);return String.fromCharCode(a)})}function G(u){re' +
'turn u=u.replace(/^(\t|[ ]{1,4})/gm,"~0"),u=u.replace(/~0/g,"")}function L(u){if' +
'(!/\t/.test(u))return u;var e,a=["    ","   ","  "," "],r=0;return u.replace(/[\' +
'n\t]/g,function(u,n){return"\n"===u?(r=n+1,u):(e=(n-r)%4,r=n+1,a[e])})}function ' +
'q(u){return u=g(u),u=D(u,"*_:()[]")}function D(u,e,a){var r="(["+e.replace(/([\[' +
'\]\\])/g,"\\$1")+"])";a&&(r="\\\\"+r);var n=new RegExp(r,"g");return u=u.replace' +
'(n,R)}function R(u,e){var a=e.charCodeAt(0);return"~E"+a+"E"}var K=this.hooks=ne' +
'w a;K.addNoop("plainLinkText"),K.addNoop("preConversion"),K.addNoop("postNormali' +
'zation"),K.addNoop("preBlockGamut"),K.addNoop("postBlockGamut"),K.addNoop("preSp' +
'anGamut"),K.addNoop("postSpanGamut"),K.addNoop("postConversion");var O,Q,z,B;e=e' +
'||{};var I=u,M=u;e.nonAsciiLetters&&!function(){var u=/[Q\u00aa\u00b5\u00ba\u00c' +
'0-\u00d6\u00d8-\u00f6\u00f8-\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\' +
'u0374\u0376-\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03' +
'f5\u03f7-\u0481\u048a-\u0523\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-' +
'\u05f2\u0621-\u064a\u0660-\u0669\u066e-\u066f\u0671-\u06d3\u06d5\u06e5-\u06e6\u0' +
'6ee-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07c0-\u07ea\u07f4-\u07f5' +
'\u07fa\u0904-\u0939\u093d\u0950\u0958-\u0961\u0966-\u096f\u0971-\u0972\u097b-\u0' +
'97f\u0985-\u098c\u098f-\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd' +
'\u09ce\u09dc-\u09dd\u09df-\u09e1\u09e6-\u09f1\u0a05-\u0a0a\u0a0f-\u0a10\u0a13-\u' +
'0a28\u0a2a-\u0a30\u0a32-\u0a33\u0a35-\u0a36\u0a38-\u0a39\u0a59-\u0a5c\u0a5e\u0a6' +
'6-\u0a6f\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2-' +
'\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0-\u0ae1\u0ae6-\u0aef\u0b05-\u0b0c\u0b0f-\u0' +
'b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32-\u0b33\u0b35-\u0b39\u0b3d\u0b5c-\u0b5d\u0b5f' +
'-\u0b61\u0b66-\u0b6f\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99-\u' +
'0b9a\u0b9c\u0b9e-\u0b9f\u0ba3-\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0be6-\u0be' +
'f\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58-\' +
'u0c59\u0c60-\u0c61\u0c66-\u0c6f\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0' +
'cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0-\u0ce1\u0ce6-\u0cef\u0d05-\u0d0c\u0d0e-\u0d10' +
'\u0d12-\u0d28\u0d2a-\u0d39\u0d3d\u0d60-\u0d61\u0d66-\u0d6f\u0d7a-\u0d7f\u0d85-\u' +
'0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0e01-\u0e30\u0e32-\u0e33\u0e4' +
'0-\u0e46\u0e50-\u0e59\u0e81-\u0e82\u0e84\u0e87-\u0e88\u0e8a\u0e8d\u0e94-\u0e97\u' +
'0e99-\u0e9f\u0ea1-\u0ea3\u0ea5\u0ea7\u0eaa-\u0eab\u0ead-\u0eb0\u0eb2-\u0eb3\u0eb' +
'd\u0ec0-\u0ec4\u0ec6\u0ed0-\u0ed9\u0edc-\u0edd\u0f00\u0f20-\u0f29\u0f40-\u0f47\u' +
'0f49-\u0f6c\u0f88-\u0f8b\u1000-\u102a\u103f-\u1049\u1050-\u1055\u105a-\u105d\u10' +
'61\u1065-\u1066\u106e-\u1070\u1075-\u1081\u108e\u1090-\u1099\u10a0-\u10c5\u10d0-' +
'\u10fa\u10fc\u1100-\u1159\u115f-\u11a2\u11a8-\u11f9\u1200-\u1248\u124a-\u124d\u1' +
'250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b' +
'5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\' +
'u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u1676\u1681-\u169a\u16a0-\u1' +
'6ea\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u177' +
'0\u1780-\u17b3\u17d7\u17dc\u17e0-\u17e9\u1810-\u1819\u1820-\u1877\u1880-\u18a8\u' +
'18aa\u1900-\u191c\u1946-\u196d\u1970-\u1974\u1980-\u19a9\u19c1-\u19c7\u19d0-\u19' +
'd9\u1a00-\u1a16\u1b05-\u1b33\u1b45-\u1b4b\u1b50-\u1b59\u1b83-\u1ba0\u1bae-\u1bb9' +
'\u1c00-\u1c23\u1c40-\u1c49\u1c4d-\u1c7d\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u' +
'1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb' +
'4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\' +
'u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u203f-\u2040\u2054\u2071\u207f\u2090-\u2094\u210' +
'2\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2' +
'139\u213c-\u213f\u2145-\u2149\u214e\u2183-\u2184\u2c00-\u2c2e\u2c30-\u2c5e\u2c60' +
'-\u2c6f\u2c71-\u2c7d\u2c80-\u2ce4\u2d00-\u2d25\u2d30-\u2d65\u2d6f\u2d80-\u2d96\u' +
'2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2d' +
'd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005-\u3006\u3031-\u3035\u303b-\u303c\u3041-\u3096' +
'\u309d-\u309f\u30a1-\u30fa\u30fc-\u30ff\u3105-\u312d\u3131-\u318e\u31a0-\u31b7\u' +
'31f0-\u31ff\u3400-\u4db5\u4e00-\u9fc3\ua000-\ua48c\ua500-\ua60c\ua610-\ua62b\ua6' +
'40-\ua65f\ua662-\ua66e\ua67f-\ua697\ua717-\ua71f\ua722-\ua788\ua78b-\ua78c\ua7fb' +
'-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8d0-\' +
'ua8d9\ua900-\ua925\ua930-\ua946\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uaa50-\ua' +
'a59\uac00-\ud7a3\uf900-\ufa2d\ufa30-\ufa6a\ufa70-\ufad9\ufb00-\ufb06\ufb13-\ufb1' +
'7\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40-\ufb41\ufb43-\ufb44\u' +
'fb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe33-\ufe34\ufe' +
'4d-\ufe4f\ufe70-\ufe74\ufe76-\ufefc\uff10-\uff19\uff21-\uff3a\uff3f\uff41-\uff5a' +
'\uff66-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc]/g,e="Q".charC' +
'odeAt(0),a="A".charCodeAt(0),r="Z".charCodeAt(0),n="a".charCodeAt(0)-r-1;I=funct' +
'ion(t){return t.replace(u,function(u){for(var t,c=u.charCodeAt(0),f="";c>0;)t=c%' +
'51+a,t>=e&&t++,t>r&&(t+=n),f=String.fromCharCode(t)+f,c=c/51|0;return"Q"+f+"Q"})' +
'},M=function(u){return u.replace(/Q([A-PR-Za-z]{1,3})Q/g,function(u,t){for(var c' +
',f=0,o=0;o<t.length;o++)c=t.charCodeAt(o),c>r&&(c-=n),c>e&&c--,c-=a,f=51*f+c;ret' +
'urn String.fromCharCode(f)})}}();var P=e.asteriskIntraWordEmphasis?k:C;this.make' +
'Html=function(u){if(O)throw new Error("Recursive call to converter.makeHtml");re' +
'turn O=new r,Q=new r,z=[],B=0,u=K.preConversion(u),u=u.replace(/~/g,"~T"),u=u.re' +
'place(/\$/g,"~D"),u=u.replace(/\r\n/g,"\n"),u=u.replace(/\r/g,"\n"),u="\n\n"+u+"' +
'\n\n",u=L(u),u=u.replace(/^[ \t]+$/gm,""),u=K.postNormalization(u),u=t(u),u=n(u)' +
',u=o(u),u=y(u),u=u.replace(/~D/g,"$$"),u=u.replace(/~T/g,"~"),u=K.postConversion' +
'(u),z=Q=O=null,u};var T=function(u){return o(u)},Z={ol:"\\d+[.]",ul:"[*+-]"},H="' +
'[-A-Z0-9+&@#/%?=~_|[\\]()!:,.;]",j="[-A-Z0-9+&@#/%=~_|[\\])]",F=new RegExp(''(="|' +
'<)?\\b(https?|ftp)(://''+H+"*"+j+")(?=$|\\W)","gi"),X=new RegExp(j,"i")}}(); '
+#13'	</script>'
+#13'        <script type="text/javascript">'
+#13'!function(){function r(r){return r.replace(/<[^>]*>?/gi,t)}function t(r){return ' +
'r.match(i)||r.match(s)||r.match(a)?r:""}function e(r){if(""==r)return"";var t=/<' +
'\/?\w+[^>]*(\s|$|>)/g,e=r.toLowerCase().match(t),n=(e||[]).length;if(0==n)return' +
' r;for(var o,i,s,a="<p><img><br><li><hr>",c=[],h=[],u=!1,f=0;n>f;f++)if(o=e[f].r' +
'eplace(/<\/?(\w+).*/,"$1"),!(c[f]||a.search("<"+o+">")>-1)){if(i=e[f],s=-1,!/^<\' +
'//.test(i))for(var p=f+1;n>p;p++)if(!c[p]&&e[p]=="</"+o+">"){s=p;break}-1==s?u=h' +
'[f]=!0:c[s]=!0}if(!u)return r;var f=0;return r=r.replace(t,function(r){var t=h[f' +
']?"":r;return f++,t})}var n,o;"object"==typeof exports&&"function"==typeof requi' +
're?(n=exports,o=require("./Markdown.Converter").Converter):(n=window.Markdown,o=' +
'n.Converter),n.getSanitizingConverter=function(){var t=new o;return t.hooks.chai' +
'n("postConversion",r),t.hooks.chain("postConversion",e),t};var i=/^(<\/?(b|block' +
'quote|code|del|dd|dl|dt|em|h1|h2|h3|i|kbd|li|ol(?: start="\d+")?|p|pre|s|sup|sub' +
'|strong|strike|ul)>|<(br|hr)\s?\/?>)$/i,s=/^(<a\shref="((https?|ftp):\/\/|\/)[-A' +
'-Za-z0-9+&@#\/%?=~_|!:,.;\(\)*[\]$]+"(\stitle="[^"<>]+")?\s?>|<\/a>)$/i,a=/^(<im' +
'g\ssrc="(https?:\/\/|\/)[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)*[\]$]+"(\swidth="\d{1,3' +
'}")?(\sheight="\d{1,3}")?(\salt="[^"<>]*")?(\stitle="[^"<>]*")?\s?\/?>)$/i}(); '
+#13'	</script>        '
+#13' <script type="text/javascript">'
+#13'            '
+#13'                var conversor = Markdown.getSanitizingConverter();'
+#13'		function update(){'
+#13'			var res = conversor.makeHtml(document.getElementById(''wmd-input'').value);'
+#13'			document.getElementById(''resultado'').innerHTML = res;	'
+#13'		}'
+#13'            update();'
+#13'        </script>';


//MARKDOWNJS v0.6.0beta1 https://github.com/evilstreak/markdown-js
MARKDOWNJS = '<script type="text/javascript">'
+#13'!function(a){function b(){return"Markdown.mk_block( "+uneval(this.toString())+",' +
' "+uneval(this.trailing)+", "+uneval(this.lineNumber)+" )"}function c(){var a=re' +
'quire("util");return"Markdown.mk_block( "+a.inspect(this.toString())+", "+a.insp' +
'ect(this.trailing)+", "+a.inspect(this.lineNumber)+" )"}function d(a){for(var b=' +
'0,c=-1;-1!==(c=a.indexOf("\n",c+1));)b++;return b}function e(a){return a.replace' +
'(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").' +
'replace(/''/g,"&#39;")}function f(a){if("string"==typeof a)return e(a);var b=a.sh' +
'ift(),c={},d=[];for(!a.length||"object"!=typeof a[0]||a[0]instanceof Array||(c=a' +
'.shift());a.length;)d.push(f(a.shift()));var g="";for(var h in c)g+=" "+h+''="''+e' +
'(c[h])+''"'';return"img"===b||"br"===b||"hr"===b?"<"+b+g+"/>":"<"+b+g+">"+d.join("' +
'")+"</"+b+">"}function g(a,b,c){var d;c=c||{};var e=a.slice(0);"function"==typeo' +
'f c.preprocessTreeNode&&(e=c.preprocessTreeNode(e,b));var f=o(e);if(f){e[1]={};f' +
'or(d in f)e[1][d]=f[d];f=e[1]}if("string"==typeof e)return e;switch(e[0]){case"h' +
'eader":e[0]="h"+e[1].level,delete e[1].level;break;case"bulletlist":e[0]="ul";br' +
'eak;case"numberlist":e[0]="ol";break;case"listitem":e[0]="li";break;case"para":e' +
'[0]="p";break;case"markdown":e[0]="html",f&&delete f.references;break;case"code_' +
'block":e[0]="pre",d=f?2:1;var h=["code"];h.push.apply(h,e.splice(d,e.length-d)),' +
'e[d]=h;break;case"inlinecode":e[0]="code";break;case"img":e[1].src=e[1].href,del' +
'ete e[1].href;break;case"linebreak":e[0]="br";break;case"link":e[0]="a";break;ca' +
'se"link_ref":e[0]="a";var i=b[f.ref];if(!i)return f.original;delete f.ref,f.href' +
'=i.href,i.title&&(f.title=i.title),delete f.original;break;case"img_ref":e[0]="i' +
'mg";var i=b[f.ref];if(!i)return f.original;delete f.ref,f.src=i.href,i.title&&(f' +
'.title=i.title),delete f.original}if(d=1,f){for(var j in e[1]){d=2;break}1===d&&' +
'e.splice(d,1)}for(;d<e.length;++d)e[d]=g(e[d],b,c);return e}function h(a){for(va' +
'r b=o(a)?2:1;b<a.length;)"string"==typeof a[b]?b+1<a.length&&"string"==typeof a[' +
'b+1]?a[b]+=a.splice(b+1,1)[0]:++b:(h(a[b]),++b)}function i(a,b){function c(a){th' +
'is.len_after=a,this.name="close_"+b}var d=a+"_state",e="strong"===a?"em_state":"' +
'strong_state";return function(f){if(this[d][0]===b)return this[d].shift(),[f.len' +
'gth,new c(f.length-b.length)];var g=this[e].slice(),h=this[d].slice();this[d].un' +
'shift(b);var i=this.processInline(f.substr(b.length)),j=i[i.length-1];if(this[d]' +
'.shift(),j instanceof c){i.pop();var k=f.length-j.len_after;return[k,[a].concat(' +
'i)]}return this[e]=g,this[d]=h,[b.length,b]}}function j(a){for(var b=a.split("")' +
',c=[""],d=!1;b.length;){var e=b.shift();switch(e){case" ":d?c[c.length-1]+=e:c.p' +
'ush("");break;case"''":case''"'':d=!d;break;case"\\":e=b.shift();default:c[c.length' +
'-1]+=e}}return c}var k={};k.mk_block=function(a,d,e){1===arguments.length&&(d="\' +
'n\n");var f=new String(a);return f.trailing=d,f.inspect=c,f.toSource=b,void 0!==' +
'e&&(f.lineNumber=e),f};var l=k.isArray=Array.isArray||function(a){return"[object' +
' Array]"===Object.prototype.toString.call(a)};k.forEach=Array.prototype.forEach?' +
'function(a,b,c){return a.forEach(b,c)}:function(a,b,c){for(var d=0;d<a.length;d+' +
'+)b.call(c||a,a[d],d,a)},k.isEmpty=function(a){for(var b in a)if(hasOwnProperty.' +
'call(a,b))return!1;return!0},k.extract_attr=function(a){return l(a)&&a.length>1&' +
'&"object"==typeof a[1]&&!l(a[1])?a[1]:void 0};var m=function(a){switch(typeof a)' +
'{case"undefined":this.dialect=m.dialects.Gruber;break;case"object":this.dialect=' +
'a;break;default:if(!(a in m.dialects))throw new Error("Unknown Markdown dialect ' +
'''"+String(a)+"''");this.dialect=m.dialects[a]}this.em_state=[],this.strong_state=' +
'[],this.debug_indent=""};m.dialects={};var n=m.mk_block=k.mk_block,l=k.isArray;m' +
'.parse=function(a,b){var c=new m(b);return c.toTree(a)},m.prototype.split_blocks' +
'=function(a){a=a.replace(/(\r\n|\n|\r)/g,"\n");var b,c=/([\s\S]+?)($|\n#|\n(?:\s' +
'*\n|$)+)/g,e=[],f=1;for(null!==(b=/^(\s*\n)/.exec(a))&&(f+=d(b[0]),c.lastIndex=b' +
'[0].length);null!==(b=c.exec(a));)"\n#"===b[2]&&(b[2]="\n",c.lastIndex--),e.push' +
'(n(b[1],b[2],f)),f+=d(b[0]);return e},m.prototype.processBlock=function(a,b){var' +
' c=this.dialect.block,d=c.__order__;if("__call__"in c)return c.__call__.call(thi' +
's,a,b);for(var e=0;e<d.length;e++){var f=c[d[e]].call(this,a,b);if(f)return(!l(f' +
')||f.length>0&&!l(f[0]))&&this.debug(d[e],"didn''t return a proper array"),f}retu' +
'rn[]},m.prototype.processInline=function(a){return this.dialect.inline.__call__.' +
'call(this,String(a))},m.prototype.toTree=function(a,b){var c=a instanceof Array?' +
'a:this.split_blocks(a),d=this.tree;try{for(this.tree=b||this.tree||["markdown"];' +
'c.length;){var e=this.processBlock(c.shift(),c);e.length&&this.tree.push.apply(t' +
'his.tree,e)}return this.tree}finally{b&&(this.tree=d)}},m.prototype.debug=functi' +
'on(){var a=Array.prototype.slice.call(arguments);a.unshift(this.debug_indent),"u' +
'ndefined"!=typeof print&&print.apply(print,a),"undefined"!=typeof console&&"unde' +
'fined"!=typeof console.log&&console.log.apply(null,a)},m.prototype.loop_re_over_' +
'block=function(a,b,c){for(var d,e=b.valueOf();e.length&&null!==(d=a.exec(e));)e=' +
'e.substr(d[0].length),c.call(this,d);return e},m.buildBlockOrder=function(a){var' +
' b=[];for(var c in a)"__order__"!==c&&"__call__"!==c&&b.push(c);a.__order__=b},m' +
'.buildInlinePatterns=function(a){var b=[];for(var c in a)if(!c.match(/^__.*__$/)' +
'){var d=c.replace(/([\\.*+?|()\[\]{}])/g,"\\$1").replace(/\n/,"\\n");b.push(1===' +
'c.length?d:"(?:"+d+")")}b=b.join("|"),a.__patterns__=b;var e=a.__call__;a.__call' +
'__=function(a,c){return void 0!==c?e.call(this,a,c):e.call(this,a,b)}};var o=k.e' +
'xtract_attr;m.renderJsonML=function(a,b){b=b||{},b.root=b.root||!1;var c=[];if(b' +
'.root)c.push(f(a));else for(a.shift(),!a.length||"object"!=typeof a[0]||a[0]inst' +
'anceof Array||a.shift();a.length;)c.push(f(a.shift()));return c.join("\n\n")},m.' +
'toHTMLTree=function(a,b,c){"string"==typeof a&&(a=this.parse(a,b));var d=o(a),e=' +
'{};d&&d.references&&(e=d.references);var f=g(a,e,c);return h(f),f},m.toHTML=func' +
'tion(a,b,c){var d=this.toHTMLTree(a,b,c);return this.renderJsonML(d)};var p={};p' +
'.inline_until_char=function(a,b){for(var c=0,d=[];;){if(a.charAt(c)===b)return c' +
'++,[c,d];if(c>=a.length)return null;var e=this.dialect.inline.__oneElement__.cal' +
'l(this,a.substr(c));c+=e[0],d.push.apply(d,e.slice(1))}},p.subclassDialect=funct' +
'ion(a){function b(){}function c(){}return b.prototype=a.block,c.prototype=a.inli' +
'ne,{block:new b,inline:new c}};var q=k.forEach,o=k.extract_attr,n=k.mk_block,r=k' +
'.isEmpty,s=p.inline_until_char,t={block:{atxHeader:function(a,b){var c=a.match(/' +
'^(#{1,6})\s*(.*?)\s*#*\s*(?:\n|$)/);if(!c)return void 0;var d=["header",{level:c' +
'[1].length}];return Array.prototype.push.apply(d,this.processInline(c[2])),c[0].' +
'length<a.length&&b.unshift(n(a.substr(c[0].length),a.trailing,a.lineNumber+2)),[' +
'd]},setextHeader:function(a,b){var c=a.match(/^(.*)\n([-=])\2\2+(?:\n|$)/);if(!c' +
')return void 0;var d="="===c[2]?1:2,e=["header",{level:d},c[1]];return c[0].leng' +
'th<a.length&&b.unshift(n(a.substr(c[0].length),a.trailing,a.lineNumber+2)),[e]},' +
'code:function(a,b){var c=[],d=/^(?: {0,3}\t| {4})(.*)\n?/;if(!a.match(d))return ' +
'void 0;a:for(;;){var e=this.loop_re_over_block(d,a.valueOf(),function(a){c.push(' +
'a[1])});if(e.length){b.unshift(n(e,a.trailing));break a}if(!b.length)break a;if(' +
'!b[0].match(d))break a;c.push(a.trailing.replace(/[^\n]/g,"").substring(2)),a=b.' +
'shift()}return[["code_block",c.join("\n")]]},horizRule:function(a,b){var c=a.mat' +
'ch(/^(?:([\s\S]*?)\n)?[ \t]*([-_*])(?:[ \t]*\2){2,}[ \t]*(?:\n([\s\S]*))?$/);if(' +
'!c)return void 0;var d=[["hr"]];if(c[1]){var e=n(c[1],"",a.lineNumber);d.unshift' +
'.apply(d,this.toTree(e,[]))}return c[3]&&b.unshift(n(c[3],a.trailing,a.lineNumbe' +
'r+1)),d},lists:function(){function a(a){return new RegExp("(?:^("+i+"{0,"+a+"} {' +
'0,3})("+f+")\\s+)|"+"(^"+i+"{0,"+(a-1)+"}[ ]{0,4})")}function b(a){return a.repl' +
'ace(/ {0,3}\t/g,"    ")}function c(a,b,c,d){if(b)return a.push(["para"].concat(c' +
')),void 0;var e=a[a.length-1]instanceof Array&&"para"===a[a.length-1][0]?a[a.len' +
'gth-1]:a;d&&a.length>1&&c.unshift(d);for(var f=0;f<c.length;f++){var g=c[f],h="s' +
'tring"==typeof g;h&&e.length>1&&"string"==typeof e[e.length-1]?e[e.length-1]+=g:' +
'e.push(g)}}function d(a,b){for(var c=new RegExp("^("+i+"{"+a+"}.*?\\n?)*$"),d=ne' +
'w RegExp("^"+i+"{"+a+"}","gm"),e=[];b.length>0&&c.exec(b[0]);){var f=b.shift(),g' +
'=f.replace(d,"");e.push(n(g,f.trailing,f.lineNumber))}return e}function e(a,b,c)' +
'{var d=a.list,e=d[d.length-1];if(!(e[1]instanceof Array&&"para"===e[1][0]))if(b+' +
'1===c.length)e.push(["para"].concat(e.splice(1,e.length-1)));else{var f=e.pop();' +
'e.push(["para"].concat(e.splice(1,e.length-1)),f)}}var f="[*+-]|\\d+\\.",g=/[*+-' +
']/,h=new RegExp("^( {0,3})("+f+")[ 	]+"),i="(?: {0,3}\\t| {4})";return function(' +
'f,i){function j(a){var b=g.exec(a[2])?["bulletlist"]:["numberlist"];return n.pus' +
'h({list:b,indent:a[1]}),b}var k=f.match(h);if(!k)return void 0;for(var l,m,n=[],' +
'o=j(k),p=!1,r=[n[0].list];;){for(var s=f.split(/(?=\n)/),t="",u="",v=0;v<s.lengt' +
'h;v++){u="";var w=s[v].replace(/^\n/,function(a){return u=a,""}),x=a(n.length);i' +
'f(k=w.match(x),void 0!==k[1]){t.length&&(c(l,p,this.processInline(t),u),p=!1,t="' +
'"),k[1]=b(k[1]);var y=Math.floor(k[1].length/4)+1;if(y>n.length)o=j(k),l.push(o)' +
',l=o[1]=["listitem"];else{var z=!1;for(m=0;m<n.length;m++)if(n[m].indent===k[1])' +
'{o=n[m].list,n.splice(m+1,n.length-(m+1)),z=!0;break}z||(y++,y<=n.length?(n.spli' +
'ce(y,n.length-y),o=n[y-1].list):(o=j(k),l.push(o))),l=["listitem"],o.push(l)}u="' +
'"}w.length>k[0].length&&(t+=u+w.substr(k[0].length))}t.length&&(c(l,p,this.proce' +
'ssInline(t),u),p=!1,t="");var A=d(n.length,i);A.length>0&&(q(n,e,this),l.push.ap' +
'ply(l,this.toTree(A,[])));var B=i[0]&&i[0].valueOf()||"";if(!B.match(h)&&!B.matc' +
'h(/^ /))break;f=i.shift();var C=this.dialect.block.horizRule(f,i);if(C){r.push.a' +
'pply(r,C);break}q(n,e,this),p=!0}return r}}(),blockquote:function(a,b){if(!a.mat' +
'ch(/^>/m))return void 0;var c=[];if(">"!==a[0]){for(var d=a.split(/\n/),e=[],f=a' +
'.lineNumber;d.length&&">"!==d[0][0];)e.push(d.shift()),f++;var g=n(e.join("\n"),' +
'"\n",a.lineNumber);c.push.apply(c,this.processBlock(g,[])),a=n(d.join("\n"),a.tr' +
'ailing,f)}for(;b.length&&">"===b[0][0];){var h=b.shift();a=n(a+a.trailing+h,h.tr' +
'ailing,a.lineNumber)}var i=a.replace(/^> ?/gm,""),j=(this.tree,this.toTree(i,["b' +
'lockquote"])),k=o(j);return k&&k.references&&(delete k.references,r(k)&&j.splice' +
'(1,1)),c.push(j),c},referenceDefn:function(a,b){var c=/^\s*\[(.*?)\]:\s*(\S+)(?:' +
'\s+(?:([''"])(.*?)\3|\((.*?)\)))?\n?/;if(!a.match(c))return void 0;o(this.tree)||' +
'this.tree.splice(1,0,{});var d=o(this.tree);void 0===d.references&&(d.references' +
'={});var e=this.loop_re_over_block(c,a,function(a){a[2]&&"<"===a[2][0]&&">"===a[' +
'2][a[2].length-1]&&(a[2]=a[2].substring(1,a[2].length-1));var b=d.references[a[1' +
'].toLowerCase()]={href:a[2]};void 0!==a[4]?b.title=a[4]:void 0!==a[5]&&(b.title=' +
'a[5])});return e.length&&b.unshift(n(e,a.trailing)),[]},para:function(a){return[' +
'["para"].concat(this.processInline(a))]}},inline:{__oneElement__:function(a,b,c)' +
'{var d,e;b=b||this.dialect.inline.__patterns__;var f=new RegExp("([\\s\\S]*?)("+' +
'(b.source||b)+")");if(d=f.exec(a),!d)return[a.length,a];if(d[1])return[d[1].leng' +
'th,d[1]];var e;return d[2]in this.dialect.inline&&(e=this.dialect.inline[d[2]].c' +
'all(this,a.substr(d.index),d,c||[])),e=e||[d[2].length,d[2]]},__call__:function(' +
'a,b){function c(a){"string"==typeof a&&"string"==typeof e[e.length-1]?e[e.length' +
'-1]+=a:e.push(a)}for(var d,e=[];a.length>0;)d=this.dialect.inline.__oneElement__' +
'.call(this,a,b,e),a=a.substr(d.shift()),q(d,c);return e},"]":function(){},"}":fu' +
'nction(){},__escape__:/^\\[\\`\*_{}\[\]()#\+.!\-]/,"\\":function(a){return this.' +
'dialect.inline.__escape__.exec(a)?[2,a.charAt(1)]:[1,"\\"]},"![":function(a){var' +
' b=a.match(/^!\[(.*?)\][ \t]*\([ \t]*([^")]*?)(?:[ \t]+(["''])(.*?)\3)?[ \t]*\)/)' +
';if(b){b[2]&&"<"===b[2][0]&&">"===b[2][b[2].length-1]&&(b[2]=b[2].substring(1,b[' +
'2].length-1)),b[2]=this.dialect.inline.__call__.call(this,b[2],/\\/)[0];var c={a' +
'lt:b[1],href:b[2]||""};return void 0!==b[4]&&(c.title=b[4]),[b[0].length,["img",' +
'c]]}return b=a.match(/^!\[(.*?)\][ \t]*\[(.*?)\]/),b?[b[0].length,["img_ref",{al' +
't:b[1],ref:b[2].toLowerCase(),original:b[0]}]]:[2,"!["]},"[":function v(a){var b' +
'=String(a),c=s.call(this,a.substr(1),"]");if(!c)return[1,"["];var v,d,e=1+c[0],f' +
'=c[1];a=a.substr(e);var g=a.match(/^\s*\([ \t]*([^"'']*)(?:[ \t]+(["''])(.*?)\2)?[' +
' \t]*\)/);if(g){var h=g[1];if(e+=g[0].length,h&&"<"===h[0]&&">"===h[h.length-1]&' +
'&(h=h.substring(1,h.length-1)),!g[3])for(var i=1,j=0;j<h.length;j++)switch(h[j])' +
'{case"(":i++;break;case")":0===--i&&(e-=h.length-j,h=h.substring(0,j))}return h=' +
'this.dialect.inline.__call__.call(this,h,/\\/)[0],d={href:h||""},void 0!==g[3]&&' +
'(d.title=g[3]),v=["link",d].concat(f),[e,v]}return g=a.match(/^\s*\[(.*?)\]/),g?' +
'(e+=g[0].length,d={ref:(g[1]||String(f)).toLowerCase(),original:b.substr(0,e)},v' +
'=["link_ref",d].concat(f),[e,v]):1===f.length&&"string"==typeof f[0]?(d={ref:f[0' +
'].toLowerCase(),original:b.substr(0,e)},v=["link_ref",d,f[0]],[e,v]):[1,"["]},"<' +
'":function(a){var b;return null!==(b=a.match(/^<(?:((https?|ftp|mailto):[^>]+)|(' +
'.*?@.*?\.[a-zA-Z]+))>/))?b[3]?[b[0].length,["link",{href:"mailto:"+b[3]},b[3]]]:' +
'"mailto"===b[2]?[b[0].length,["link",{href:b[1]},b[1].substr("mailto:".length)]]' +
':[b[0].length,["link",{href:b[1]},b[1]]]:[1,"<"]},"`":function(a){var b=a.match(' +
'/(`+)(([\s\S]*?)\1)/);return b&&b[2]?[b[1].length+b[2].length,["inlinecode",b[3]' +
']]:[1,"`"]},"  \n":function(){return[3,["linebreak"]]}}};t.inline["**"]=i("stron' +
'g","**"),t.inline.__=i("strong","__"),t.inline["*"]=i("em","*"),t.inline._=i("em' +
'","_"),m.dialects.Gruber=t,m.buildBlockOrder(m.dialects.Gruber.block),m.buildInl' +
'inePatterns(m.dialects.Gruber.inline);var u=p.subclassDialect(t),o=k.extract_att' +
'r,q=k.forEach;u.processMetaHash=function(a){for(var b=j(a),c={},d=0;d<b.length;+' +
'+d)if(/^#/.test(b[d]))c.id=b[d].substring(1);else if(/^\./.test(b[d]))c["class"]' +
'=c["class"]?c["class"]+b[d].replace(/./," "):b[d].substring(1);else if(/\=/.test' +
'(b[d])){var e=b[d].split(/\=/);c[e[0]]=e[1]}return c},u.block.document_meta=func' +
'tion(a){if(a.lineNumber>1)return void 0;if(!a.match(/^(?:\w+:.*\n)*\w+:.*$/))ret' +
'urn void 0;o(this.tree)||this.tree.splice(1,0,{});var b=a.split(/\n/);for(var c ' +
'in b){var d=b[c].match(/(\w+):\s*(.*)$/),e=d[1].toLowerCase(),f=d[2];this.tree[1' +
'][e]=f}return[]},u.block.block_meta=function(a){var b=a.match(/(^|\n) {0,3}\{:\s' +
'*((?:\\\}|[^\}])*)\s*\}$/);if(!b)return void 0;var c,d=this.dialect.processMetaH' +
'ash(b[2]);if(""===b[1]){var e=this.tree[this.tree.length-1];if(c=o(e),"string"==' +
'typeof e)return void 0;c||(c={},e.splice(1,0,c));for(var f in d)c[f]=d[f];return' +
'[]}var g=a.replace(/\n.*$/,""),h=this.processBlock(g,[]);c=o(h[0]),c||(c={},h[0]' +
'.splice(1,0,c));for(var f in d)c[f]=d[f];return h},u.block.definition_list=funct' +
'ion(a,b){var c,d,e=/^((?:[^\s:].*\n)+):\s+([\s\S]+)$/,f=["dl"];if(!(d=a.match(e)' +
'))return void 0;for(var g=[a];b.length&&e.exec(b[0]);)g.push(b.shift());for(var ' +
'h=0;h<g.length;++h){var d=g[h].match(e),i=d[1].replace(/\n$/,"").split(/\n/),j=d' +
'[2].split(/\n:\s+/);for(c=0;c<i.length;++c)f.push(["dt",i[c]]);for(c=0;c<j.lengt' +
'h;++c)f.push(["dd"].concat(this.processInline(j[c].replace(/(\n)\s+/,"$1"))))}re' +
'turn[f]},u.block.table=function w(a){var b,c,d=function(a,b){b=b||"\\s",b.match(' +
'/^[\\|\[\]{}?*.+^$]$/)&&(b="\\"+b);for(var c,d=[],e=new RegExp("^((?:\\\\.|[^\\\' +
'\"+b+"])*)"+b+"(.*)");c=a.match(e);)d.push(c[1]),a=c[2];return d.push(a),d},e=/^' +
' {0,3}\|(.+)\n {0,3}\|\s*([\-:]+[\-| :]*)\n((?:\s*\|.*(?:\n|$))*)(?=\n|$)/,f=/^ ' +
'{0,3}(\S(?:\\.|[^\\|])*\|.*)\n {0,3}([\-:]+\s*\|[\-| :]*)\n((?:(?:\\.|[^\\|])*\|' +
'.*(?:\n|$))*)(?=\n|$)/;if(c=a.match(e))c[3]=c[3].replace(/^\s*\|/gm,"");else if(' +
'!(c=a.match(f)))return void 0;var w=["table",["thead",["tr"]],["tbody"]];c[2]=c[' +
'2].replace(/\|\s*$/,"").split("|");var g=[];for(q(c[2],function(a){a.match(/^\s*' +
'-+:\s*$/)?g.push({align:"right"}):a.match(/^\s*:-+\s*$/)?g.push({align:"left"}):' +
'a.match(/^\s*:-+:\s*$/)?g.push({align:"center"}):g.push({})}),c[1]=d(c[1].replac' +
'e(/\|\s*$/,""),"|"),b=0;b<c[1].length;b++)w[1][1].push(["th",g[b]||{}].concat(th' +
'is.processInline(c[1][b].trim())));return q(c[3].replace(/\|\s*$/gm,"").split("\' +
'n"),function(a){var c=["tr"];for(a=d(a,"|"),b=0;b<a.length;b++)c.push(["td",g[b]' +
'||{}].concat(this.processInline(a[b].trim())));w[2].push(c)},this),[w]},u.inline' +
'["{:"]=function(a,b,c){if(!c.length)return[2,"{:"];var d=c[c.length-1];if("strin' +
'g"==typeof d)return[2,"{:"];var e=a.match(/^\{:\s*((?:\\\}|[^\}])*)\s*\}/);if(!e' +
')return[2,"{:"];var f=this.dialect.processMetaHash(e[1]),g=o(d);g||(g={},d.splic' +
'e(1,0,g));for(var h in f)g[h]=f[h];return[e[0].length,""]},m.dialects.Maruku=u,m' +
'.dialects.Maruku.inline.__escape__=/^\\[\\`\*_{}\[\]()#\+.!\-|:]/,m.buildBlockOr' +
'der(m.dialects.Maruku.block),m.buildInlinePatterns(m.dialects.Maruku.inline),a.M' +
'arkdown=m,a.parse=m.parse,a.toHTML=m.toHTML,a.toHTMLTree=m.toHTMLTree,a.renderJs' +
'onML=m.renderJsonML}(function(){return window.markdown={},window.markdown}()); '
+#13'	</script>        '
+#13'	'
+#13'	 <script type="text/javascript">'
+#13'            '
+#13'		function update(){'
+#13'			var res = markdown.toHTML(document.getElementById(''wmd-input'').value);'
+#13'			document.getElementById(''resultado'').innerHTML = res;	'
+#13'		}'
+#13'            update();'
+#13'        </script>';

// MARKED v0.3.5 //https://github.com/chjj/marked
MARKED = '<script type="text/javascript">'
+#13'(function(){function e(e){this.tokens=[],this.tokens.links={},this.options=e||a.' +
'defaults,this.rules=p.normal,this.options.gfm&&(this.options.tables?this.rules=p' +
'.tables:this.rules=p.gfm)}function t(e,t){if(this.options=t||a.defaults,this.lin' +
'ks=e,this.rules=u.normal,this.renderer=this.options.renderer||new n,this.rendere' +
'r.options=this.options,!this.links)throw new Error("Tokens array requires a `lin' +
'ks` property.");this.options.gfm?this.options.breaks?this.rules=u.breaks:this.ru' +
'les=u.gfm:this.options.pedantic&&(this.rules=u.pedantic)}function n(e){this.opti' +
'ons=e||{}}function r(e){this.tokens=[],this.token=null,this.options=e||a.default' +
's,this.options.renderer=this.options.renderer||new n,this.renderer=this.options.' +
'renderer,this.renderer.options=this.options}function s(e,t){return e.replace(t?/' +
'&/g:/&(?!#?\w+;)/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"' +
'/g,"&quot;").replace(/''/g,"&#39;")}function i(e){return e.replace(/&([#\w]+);/g,' +
'function(e,t){return t=t.toLowerCase(),"colon"===t?":":"#"===t.charAt(0)?"x"===t' +
'.charAt(1)?String.fromCharCode(parseInt(t.substring(2),16)):String.fromCharCode(' +
'+t.substring(1)):""})}function l(e,t){return e=e.source,t=t||"",function n(r,s){' +
'return r?(s=s.source||s,s=s.replace(/(^|[^\[])\^/g,"$1"),e=e.replace(r,s),n):new' +
' RegExp(e,t)}}function o(){}function h(e){for(var t,n,r=1;r<arguments.length;r++' +
'){t=arguments[r];for(n in t)Object.prototype.hasOwnProperty.call(t,n)&&(e[n]=t[n' +
'])}return e}function a(t,n,i){if(i||"function"==typeof n){i||(i=n,n=null),n=h({}' +
',a.defaults,n||{});var l,o,p=n.highlight,u=0;try{l=e.lex(t,n)}catch(c){return i(' +
'c)}o=l.length;var g=function(e){if(e)return n.highlight=p,i(e);var t;try{t=r.par' +
'se(l,n)}catch(s){e=s}return n.highlight=p,e?i(e):i(null,t)};if(!p||p.length<3)re' +
'turn g();if(delete n.highlight,!o)return g();for(;u<l.length;u++)!function(e){re' +
'turn"code"!==e.type?--o||g():p(e.text,e.lang,function(t,n){return t?g(t):null==n' +
'||n===e.text?--o||g():(e.text=n,e.escaped=!0,void(--o||g()))})}(l[u])}else try{r' +
'eturn n&&(n=h({},a.defaults,n)),r.parse(e.lex(t,n),n)}catch(c){if(c.message+="\n' +
'Please report this to https://github.com/chjj/marked.",(n||a.defaults).silent)re' +
'turn"<p>An error occured:</p><pre>"+s(c.message+"",!0)+"</pre>";throw c}}var p={' +
'newline:/^\n+/,code:/^( {4}[^\n]+\n*)+/,fences:o,hr:/^( *[-*_]){3,} *(?:\n+|$)/,' +
'heading:/^ *(#{1,6}) *([^\n]+?) *#* *(?:\n+|$)/,nptable:o,lheading:/^([^\n]+)\n ' +
'*(=|-){2,} *(?:\n+|$)/,blockquote:/^( *>[^\n]+(\n(?!def)[^\n]+)*\n*)+/,list:/^( ' +
'*)(bull) [\s\S]+?(?:hr|def|\n{2,}(?! )(?!\1bull )\n*|\s*$)/,html:/^ *(?:comment ' +
'*(?:\n|\s*$)|closed *(?:\n{2,}|\s*$)|closing *(?:\n{2,}|\s*$))/,def:/^ *\[([^\]]' +
'+)\]: *<?([^\s>]+)>?(?: +["(]([^\n]+)[")])? *(?:\n+|$)/,table:o,paragraph:/^((?:' +
'[^\n]+\n?(?!hr|heading|lheading|blockquote|tag|def))+)\n*/,text:/^[^\n]+/};p.bul' +
'let=/(?:[*+-]|\d+\.)/,p.item=/^( *)(bull) [^\n]*(?:\n(?!\1bull )[^\n]*)*/,p.item' +
'=l(p.item,"gm")(/bull/g,p.bullet)(),p.list=l(p.list)(/bull/g,p.bullet)("hr","\\n' +
'+(?=\\1?(?:[-*_] *){3,}(?:\\n+|$))")("def","\\n+(?="+p.def.source+")")(),p.block' +
'quote=l(p.blockquote)("def",p.def)(),p._tag="(?!(?:a|em|strong|small|s|cite|q|df' +
'n|abbr|data|time|code|var|samp|kbd|sub|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo|span|br' +
'|wbr|ins|del|img)\\b)\\w+(?!:/|[^\\w\\s@]*@)\\b",p.html=l(p.html)("comment",/<!-' +
'-[\s\S]*?-->/)("closed",/<(tag)[\s\S]+?<\/\1>/)("closing",/<tag(?:"[^"]*"|''[^'']*' +
'''|[^''">])*?>/)(/tag/g,p._tag)(),p.paragraph=l(p.paragraph)("hr",p.hr)("heading",' +
'p.heading)("lheading",p.lheading)("blockquote",p.blockquote)("tag","<"+p._tag)("' +
'def",p.def)(),p.normal=h({},p),p.gfm=h({},p.normal,{fences:/^ *(`{3,}|~{3,})[ \.' +
']*(\S+)? *\n([\s\S]*?)\s*\1 *(?:\n+|$)/,paragraph:/^/,heading:/^ *(#{1,6}) +([^\' +
'n]+?) *#* *(?:\n+|$)/}),p.gfm.paragraph=l(p.paragraph)("(?!","(?!"+p.gfm.fences.' +
'source.replace("\\1","\\2")+"|"+p.list.source.replace("\\1","\\3")+"|")(),p.tabl' +
'es=h({},p.gfm,{nptable:/^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))' +
'*)\n*/,table:/^ *\|(.+)\n *\|( *[-:]+[-| :]*)\n((?: *\|.*(?:\n|$))*)\n*/}),e.rul' +
'es=p,e.lex=function(t,n){var r=new e(n);return r.lex(t)},e.prototype.lex=functio' +
'n(e){return e=e.replace(/\r\n|\r/g,"\n").replace(/\t/g,"    ").replace(/\u00a0/g' +
'," ").replace(/\u2424/g,"\n"),this.token(e,!0)},e.prototype.token=function(e,t,n' +
'){for(var r,s,i,l,o,h,a,u,c,e=e.replace(/^ +$/gm,"");e;)if((i=this.rules.newline' +
'.exec(e))&&(e=e.substring(i[0].length),i[0].length>1&&this.tokens.push({type:"sp' +
'ace"})),i=this.rules.code.exec(e))e=e.substring(i[0].length),i=i[0].replace(/^ {' +
'4}/gm,""),this.tokens.push({type:"code",text:this.options.pedantic?i:i.replace(/' +
'\n+$/,"")});else if(i=this.rules.fences.exec(e))e=e.substring(i[0].length),this.' +
'tokens.push({type:"code",lang:i[2],text:i[3]||""});else if(i=this.rules.heading.' +
'exec(e))e=e.substring(i[0].length),this.tokens.push({type:"heading",depth:i[1].l' +
'ength,text:i[2]});else if(t&&(i=this.rules.nptable.exec(e))){for(e=e.substring(i' +
'[0].length),h={type:"table",header:i[1].replace(/^ *| *\| *$/g,"").split(/ *\| *' +
'/),align:i[2].replace(/^ *|\| *$/g,"").split(/ *\| */),cells:i[3].replace(/\n$/,' +
'"").split("\n")},u=0;u<h.align.length;u++)/^ *-+: *$/.test(h.align[u])?h.align[u' +
']="right":/^ *:-+: *$/.test(h.align[u])?h.align[u]="center":/^ *:-+ *$/.test(h.a' +
'lign[u])?h.align[u]="left":h.align[u]=null;for(u=0;u<h.cells.length;u++)h.cells[' +
'u]=h.cells[u].split(/ *\| */);this.tokens.push(h)}else if(i=this.rules.lheading.' +
'exec(e))e=e.substring(i[0].length),this.tokens.push({type:"heading",depth:"="===' +
'i[2]?1:2,text:i[1]});else if(i=this.rules.hr.exec(e))e=e.substring(i[0].length),' +
'this.tokens.push({type:"hr"});else if(i=this.rules.blockquote.exec(e))e=e.substr' +
'ing(i[0].length),this.tokens.push({type:"blockquote_start"}),i=i[0].replace(/^ *' +
'> ?/gm,""),this.token(i,t,!0),this.tokens.push({type:"blockquote_end"});else if(' +
'i=this.rules.list.exec(e)){for(e=e.substring(i[0].length),l=i[2],this.tokens.pus' +
'h({type:"list_start",ordered:l.length>1}),i=i[0].match(this.rules.item),r=!1,c=i' +
'.length,u=0;c>u;u++)h=i[u],a=h.length,h=h.replace(/^ *([*+-]|\d+\.) +/,""),~h.in' +
'dexOf("\n ")&&(a-=h.length,h=this.options.pedantic?h.replace(/^ {1,4}/gm,""):h.r' +
'eplace(new RegExp("^ {1,"+a+"}","gm"),"")),this.options.smartLists&&u!==c-1&&(o=' +
'p.bullet.exec(i[u+1])[0],l===o||l.length>1&&o.length>1||(e=i.slice(u+1).join("\n' +
'")+e,u=c-1)),s=r||/\n\n(?!\s*$)/.test(h),u!==c-1&&(r="\n"===h.charAt(h.length-1)' +
',s||(s=r)),this.tokens.push({type:s?"loose_item_start":"list_item_start"}),this.' +
'token(h,!1,n),this.tokens.push({type:"list_item_end"});this.tokens.push({type:"l' +
'ist_end"})}else if(i=this.rules.html.exec(e))e=e.substring(i[0].length),this.tok' +
'ens.push({type:this.options.sanitize?"paragraph":"html",pre:!this.options.saniti' +
'zer&&("pre"===i[1]||"script"===i[1]||"style"===i[1]),text:i[0]});else if(!n&&t&&' +
'(i=this.rules.def.exec(e)))e=e.substring(i[0].length),this.tokens.links[i[1].toL' +
'owerCase()]={href:i[2],title:i[3]};else if(t&&(i=this.rules.table.exec(e))){for(' +
'e=e.substring(i[0].length),h={type:"table",header:i[1].replace(/^ *| *\| *$/g,""' +
').split(/ *\| */),align:i[2].replace(/^ *|\| *$/g,"").split(/ *\| */),cells:i[3]' +
'.replace(/(?: *\| *)?\n$/,"").split("\n")},u=0;u<h.align.length;u++)/^ *-+: *$/.' +
'test(h.align[u])?h.align[u]="right":/^ *:-+: *$/.test(h.align[u])?h.align[u]="ce' +
'nter":/^ *:-+ *$/.test(h.align[u])?h.align[u]="left":h.align[u]=null;for(u=0;u<h' +
'.cells.length;u++)h.cells[u]=h.cells[u].replace(/^ *\| *| *\| *$/g,"").split(/ *' +
'\| */);this.tokens.push(h)}else if(t&&(i=this.rules.paragraph.exec(e)))e=e.subst' +
'ring(i[0].length),this.tokens.push({type:"paragraph",text:"\n"===i[1].charAt(i[1' +
'].length-1)?i[1].slice(0,-1):i[1]});else if(i=this.rules.text.exec(e))e=e.substr' +
'ing(i[0].length),this.tokens.push({type:"text",text:i[0]});else if(e)throw new E' +
'rror("Infinite loop on byte: "+e.charCodeAt(0));return this.tokens};var u={escap' +
'e:/^\\([\\`*{}\[\]()#+\-.!_>])/,autolink:/^<([^ >]+(@|:\/)[^ >]+)>/,url:o,tag:/^' +
'<!--[\s\S]*?-->|^<\/?\w+(?:"[^"]*"|''[^'']*''|[^''">])*?>/,link:/^!?\[(inside)\]\(hr' +
'ef\)/,reflink:/^!?\[(inside)\]\s*\[([^\]]*)\]/,nolink:/^!?\[((?:\[[^\]]*\]|[^\[\' +
']])*)\]/,strong:/^__([\s\S]+?)__(?!_)|^\*\*([\s\S]+?)\*\*(?!\*)/,em:/^\b_((?:[^_' +
']|__)+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,code:/^(`+)\s*([\s\S]*?[^`])\s*\1(?!' +
'`)/,br:/^ {2,}\n(?!\s*$)/,del:o,text:/^[\s\S]+?(?=[\\<!\[_*`]| {2,}\n|$)/};u._in' +
'side=/(?:\[[^\]]*\]|[^\[\]]|\](?=[^\[]*\]))*/,u._href=/\s*<?([\s\S]*?)>?(?:\s+[''' +
'"]([\s\S]*?)[''"])?\s*/,u.link=l(u.link)("inside",u._inside)("href",u._href)(),u.' +
'reflink=l(u.reflink)("inside",u._inside)(),u.normal=h({},u),u.pedantic=h({},u.no' +
'rmal,{strong:/^__(?=\S)([\s\S]*?\S)__(?!_)|^\*\*(?=\S)([\s\S]*?\S)\*\*(?!\*)/,em' +
':/^_(?=\S)([\s\S]*?\S)_(?!_)|^\*(?=\S)([\s\S]*?\S)\*(?!\*)/}),u.gfm=h({},u.norma' +
'l,{escape:l(u.escape)("])","~|])")(),url:/^(https?:\/\/[^\s<]+[^<.,:;"'')\]\s])/,' +
'del:/^~~(?=\S)([\s\S]*?\S)~~/,text:l(u.text)("]|","~]|")("|","|https?://|")()}),' +
'u.breaks=h({},u.gfm,{br:l(u.br)("{2,}","*")(),text:l(u.gfm.text)("{2,}","*")()})' +
',t.rules=u,t.output=function(e,n,r){var s=new t(n,r);return s.output(e)},t.proto' +
'type.output=function(e){for(var t,n,r,i,l="";e;)if(i=this.rules.escape.exec(e))e' +
'=e.substring(i[0].length),l+=i[1];else if(i=this.rules.autolink.exec(e))e=e.subs' +
'tring(i[0].length),"@"===i[2]?(n=":"===i[1].charAt(6)?this.mangle(i[1].substring' +
'(7)):this.mangle(i[1]),r=this.mangle("mailto:")+n):(n=s(i[1]),r=n),l+=this.rende' +
'rer.link(r,null,n);else if(this.inLink||!(i=this.rules.url.exec(e))){if(i=this.r' +
'ules.tag.exec(e))!this.inLink&&/^<a /i.test(i[0])?this.inLink=!0:this.inLink&&/^' +
'<\/a>/i.test(i[0])&&(this.inLink=!1),e=e.substring(i[0].length),l+=this.options.' +
'sanitize?this.options.sanitizer?this.options.sanitizer(i[0]):s(i[0]):i[0];else i' +
'f(i=this.rules.link.exec(e))e=e.substring(i[0].length),this.inLink=!0,l+=this.ou' +
'tputLink(i,{href:i[2],title:i[3]}),this.inLink=!1;else if((i=this.rules.reflink.' +
'exec(e))||(i=this.rules.nolink.exec(e))){if(e=e.substring(i[0].length),t=(i[2]||' +
'i[1]).replace(/\s+/g," "),t=this.links[t.toLowerCase()],!t||!t.href){l+=i[0].cha' +
'rAt(0),e=i[0].substring(1)+e;continue}this.inLink=!0,l+=this.outputLink(i,t),thi' +
's.inLink=!1}else if(i=this.rules.strong.exec(e))e=e.substring(i[0].length),l+=th' +
'is.renderer.strong(this.output(i[2]||i[1]));else if(i=this.rules.em.exec(e))e=e.' +
'substring(i[0].length),l+=this.renderer.em(this.output(i[2]||i[1]));else if(i=th' +
'is.rules.code.exec(e))e=e.substring(i[0].length),l+=this.renderer.codespan(s(i[2' +
'],!0));else if(i=this.rules.br.exec(e))e=e.substring(i[0].length),l+=this.render' +
'er.br();else if(i=this.rules.del.exec(e))e=e.substring(i[0].length),l+=this.rend' +
'erer.del(this.output(i[1]));else if(i=this.rules.text.exec(e))e=e.substring(i[0]' +
'.length),l+=this.renderer.text(s(this.smartypants(i[0])));else if(e)throw new Er' +
'ror("Infinite loop on byte: "+e.charCodeAt(0))}else e=e.substring(i[0].length),n' +
'=s(i[1]),r=n,l+=this.renderer.link(r,null,n);return l},t.prototype.outputLink=fu' +
'nction(e,t){var n=s(t.href),r=t.title?s(t.title):null;return"!"!==e[0].charAt(0)' +
'?this.renderer.link(n,r,this.output(e[1])):this.renderer.image(n,r,s(e[1]))},t.p' +
'rototype.smartypants=function(e){return this.options.smartypants?e.replace(/---/' +
'g,"—").replace(/--/g,"–").replace(/(^|[-\u2014\/(\[{"\s])''/g,"$1‘").replace(/''/g' +
',"’").replace(/(^|[-\u2014\/(\[{\u2018\s])"/g,"$1“").replace(/"/g,"”").replace(/' +
'\.{3}/g,"…"):e},t.prototype.mangle=function(e){if(!this.options.mangle)return e;' +
'for(var t,n="",r=e.length,s=0;r>s;s++)t=e.charCodeAt(s),Math.random()>.5&&(t="x"' +
'+t.toString(16)),n+="&#"+t+";";return n},n.prototype.code=function(e,t,n){if(thi' +
's.options.highlight){var r=this.options.highlight(e,t);null!=r&&r!==e&&(n=!0,e=r' +
')}return t?''<pre><code class="''+this.options.langPrefix+s(t,!0)+''">''+(n?e:s(e,!0' +
'))+"\n</code></pre>\n":"<pre><code>"+(n?e:s(e,!0))+"\n</code></pre>"},n.prototyp' +
'e.blockquote=function(e){return"<blockquote>\n"+e+"</blockquote>\n"},n.prototype' +
'.html=function(e){return e},n.prototype.heading=function(e,t,n){return"<h"+t+'' i' +
'd="''+this.options.headerPrefix+n.toLowerCase().replace(/[^\w]+/g,"-")+''">''+e+"</' +
'h"+t+">\n"},n.prototype.hr=function(){return this.options.xhtml?"<hr/>\n":"<hr>\' +
'n"},n.prototype.list=function(e,t){var n=t?"ol":"ul";return"<"+n+">\n"+e+"</"+n+' +
'">\n"},n.prototype.listitem=function(e){return"<li>"+e+"</li>\n"},n.prototype.pa' +
'ragraph=function(e){return"<p>"+e+"</p>\n"},n.prototype.table=function(e,t){retu' +
'rn"<table>\n<thead>\n"+e+"</thead>\n<tbody>\n"+t+"</tbody>\n</table>\n"},n.proto' +
'type.tablerow=function(e){return"<tr>\n"+e+"</tr>\n"},n.prototype.tablecell=func' +
'tion(e,t){var n=t.header?"th":"td",r=t.align?"<"+n+'' style="text-align:''+t.align' +
'+''">'':"<"+n+">";return r+e+"</"+n+">\n"},n.prototype.strong=function(e){return"<' +
'strong>"+e+"</strong>"},n.prototype.em=function(e){return"<em>"+e+"</em>"},n.pro' +
'totype.codespan=function(e){return"<code>"+e+"</code>"},n.prototype.br=function(' +
'){return this.options.xhtml?"<br/>":"<br>"},n.prototype.del=function(e){return"<' +
'del>"+e+"</del>"},n.prototype.link=function(e,t,n){if(this.options.sanitize){try' +
'{var r=decodeURIComponent(i(e)).replace(/[^\w:]/g,"").toLowerCase()}catch(s){ret' +
'urn""}if(0===r.indexOf("javascript:")||0===r.indexOf("vbscript:"))return""}var l' +
'=''<a href="''+e+''"'';return t&&(l+='' title="''+t+''"''),l+=">"+n+"</a>"},n.prototype.' +
'image=function(e,t,n){var r=''<img src="''+e+''" alt="''+n+''"'';return t&&(r+='' title' +
'="''+t+''"''),r+=this.options.xhtml?"/>":">"},n.prototype.text=function(e){return e' +
'},r.parse=function(e,t,n){var s=new r(t,n);return s.parse(e)},r.prototype.parse=' +
'function(e){this.inline=new t(e.links,this.options,this.renderer),this.tokens=e.' +
'reverse();for(var n="";this.next();)n+=this.tok();return n},r.prototype.next=fun' +
'ction(){return this.token=this.tokens.pop()},r.prototype.peek=function(){return ' +
'this.tokens[this.tokens.length-1]||0},r.prototype.parseText=function(){for(var e' +
'=this.token.text;"text"===this.peek().type;)e+="\n"+this.next().text;return this' +
'.inline.output(e)},r.prototype.tok=function(){switch(this.token.type){case"space' +
'":return"";case"hr":return this.renderer.hr();case"heading":return this.renderer' +
'.heading(this.inline.output(this.token.text),this.token.depth,this.token.text);c' +
'ase"code":return this.renderer.code(this.token.text,this.token.lang,this.token.e' +
'scaped);case"table":var e,t,n,r,s,i="",l="";for(n="",e=0;e<this.token.header.len' +
'gth;e++)r={header:!0,align:this.token.align[e]},n+=this.renderer.tablecell(this.' +
'inline.output(this.token.header[e]),{header:!0,align:this.token.align[e]});for(i' +
'+=this.renderer.tablerow(n),e=0;e<this.token.cells.length;e++){for(t=this.token.' +
'cells[e],n="",s=0;s<t.length;s++)n+=this.renderer.tablecell(this.inline.output(t' +
'[s]),{header:!1,align:this.token.align[s]});l+=this.renderer.tablerow(n)}return ' +
'this.renderer.table(i,l);case"blockquote_start":for(var l="";"blockquote_end"!==' +
'this.next().type;)l+=this.tok();return this.renderer.blockquote(l);case"list_sta' +
'rt":for(var l="",o=this.token.ordered;"list_end"!==this.next().type;)l+=this.tok' +
'();return this.renderer.list(l,o);case"list_item_start":for(var l="";"list_item_' +
'end"!==this.next().type;)l+="text"===this.token.type?this.parseText():this.tok()' +
';return this.renderer.listitem(l);case"loose_item_start":for(var l="";"list_item' +
'_end"!==this.next().type;)l+=this.tok();return this.renderer.listitem(l);case"ht' +
'ml":var h=this.token.pre||this.options.pedantic?this.token.text:this.inline.outp' +
'ut(this.token.text);return this.renderer.html(h);case"paragraph":return this.ren' +
'derer.paragraph(this.inline.output(this.token.text));case"text":return this.rend' +
'erer.paragraph(this.parseText())}},o.exec=o,a.options=a.setOptions=function(e){r' +
'eturn h(a.defaults,e),a},a.defaults={gfm:!0,tables:!0,breaks:!1,pedantic:!1,sani' +
'tize:!1,sanitizer:null,mangle:!0,smartLists:!1,silent:!1,highlight:null,langPref' +
'ix:"lang-",smartypants:!1,headerPrefix:"",renderer:new n,xhtml:!1},a.Parser=r,a.' +
'parser=r.parse,a.Renderer=n,a.Lexer=e,a.lexer=e.lex,a.InlineLexer=t,a.inlineLexe' +
'r=t.output,a.parse=a,"undefined"!=typeof module&&"object"==typeof exports?module' +
'.exports=a:"function"==typeof define&&define.amd?define(function(){return a}):th' +
'is.marked=a}).call(function(){return this||("undefined"!=typeof window?window:gl' +
'obal)}()); '
+#13'	</script>        '
+#13'	'
+#13'	 <script type="text/javascript">'
+#13'            '
+#13'		function update(){'
+#13'			var res = marked(document.getElementById(''wmd-input'').value);'
+#13'			document.getElementById(''resultado'').innerHTML = res;	'
+#13'		}'
+#13'            update();'
+#13'        </script>';


//SHOWDOWN v1.4.2 https://github.com/showdownjs/showdown seems to not work :(
SHOWDOWN = '<script type="text/javascript">'
+#13'(function(){function e(e){"use strict";var r={omitExtraWLInCodeBlocks:{"default"' +
':!1,describe:"Omit the default extra whiteline added to code blocks",type:"boole' +
'an"},noHeaderId:{"default":!1,describe:"Turn on/off generated header id",type:"b' +
'oolean"},prefixHeaderId:{"default":!1,describe:"Specify a prefix to generated he' +
'ader ids",type:"string"},headerLevelStart:{"default":!1,describe:"The header blo' +
'cks level start",type:"integer"},parseImgDimensions:{"default":!1,describe:"Turn' +
' on/off image dimension parsing",type:"boolean"},simplifiedAutoLink:{"default":!' +
'1,describe:"Turn on/off GFM autolink style",type:"boolean"},literalMidWordUnders' +
'cores:{"default":!1,describe:"Parse midword underscores as literal underscores",' +
'type:"boolean"},strikethrough:{"default":!1,describe:"Turn on/off strikethrough ' +
'support",type:"boolean"},tables:{"default":!1,describe:"Turn on/off tables suppo' +
'rt",type:"boolean"},tablesHeaderId:{"default":!1,describe:"Add an id to table he' +
'aders",type:"boolean"},ghCodeBlocks:{"default":!0,describe:"Turn on/off GFM fenc' +
'ed code blocks support",type:"boolean"},tasklists:{"default":!1,describe:"Turn o' +
'n/off GFM tasklist support",type:"boolean"},smoothLivePreview:{"default":!1,desc' +
'ribe:"Prevents weird effects in live previews due to incomplete input",type:"boo' +
'lean"},smartIndentationFix:{"default":!1,description:"Tries to smartly fix ident' +
'ation in es6 strings",type:"boolean"}};if(e===!1)return JSON.parse(JSON.stringif' +
'y(r));var t={};for(var n in r)r.hasOwnProperty(n)&&(t[n]=r[n]["default"]);return' +
' t}function r(e,r){"use strict";var t=r?"Error in "+r+" extension->":"Error in u' +
'nnamed extension",s={valid:!0,error:""};n.helper.isArray(e)||(e=[e]);for(var a=0' +
';a<e.length;++a){var i=t+" sub-extension "+a+": ",o=e[a];if("object"!=typeof o)r' +
'eturn s.valid=!1,s.error=i+"must be an object, but "+typeof o+" given",s;if(!n.h' +
'elper.isString(o.type))return s.valid=!1,s.error=i+''property "type" must be a st' +
'ring, but ''+typeof o.type+" given",s;var c=o.type=o.type.toLowerCase();if("langu' +
'age"===c&&(c=o.type="lang"),"html"===c&&(c=o.type="output"),"lang"!==c&&"output"' +
'!==c&&"listener"!==c)return s.valid=!1,s.error=i+"type "+c+'' is not recognized. ' +
'Valid values: "lang/language", "output/html" or "listener"'',s;if("listener"===c)' +
'{if(n.helper.isUndefined(o.listeners))return s.valid=!1,s.error=i+''. Extensions ' +
'of type "listener" must have a property called "listeners"'',s}else if(n.helper.i' +
'sUndefined(o.filter)&&n.helper.isUndefined(o.regex))return s.valid=!1,s.error=i+' +
'c+'' extensions must define either a "regex" property or a "filter" method'',s;if(' +
'o.listeners){if("object"!=typeof o.listeners)return s.valid=!1,s.error=i+''"liste' +
'ners" property must be an object but ''+typeof o.listeners+" given",s;for(var u i' +
'n o.listeners)if(o.listeners.hasOwnProperty(u)&&"function"!=typeof o.listeners[u' +
'])return s.valid=!1,s.error=i+''"listeners" property must be an hash of [event na' +
'me]: [callback]. listeners.''+u+" must be a function but "+typeof o.listeners[u]+' +
'" given",s}if(o.filter){if("function"!=typeof o.filter)return s.valid=!1,s.error' +
'=i+''"filter" must be a function, but ''+typeof o.filter+" given",s}else if(o.rege' +
'x){if(n.helper.isString(o.regex)&&(o.regex=new RegExp(o.regex,"g")),!o.regex ins' +
'tanceof RegExp)return s.valid=!1,s.error=i+''"regex" property must either be a st' +
'ring or a RegExp object, but ''+typeof o.regex+" given",s;if(n.helper.isUndefined' +
'(o.replace))return s.valid=!1,s.error=i+''"regex" extensions must implement a rep' +
'lace string or function'',s}}return s}function t(e,r){"use strict";var t=r.charCo' +
'deAt(0);return"~E"+t+"E"}var n={},s={},a={},i=e(!0),o={github:{omitExtraWLInCode' +
'Blocks:!0,prefixHeaderId:"user-content-",simplifiedAutoLink:!0,literalMidWordUnd' +
'erscores:!0,strikethrough:!0,tables:!0,tablesHeaderId:!0,ghCodeBlocks:!0,tasklis' +
'ts:!0},vanilla:e(!0)};n.helper={},n.extensions={},n.setOption=function(e,r){"use' +
' strict";return i[e]=r,this},n.getOption=function(e){"use strict";return i[e]},n' +
'.getOptions=function(){"use strict";return i},n.resetOptions=function(){"use str' +
'ict";i=e(!0)},n.setFlavor=function(e){"use strict";if(o.hasOwnProperty(e)){var r' +
'=o[e];for(var t in r)r.hasOwnProperty(t)&&(i[t]=r[t])}},n.getDefaultOptions=func' +
'tion(r){"use strict";return e(r)},n.subParser=function(e,r){"use strict";if(n.he' +
'lper.isString(e)){if("undefined"==typeof r){if(s.hasOwnProperty(e))return s[e];t' +
'hrow Error("SubParser named "+e+" not registered!")}s[e]=r}},n.extension=functio' +
'n(e,t){"use strict";if(!n.helper.isString(e))throw Error("Extension ''name'' must ' +
'be a string");if(e=n.helper.stdExtName(e),n.helper.isUndefined(t)){if(!a.hasOwnP' +
'roperty(e))throw Error("Extension named "+e+" is not registered!");return a[e]}"' +
'function"==typeof t&&(t=t()),n.helper.isArray(t)||(t=[t]);var s=r(t,e);if(!s.val' +
'id)throw Error(s.error);a[e]=t},n.getAllExtensions=function(){"use strict";retur' +
'n a},n.removeExtension=function(e){"use strict";delete a[e]},n.resetExtensions=f' +
'unction(){"use strict";a={}},n.validateExtension=function(e){"use strict";var t=' +
'r(e,null);return t.valid?!0:(console.warn(t.error),!1)},n.hasOwnProperty("helper' +
'")||(n.helper={}),n.helper.isString=function(e){"use strict";return"string"==typ' +
'eof e||e instanceof String},n.helper.isFunction=function(e){"use strict";var r={' +
'};return e&&"[object Function]"===r.toString.call(e)},n.helper.forEach=function(' +
'e,r){"use strict";if("function"==typeof e.forEach)e.forEach(r);else for(var t=0;' +
't<e.length;t++)r(e[t],t,e)},n.helper.isArray=function(e){"use strict";return e.c' +
'onstructor===Array},n.helper.isUndefined=function(e){"use strict";return"undefin' +
'ed"==typeof e},n.helper.stdExtName=function(e){"use strict";return e.replace(/[_' +
'-]||\s/g,"").toLowerCase()},n.helper.escapeCharactersCallback=t,n.helper.escapeC' +
'haracters=function(e,r,n){"use strict";var s="(["+r.replace(/([\[\]\\])/g,"\\$1"' +
')+"])";n&&(s="\\\\"+s);var a=new RegExp(s,"g");return e=e.replace(a,t)};var c=fu' +
'nction(e,r,t,n){"use strict";var s,a,i,o,c,u=n||"",l=u.indexOf("g")>-1,p=new Reg' +
'Exp(r+"|"+t,"g"+u.replace(/g/g,"")),h=new RegExp(r,u.replace(/g/g,"")),d=[];do f' +
'or(s=0;i=p.exec(e);)if(h.test(i[0]))s++||(a=p.lastIndex,o=a-i[0].length);else if' +
'(s&&!--s){c=i.index+i[0].length;var f={left:{start:o,end:a},match:{start:a,end:i' +
'.index},right:{start:i.index,end:c},wholeMatch:{start:o,end:c}};if(d.push(f),!l)' +
'return d}while(s&&(p.lastIndex=a));return d};n.helper.matchRecursiveRegExp=funct' +
'ion(e,r,t,n){"use strict";for(var s=c(e,r,t,n),a=[],i=0;i<s.length;++i)a.push([e' +
'.slice(s[i].wholeMatch.start,s[i].wholeMatch.end),e.slice(s[i].match.start,s[i].' +
'match.end),e.slice(s[i].left.start,s[i].left.end),e.slice(s[i].right.start,s[i].' +
'right.end)]);return a},n.helper.replaceRecursiveRegExp=function(e,r,t,s,a){"use ' +
'strict";if(!n.helper.isFunction(r)){var i=r;r=function(){return i}}var o=c(e,t,s' +
',a),u=e,l=o.length;if(l>0){var p=[];0!==o[0].wholeMatch.start&&p.push(e.slice(0,' +
'o[0].wholeMatch.start));for(var h=0;l>h;++h)p.push(r(e.slice(o[h].wholeMatch.sta' +
'rt,o[h].wholeMatch.end),e.slice(o[h].match.start,o[h].match.end),e.slice(o[h].le' +
'ft.start,o[h].left.end),e.slice(o[h].right.start,o[h].right.end))),l-1>h&&p.push' +
'(e.slice(o[h].wholeMatch.end,o[h+1].wholeMatch.start));o[l-1].wholeMatch.end<e.l' +
'ength&&p.push(e.slice(o[l-1].wholeMatch.end)),u=p.join("")}return u},n.helper.is' +
'Undefined(console)&&(console={warn:function(e){"use strict";alert(e)},log:functi' +
'on(e){"use strict";alert(e)},error:function(e){"use strict";throw e}}),n.Convert' +
'er=function(e){"use strict";function t(){e=e||{};for(var r in i)i.hasOwnProperty' +
'(r)&&(p[r]=i[r]);if("object"!=typeof e)throw Error("Converter expects the passed' +
' parameter to be an object, but "+typeof e+" was passed instead.");for(var t in ' +
'e)e.hasOwnProperty(t)&&(p[t]=e[t]);p.extensions&&n.helper.forEach(p.extensions,s' +
')}function s(e,t){if(t=t||null,n.helper.isString(e)){if(e=n.helper.stdExtName(e)' +
',t=e,n.extensions[e])return console.warn("DEPRECATION WARNING: "+e+" is an old e' +
'xtension that uses a deprecated loading method.Please inform the developer that ' +
'the extension should be updated!"),void c(n.extensions[e],e);if(n.helper.isUndef' +
'ined(a[e]))throw Error(''Extension "''+e+''" could not be loaded. It was either not' +
' found or is not a valid extension.'');e=a[e]}"function"==typeof e&&(e=e()),n.hel' +
'per.isArray(e)||(e=[e]);var s=r(e,t);if(!s.valid)throw Error(s.error);for(var i=' +
'0;i<e.length;++i){switch(e[i].type){case"lang":h.push(e[i]);break;case"output":d' +
'.push(e[i])}if(e[i].hasOwnProperty(f))for(var o in e[i].listeners)e[i].listeners' +
'.hasOwnProperty(o)&&u(o,e[i].listeners[o])}}function c(e,t){"function"==typeof e' +
'&&(e=e(new n.Converter)),n.helper.isArray(e)||(e=[e]);var s=r(e,t);if(!s.valid)t' +
'hrow Error(s.error);for(var a=0;a<e.length;++a)switch(e[a].type){case"lang":h.pu' +
'sh(e[a]);break;case"output":d.push(e[a]);break;default:throw Error("Extension lo' +
'ader error: Type unrecognized!!!")}}function u(e,r){if(!n.helper.isString(e))thr' +
'ow Error("Invalid argument in converter.listen() method: name must be a string, ' +
'but "+typeof e+" given");if("function"!=typeof r)throw Error("Invalid argument i' +
'n converter.listen() method: callback must be a function, but "+typeof r+" given' +
'");f.hasOwnProperty(e)||(f[e]=[]),f[e].push(r)}function l(e){var r=e.match(/^\s*' +
'/)[0].length,t=new RegExp("^\\s{0,"+r+"}","gm");return e.replace(t,"")}var p={},' +
'h=[],d=[],f={};t(),this._dispatch=function(e,r,t,n){if(f.hasOwnProperty(e))for(v' +
'ar s=0;s<f[e].length;++s){var a=f[e][s](e,r,this,t,n);a&&"undefined"!=typeof a&&' +
'(r=a)}return r},this.listen=function(e,r){return u(e,r),this},this.makeHtml=func' +
'tion(e){if(!e)return e;var r={gHtmlBlocks:[],gHtmlMdBlocks:[],gHtmlSpans:[],gUrl' +
's:{},gTitles:{},gDimensions:{},gListLevel:0,hashLinkCounts:{},langExtensions:h,o' +
'utputModifiers:d,converter:this,ghCodeBlocks:[]};return e=e.replace(/~/g,"~T"),e' +
'=e.replace(/\$/g,"~D"),e=e.replace(/\r\n/g,"\n"),e=e.replace(/\r/g,"\n"),p.smart' +
'IndentationFix&&(e=l(e)),e="\n\n"+e+"\n\n",e=n.subParser("detab")(e,p,r),e=n.sub' +
'Parser("stripBlankLines")(e,p,r),n.helper.forEach(h,function(t){e=n.subParser("r' +
'unExtension")(t,e,p,r)}),e=n.subParser("hashPreCodeTags")(e,p,r),e=n.subParser("' +
'githubCodeBlocks")(e,p,r),e=n.subParser("hashHTMLBlocks")(e,p,r),e=n.subParser("' +
'hashHTMLSpans")(e,p,r),e=n.subParser("stripLinkDefinitions")(e,p,r),e=n.subParse' +
'r("blockGamut")(e,p,r),e=n.subParser("unhashHTMLSpans")(e,p,r),e=n.subParser("un' +
'escapeSpecialChars")(e,p,r),e=e.replace(/~D/g,"$$"),e=e.replace(/~T/g,"~"),n.hel' +
'per.forEach(d,function(t){e=n.subParser("runExtension")(t,e,p,r)}),e},this.setOp' +
'tion=function(e,r){p[e]=r},this.getOption=function(e){return p[e]},this.getOptio' +
'ns=function(){return p},this.addExtension=function(e,r){r=r||null,s(e,r)},this.u' +
'seExtension=function(e){s(e)},this.setFlavor=function(e){if(o.hasOwnProperty(e))' +
'{var r=o[e];for(var t in r)r.hasOwnProperty(t)&&(p[t]=r[t])}},this.removeExtensi' +
'on=function(e){n.helper.isArray(e)||(e=[e]);for(var r=0;r<e.length;++r){for(var ' +
't=e[r],s=0;s<h.length;++s)h[s]===t&&h[s].splice(s,1);for(var a=0;a<d.length;++s)' +
'd[a]===t&&d[a].splice(s,1)}},this.getAllExtensions=function(){return{language:h,' +
'output:d}}},n.subParser("anchors",function(e,r,t){"use strict";e=t.converter._di' +
'spatch("anchors.before",e,r,t);var s=function(e,r,s,a,i,o,c,u){n.helper.isUndefi' +
'ned(u)&&(u=""),e=r;var l=s,p=a.toLowerCase(),h=i,d=u;if(!h)if(p||(p=l.toLowerCas' +
'e().replace(/ ?\n/g," ")),h="#"+p,n.helper.isUndefined(t.gUrls[p])){if(!(e.searc' +
'h(/\(\s*\)$/m)>-1))return e;h=""}else h=t.gUrls[p],n.helper.isUndefined(t.gTitle' +
's[p])||(d=t.gTitles[p]);h=n.helper.escapeCharacters(h,"*_",!1);var f=''<a href="''' +
'+h+''"'';return""!==d&&null!==d&&(d=d.replace(/"/g,"&quot;"),d=n.helper.escapeChar' +
'acters(d,"*_",!1),f+='' title="''+d+''"''),f+=">"+l+"</a>"};return e=e.replace(/(\[(' +
'(?:\[[^\]]*]|[^\[\]])*)][ ]?(?:\n[ ]*)?\[(.*?)])()()()()/g,s),e=e.replace(/(\[((' +
'?:\[[^\]]*]|[^\[\]])*)]\([ \t]*()<?(.*?(?:\(.*?\).*?)?)>?[ \t]*(([''"])(.*?)\6[ \' +
't]*)?\))/g,s),e=e.replace(/(\[([^\[\]]+)])()()()()()/g,s),e=t.converter._dispatc' +
'h("anchors.after",e,r,t)}),n.subParser("autoLinks",function(e,r,t){"use strict";' +
'function s(e,r){var t=n.subParser("unescapeSpecialChars")(r);return n.subParser(' +
'"encodeEmailAddress")(t)}e=t.converter._dispatch("autoLinks.before",e,r,t);var a' +
'=/\b(((https?|ftp|dict):\/\/|www\.)[^''">\s]+\.[^''">\s]+)(?=\s|$)(?!["<>])/gi,i=/' +
'<(((https?|ftp|dict):\/\/|www\.)[^''">\s]+)>/gi,o=/(?:^|[ \n\t])([A-Za-z0-9!#$%&''' +
'*+-\/=?^_`\{|}~\.]+@[-a-z0-9]+(\.[-a-z0-9]+)*\.[a-z]+)(?:$|[ \n\t])/gi,c=/<(?:ma' +
'ilto:)?([-.\w]+@[-a-z0-9]+(\.[-a-z0-9]+)*\.[a-z]+)>/gi;return e=e.replace(i,''<a ' +
'href="$1">$1</a>''),e=e.replace(c,s),r.simplifiedAutoLink&&(e=e.replace(a,''<a hre' +
'f="$1">$1</a>''),e=e.replace(o,s)),e=t.converter._dispatch("autoLinks.after",e,r,' +
't)}),n.subParser("blockGamut",function(e,r,t){"use strict";e=t.converter._dispat' +
'ch("blockGamut.before",e,r,t),e=n.subParser("blockQuotes")(e,r,t),e=n.subParser(' +
'"headers")(e,r,t);var s=n.subParser("hashBlock")("<hr />",r,t);return e=e.replac' +
'e(/^[ ]{0,2}([ ]?\*[ ]?){3,}[ \t]*$/gm,s),e=e.replace(/^[ ]{0,2}([ ]?\-[ ]?){3,}' +
'[ \t]*$/gm,s),e=e.replace(/^[ ]{0,2}([ ]?_[ ]?){3,}[ \t]*$/gm,s),e=n.subParser("' +
'lists")(e,r,t),e=n.subParser("codeBlocks")(e,r,t),e=n.subParser("tables")(e,r,t)' +
',e=n.subParser("hashHTMLBlocks")(e,r,t),e=n.subParser("paragraphs")(e,r,t),e=t.c' +
'onverter._dispatch("blockGamut.after",e,r,t)}),n.subParser("blockQuotes",functio' +
'n(e,r,t){"use strict";return e=t.converter._dispatch("blockQuotes.before",e,r,t)' +
',e=e.replace(/((^[ \t]{0,3}>[ \t]?.+\n(.+\n)*\n*)+)/gm,function(e,s){var a=s;ret' +
'urn a=a.replace(/^[ \t]*>[ \t]?/gm,"~0"),a=a.replace(/~0/g,""),a=a.replace(/^[ \' +
't]+$/gm,""),a=n.subParser("githubCodeBlocks")(a,r,t),a=n.subParser("blockGamut")' +
'(a,r,t),a=a.replace(/(^|\n)/g,"$1  "),a=a.replace(/(\s*<pre>[^\r]+?<\/pre>)/gm,f' +
'unction(e,r){var t=r;return t=t.replace(/^  /gm,"~0"),t=t.replace(/~0/g,"")}),n.' +
'subParser("hashBlock")("<blockquote>\n"+a+"\n</blockquote>",r,t)}),e=t.converter' +
'._dispatch("blockQuotes.after",e,r,t)}),n.subParser("codeBlocks",function(e,r,t)' +
'{"use strict";e=t.converter._dispatch("codeBlocks.before",e,r,t),e+="~0";var s=/' +
'(?:\n\n|^)((?:(?:[ ]{4}|\t).*\n+)+)(\n*[ ]{0,3}[^ \t\n]|(?=~0))/g;return e=e.rep' +
'lace(s,function(e,s,a){var i=s,o=a,c="\n";return i=n.subParser("outdent")(i),i=n' +
'.subParser("encodeCode")(i),i=n.subParser("detab")(i),i=i.replace(/^\n+/g,""),i=' +
'i.replace(/\n+$/g,""),r.omitExtraWLInCodeBlocks&&(c=""),i="<pre><code>"+i+c+"</c' +
'ode></pre>",n.subParser("hashBlock")(i,r,t)+o}),e=e.replace(/~0/,""),e=t.convert' +
'er._dispatch("codeBlocks.after",e,r,t)}),n.subParser("codeSpans",function(e,r,t)' +
'{"use strict";return e=t.converter._dispatch("codeSpans.before",e,r,t),"undefine' +
'd"==typeof e&&(e=""),e=e.replace(/(^|[^\\])(`+)([^\r]*?[^`])\2(?!`)/gm,function(' +
'e,r,t,s){var a=s;return a=a.replace(/^([ \t]*)/g,""),a=a.replace(/[ \t]*$/g,""),' +
'a=n.subParser("encodeCode")(a),r+"<code>"+a+"</code>"}),e=t.converter._dispatch(' +
'"codeSpans.after",e,r,t)}),n.subParser("detab",function(e){"use strict";return e' +
'=e.replace(/\t(?=\t)/g,"    "),e=e.replace(/\t/g,"~A~B"),e=e.replace(/~B(.+?)~A/' +
'g,function(e,r){for(var t=r,n=4-t.length%4,s=0;n>s;s++)t+=" ";return t}),e=e.rep' +
'lace(/~A/g,"    "),e=e.replace(/~B/g,"")}),n.subParser("encodeAmpsAndAngles",fun' +
'ction(e){"use strict";return e=e.replace(/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w+);)/g,"&' +
'amp;"),e=e.replace(/<(?![a-z\/?\$!])/gi,"&lt;")}),n.subParser("encodeBackslashEs' +
'capes",function(e){"use strict";return e=e.replace(/\\(\\)/g,n.helper.escapeChar' +
'actersCallback),e=e.replace(/\\([`*_{}\[\]()>#+-.!])/g,n.helper.escapeCharacters' +
'Callback)}),n.subParser("encodeCode",function(e){"use strict";return e=e.replace' +
'(/&/g,"&amp;"),e=e.replace(/</g,"&lt;"),e=e.replace(/>/g,"&gt;"),e=n.helper.esca' +
'peCharacters(e,"*_{}[]\\",!1)}),n.subParser("encodeEmailAddress",function(e){"us' +
'e strict";var r=[function(e){return"&#"+e.charCodeAt(0)+";"},function(e){return"' +
'&#x"+e.charCodeAt(0).toString(16)+";"},function(e){return e}];return e="mailto:"' +
'+e,e=e.replace(/./g,function(e){if("@"===e)e=r[Math.floor(2*Math.random())](e);e' +
'lse if(":"!==e){var t=Math.random();e=t>.9?r[2](e):t>.45?r[1](e):r[0](e)}return ' +
'e}),e=''<a href="''+e+''">''+e+"</a>",e=e.replace(/">.+:/g,''">'')}),n.subParser("esca' +
'peSpecialCharsWithinTagAttributes",function(e){"use strict";var r=/(<[a-z\/!$]("' +
'[^"]*"|''[^'']*''|[^''">])*>|<!(--.*?--\s*)+>)/gi;return e=e.replace(r,function(e){v' +
'ar r=e.replace(/(.)<\/?code>(?=.)/g,"$1`");return r=n.helper.escapeCharacters(r,' +
'"\\`*_",!1)})}),n.subParser("githubCodeBlocks",function(e,r,t){"use strict";retu' +
'rn r.ghCodeBlocks?(e=t.converter._dispatch("githubCodeBlocks.before",e,r,t),e+="' +
'~0",e=e.replace(/(?:^|\n)```(.*)\n([\s\S]*?)\n```/g,function(e,s,a){var i=r.omit' +
'ExtraWLInCodeBlocks?"":"\n";return a=n.subParser("encodeCode")(a),a=n.subParser(' +
'"detab")(a),a=a.replace(/^\n+/g,""),a=a.replace(/\n+$/g,""),a="<pre><code"+(s?'' ' +
'class="''+s+" language-"+s+''"'':"")+">"+a+i+"</code></pre>",a=n.subParser("hashBlo' +
'ck")(a,r,t),"\n\n~G"+(t.ghCodeBlocks.push({text:e,codeblock:a})-1)+"G\n\n"}),e=e' +
'.replace(/~0/,""),t.converter._dispatch("githubCodeBlocks.after",e,r,t)):e}),n.s' +
'ubParser("hashBlock",function(e,r,t){"use strict";return e=e.replace(/(^\n+|\n+$' +
')/g,""),"\n\n~K"+(t.gHtmlBlocks.push(e)-1)+"K\n\n"}),n.subParser("hashElement",f' +
'unction(e,r,t){"use strict";return function(e,r){var n=r;return n=n.replace(/\n\' +
'n/g,"\n"),n=n.replace(/^\n/,""),n=n.replace(/\n+$/g,""),n="\n\n~K"+(t.gHtmlBlock' +
's.push(n)-1)+"K\n\n"}}),n.subParser("hashHTMLBlocks",function(e,r,t){"use strict' +
'";for(var s=["pre","div","h1","h2","h3","h4","h5","h6","blockquote","table","dl"' +
',"ol","ul","script","noscript","form","fieldset","iframe","math","style","sectio' +
'n","header","footer","nav","article","aside","address","audio","canvas","figure"' +
',"hgroup","output","video","p"],a=function(e,r,n,s){var a=e;return-1!==n.search(' +
'/\bmarkdown\b/)&&(a=n+t.converter.makeHtml(r)+s),"\n\n~K"+(t.gHtmlBlocks.push(a)' +
'-1)+"K\n\n"},i=0;i<s.length;++i)e=n.helper.replaceRecursiveRegExp(e,a,"^(?: |\\t' +
'){0,3}<"+s[i]+"\\b[^>]*>","</"+s[i]+">","gim");return e=e.replace(/(\n[ ]{0,3}(<' +
'(hr)\b([^<>])*?\/?>)[ \t]*(?=\n{2,}))/g,n.subParser("hashElement")(e,r,t)),e=e.r' +
'eplace(/(<!(--[^\r]*?--\s*)+>[ \t]*(?=\n{2,}))/g,n.subParser("hashElement")(e,r,' +
't)),e=e.replace(/(?:\n\n)([ ]{0,3}(?:<([?%])[^\r]*?\2>)[ \t]*(?=\n{2,}))/g,n.sub' +
'Parser("hashElement")(e,r,t))}),n.subParser("hashHTMLSpans",function(e,r,t){"use' +
' strict";for(var s=n.helper.matchRecursiveRegExp(e,"<code\\b[^>]*>","</code>","g' +
'i"),a=0;a<s.length;++a)e=e.replace(s[a][0],"~L"+(t.gHtmlSpans.push(s[a][0])-1)+"' +
'L");return e}),n.subParser("unhashHTMLSpans",function(e,r,t){"use strict";for(va' +
'r n=0;n<t.gHtmlSpans.length;++n)e=e.replace("~L"+n+"L",t.gHtmlSpans[n]);return e' +
'}),n.subParser("hashPreCodeTags",function(e,r,t){"use strict";var s=function(e,r' +
',s,a){var i=s+n.subParser("encodeCode")(r)+a;return"\n\n~G"+(t.ghCodeBlocks.push' +
'({text:e,codeblock:i})-1)+"G\n\n"};return e=n.helper.replaceRecursiveRegExp(e,s,' +
'"^(?: |\\t){0,3}<pre\\b[^>]*>\\s*<code\\b[^>]*>","^(?: |\\t){0,3}</code>\\s*</pr' +
'e>","gim")}),n.subParser("headers",function(e,r,t){"use strict";function s(e){va' +
'r r,s=e.replace(/[^\w]/g,"").toLowerCase();return t.hashLinkCounts[s]?r=s+"-"+t.' +
'hashLinkCounts[s]++:(r=s,t.hashLinkCounts[s]=1),a===!0&&(a="section"),n.helper.i' +
'sString(a)?a+r:r}e=t.converter._dispatch("headers.before",e,r,t);var a=r.prefixH' +
'eaderId,i=isNaN(parseInt(r.headerLevelStart))?1:parseInt(r.headerLevelStart),o=r' +
'.smoothLivePreview?/^(.+)[ \t]*\n={2,}[ \t]*\n+/gm:/^(.+)[ \t]*\n=+[ \t]*\n+/gm,' +
'c=r.smoothLivePreview?/^(.+)[ \t]*\n-{2,}[ \t]*\n+/gm:/^(.+)[ \t]*\n-+[ \t]*\n+/' +
'gm;return e=e.replace(o,function(e,a){var o=n.subParser("spanGamut")(a,r,t),c=r.' +
'noHeaderId?"":'' id="''+s(a)+''"'',u=i,l="<h"+u+c+">"+o+"</h"+u+">";return n.subPars' +
'er("hashBlock")(l,r,t)}),e=e.replace(c,function(e,a){var o=n.subParser("spanGamu' +
't")(a,r,t),c=r.noHeaderId?"":'' id="''+s(a)+''"'',u=i+1,l="<h"+u+c+">"+o+"</h"+u+">"' +
';return n.subParser("hashBlock")(l,r,t)}),e=e.replace(/^(#{1,6})[ \t]*(.+?)[ \t]' +
'*#*\n+/gm,function(e,a,o){var c=n.subParser("spanGamut")(o,r,t),u=r.noHeaderId?"' +
'":'' id="''+s(o)+''"'',l=i-1+a.length,p="<h"+l+u+">"+c+"</h"+l+">";return n.subParse' +
'r("hashBlock")(p,r,t)}),e=t.converter._dispatch("headers.after",e,r,t)}),n.subPa' +
'rser("images",function(e,r,t){"use strict";function s(e,r,s,a,i,o,c,u){var l=t.g' +
'Urls,p=t.gTitles,h=t.gDimensions;if(s=s.toLowerCase(),u||(u=""),""===a||null===a' +
'){if((""===s||null===s)&&(s=r.toLowerCase().replace(/ ?\n/g," ")),a="#"+s,n.help' +
'er.isUndefined(l[s]))return e;a=l[s],n.helper.isUndefined(p[s])||(u=p[s]),n.help' +
'er.isUndefined(h[s])||(i=h[s].width,o=h[s].height)}r=r.replace(/"/g,"&quot;"),r=' +
'n.helper.escapeCharacters(r,"*_",!1),a=n.helper.escapeCharacters(a,"*_",!1);var ' +
'd=''<img src="''+a+''" alt="''+r+''"'';return u&&(u=u.replace(/"/g,"&quot;"),u=n.helpe' +
'r.escapeCharacters(u,"*_",!1),d+='' title="''+u+''"''),i&&o&&(i="*"===i?"auto":i,o="' +
'*"===o?"auto":o,d+='' width="''+i+''"'',d+='' height="''+o+''"''),d+=" />"}e=t.converter' +
'._dispatch("images.before",e,r,t);var a=/!\[(.*?)]\s?\([ \t]*()<?(\S+?)>?(?: =([' +
'*\d]+[A-Za-z%]{0,4})x([*\d]+[A-Za-z%]{0,4}))?[ \t]*(?:([''"])(.*?)\6[ \t]*)?\)/g,' +
'i=/!\[([^\]]*?)] ?(?:\n *)?\[(.*?)]()()()()()/g;return e=e.replace(i,s),e=e.repl' +
'ace(a,s),e=t.converter._dispatch("images.after",e,r,t)}),n.subParser("italicsAnd' +
'Bold",function(e,r,t){"use strict";return e=t.converter._dispatch("italicsAndBol' +
'd.before",e,r,t),r.literalMidWordUnderscores?(e=e.replace(/(^|\s|>|\b)__(?=\S)([' +
'^]+?)__(?=\b|<|\s|$)/gm,"$1<strong>$2</strong>"),e=e.replace(/(^|\s|>|\b)_(?=\S)' +
'([^]+?)_(?=\b|<|\s|$)/gm,"$1<em>$2</em>"),e=e.replace(/(\*\*)(?=\S)([^\r]*?\S[*]' +
'*)\1/g,"<strong>$2</strong>"),e=e.replace(/(\*)(?=\S)([^\r]*?\S)\1/g,"<em>$2</em' +
'>")):(e=e.replace(/(\*\*|__)(?=\S)([^\r]*?\S[*_]*)\1/g,"<strong>$2</strong>"),e=' +
'e.replace(/(\*|_)(?=\S)([^\r]*?\S)\1/g,"<em>$2</em>")),e=t.converter._dispatch("' +
'italicsAndBold.after",e,r,t)}),n.subParser("lists",function(e,r,t){"use strict";' +
'function s(e,s){t.gListLevel++,e=e.replace(/\n{2,}$/,"\n"),e+="~0";var a=/(\n)?(' +
'^[ \t]*)([*+-]|\d+[.])[ \t]+((\[(x|X| )?])?[ \t]*[^\r]+?(\n{1,2}))(?=\n*(~0|\2([' +
'*+-]|\d+[.])[ \t]+))/gm,i=/\n[ \t]*\n(?!~0)/.test(e);return e=e.replace(a,functi' +
'on(e,s,a,o,c,u,l){l=l&&""!==l.trim();var p=n.subParser("outdent")(c,r,t),h="";re' +
'turn u&&r.tasklists&&(h='' class="task-list-item" style="list-style-type: none;"''' +
',p=p.replace(/^[ \t]*\[(x|X| )?]/m,function(){var e=''<input type="checkbox" disa' +
'bled style="margin: 0px 0.35em 0.25em -1.6em; vertical-align: middle;"'';return l' +
'&&(e+=" checked"),e+=">"})),s||p.search(/\n{2,}/)>-1?(p=n.subParser("githubCodeB' +
'locks")(p,r,t),p=n.subParser("blockGamut")(p,r,t)):(p=n.subParser("lists")(p,r,t' +
'),p=p.replace(/\n$/,""),p=i?n.subParser("paragraphs")(p,r,t):n.subParser("spanGa' +
'mut")(p,r,t)),p="\n<li"+h+">"+p+"</li>\n"}),e=e.replace(/~0/g,""),t.gListLevel--' +
',s&&(e=e.replace(/\s+$/,"")),e}function a(e,r,t){var n="ul"===r?/^ {0,2}\d+\.[ \' +
't]/gm:/^ {0,2}[*+-][ \t]/gm,a=[],i="";if(-1!==e.search(n)){!function c(e){var a=' +
'e.search(n);-1!==a?(i+="\n\n<"+r+">"+s(e.slice(0,a),!!t)+"</"+r+">\n\n",r="ul"==' +
'=r?"ol":"ul",n="ul"===r?/^ {0,2}\d+\.[ \t]/gm:/^ {0,2}[*+-][ \t]/gm,c(e.slice(a)' +
')):i+="\n\n<"+r+">"+s(e,!!t)+"</"+r+">\n\n"}(e);for(var o=0;o<a.length;++o);}els' +
'e i="\n\n<"+r+">"+s(e,!!t)+"</"+r+">\n\n";return i}e=t.converter._dispatch("list' +
's.before",e,r,t),e+="~0";var i=/^(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(~0|\n{2,' +
'}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/gm;return t.gListLevel?e=e.replace(i,f' +
'unction(e,r,t){var n=t.search(/[*+-]/g)>-1?"ul":"ol";return a(r,n,!0)}):(i=/(\n\' +
'n|^\n?)(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(~0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\' +
'd+[.])[ \t]+)))/gm,e=e.replace(i,function(e,r,t,n){var s=n.search(/[*+-]/g)>-1?"' +
'ul":"ol";return a(t,s)})),e=e.replace(/~0/,""),e=t.converter._dispatch("lists.af' +
'ter",e,r,t)}),n.subParser("outdent",function(e){"use strict";return e=e.replace(' +
'/^(\t|[ ]{1,4})/gm,"~0"),e=e.replace(/~0/g,"")}),n.subParser("paragraphs",functi' +
'on(e,r,t){"use strict";e=t.converter._dispatch("paragraphs.before",e,r,t),e=e.re' +
'place(/^\n+/g,""),e=e.replace(/\n+$/g,"");for(var s=e.split(/\n{2,}/g),a=[],i=s.' +
'length,o=0;i>o;o++){var c=s[o];c.search(/~(K|G)(\d+)\1/g)>=0?a.push(c):(c=n.subP' +
'arser("spanGamut")(c,r,t),c=c.replace(/^([ \t]*)/g,"<p>"),c+="</p>",a.push(c))}f' +
'or(i=a.length,o=0;i>o;o++){for(var u="",l=a[o],p=!1;l.search(/~(K|G)(\d+)\1/)>=0' +
';){var h=RegExp.$1,d=RegExp.$2;u="K"===h?t.gHtmlBlocks[d]:p?n.subParser("encodeC' +
'ode")(t.ghCodeBlocks[d].text):t.ghCodeBlocks[d].codeblock,u=u.replace(/\$/g,"$$$' +
'$"),l=l.replace(/(\n\n)?~(K|G)\d+\2(\n\n)?/,u),/^<pre\b[^>]*>\s*<code\b[^>]*>/.t' +
'est(l)&&(p=!0)}a[o]=l}return e=a.join("\n\n"),e=e.replace(/^\n+/g,""),e=e.replac' +
'e(/\n+$/g,""),t.converter._dispatch("paragraphs.after",e,r,t)}),n.subParser("run' +
'Extension",function(e,r,t,n){"use strict";if(e.filter)r=e.filter(r,n.converter,t' +
');else if(e.regex){var s=e.regex;!s instanceof RegExp&&(s=new RegExp(s,"g")),r=r' +
'.replace(s,e.replace)}return r}),n.subParser("spanGamut",function(e,r,t){"use st' +
'rict";return e=t.converter._dispatch("spanGamut.before",e,r,t),e=n.subParser("co' +
'deSpans")(e,r,t),e=n.subParser("escapeSpecialCharsWithinTagAttributes")(e,r,t),e' +
'=n.subParser("encodeBackslashEscapes")(e,r,t),e=n.subParser("images")(e,r,t),e=n' +
'.subParser("anchors")(e,r,t),e=n.subParser("autoLinks")(e,r,t),e=n.subParser("en' +
'codeAmpsAndAngles")(e,r,t),e=n.subParser("italicsAndBold")(e,r,t),e=n.subParser(' +
'"strikethrough")(e,r,t),e=e.replace(/  +\n/g," <br />\n"),e=t.converter._dispatc' +
'h("spanGamut.after",e,r,t)}),n.subParser("strikethrough",function(e,r,t){"use st' +
'rict";return r.strikethrough&&(e=t.converter._dispatch("strikethrough.before",e,' +
'r,t),e=e.replace(/(?:~T){2}([\s\S]+?)(?:~T){2}/g,"<del>$1</del>"),e=t.converter.' +
'_dispatch("strikethrough.after",e,r,t)),e}),n.subParser("stripBlankLines",functi' +
'on(e){"use strict";return e.replace(/^[ \t]+$/gm,"")}),n.subParser("stripLinkDef' +
'initions",function(e,r,t){"use strict";var s=/^ {0,3}\[(.+)]:[ \t]*\n?[ \t]*<?(\' +
'S+?)>?(?: =([*\d]+[A-Za-z%]{0,4})x([*\d]+[A-Za-z%]{0,4}))?[ \t]*\n?[ \t]*(?:(\n*' +
')["|''(](.+?)["|'')][ \t]*)?(?:\n+|(?=~0))/gm;return e+="~0",e=e.replace(s,functio' +
'n(e,s,a,i,o,c,u){return s=s.toLowerCase(),t.gUrls[s]=n.subParser("encodeAmpsAndA' +
'ngles")(a),c?c+u:(u&&(t.gTitles[s]=u.replace(/"|''/g,"&quot;")),r.parseImgDimensi' +
'ons&&i&&o&&(t.gDimensions[s]={width:i,height:o}),"")}),e=e.replace(/~0/,"")}),n.' +
'subParser("tables",function(e,r,t){"use strict";function s(e){return/^:[ \t]*--*' +
'$/.test(e)?'' style="text-align:left;"'':/^--*[ \t]*:[ \t]*$/.test(e)?'' style="tex' +
't-align:right;"'':/^:[ \t]*--*[ \t]*:$/.test(e)?'' style="text-align:center;"'':""}' +
'function a(e,s){var a="";return e=e.trim(),r.tableHeaderId&&(a='' id="''+e.replace' +
'(/ /g,"_").toLowerCase()+''"''),e=n.subParser("spanGamut")(e,r,t),"<th"+a+s+">"+e+' +
'"</th>\n"}function i(e,s){var a=n.subParser("spanGamut")(e,r,t);return"<td"+s+">' +
'"+a+"</td>\n"}function o(e,r){for(var t="<table>\n<thead>\n<tr>\n",n=e.length,s=' +
'0;n>s;++s)t+=e[s];for(t+="</tr>\n</thead>\n<tbody>\n",s=0;s<r.length;++s){t+="<t' +
'r>\n";for(var a=0;n>a;++a)t+=r[s][a];t+="</tr>\n"}return t+="</tbody>\n</table>\' +
'n"}if(!r.tables)return e;var c=/^[ \t]{0,3}\|?.+\|.+\n[ \t]{0,3}\|?[ \t]*:?[ \t]' +
'*(?:-|=){2,}[ \t]*:?[ \t]*\|[ \t]*:?[ \t]*(?:-|=){2,}[^]+?(?:\n\n|~0)/gm;return ' +
'e=t.converter._dispatch("tables.before",e,r,t),e=e.replace(c,function(e){var r,t' +
'=e.split("\n");for(r=0;r<t.length;++r)/^[ \t]{0,3}\|/.test(t[r])&&(t[r]=t[r].rep' +
'lace(/^[ \t]{0,3}\|/,"")),/\|[ \t]*$/.test(t[r])&&(t[r]=t[r].replace(/\|[ \t]*$/' +
',""));var c=t[0].split("|").map(function(e){return e.trim()}),u=t[1].split("|").' +
'map(function(e){return e.trim()}),l=[],p=[],h=[],d=[];for(t.shift(),t.shift(),r=' +
'0;r<t.length;++r)""!==t[r].trim()&&l.push(t[r].split("|").map(function(e){return' +
' e.trim()}));if(c.length<u.length)return e;for(r=0;r<u.length;++r)h.push(s(u[r])' +
');for(r=0;r<c.length;++r)n.helper.isUndefined(h[r])&&(h[r]=""),p.push(a(c[r],h[r' +
']));for(r=0;r<l.length;++r){for(var f=[],g=0;g<p.length;++g)n.helper.isUndefined' +
'(l[r][g]),f.push(i(l[r][g],h[g]));d.push(f)}return o(p,d)}),e=t.converter._dispa' +
'tch("tables.after",e,r,t)}),n.subParser("unescapeSpecialChars",function(e){"use ' +
'strict";return e=e.replace(/~E(\d+)E/g,function(e,r){var t=parseInt(r);return St' +
'ring.fromCharCode(t)})});var u=this;"undefined"!=typeof module&&module.exports?m' +
'odule.exports=n:"function"==typeof define&&define.amd?define(function(){"use str' +
'ict";return n}):u.showdown=n}).call(this); '
+#13'	</script>        '
+#13'	'
+#13'	 <script type="text/javascript">'
+#13'            '
+#13'		var converter = new showdown.Converter();'
+#13'		function update(){'
+#13'			var res = converter.makeHtml(document.getElementById("wmd-input").value);'
+#13'			document.getElementById(''resultado'').innerHTML = res;	'
+#13'		}'
+#13'            update();'
+#13'        </script>';

//MarkdownIt 7.0.0 https://github.com/markdown-it/markdown-it usefull more options
MARKDOWNIT = '<script type="text/javascript">'
+#13'!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.expo' +
'rts=e();else if("function"==typeof define&&define.amd)define([],e);else{var r;r=' +
'"undefined"!=typeof window?window:"undefined"!=typeof global?global:"undefined"!' +
'=typeof self?self:this,r.markdownit=e()}}(function(){var e;return function r(e,t' +
',n){function s(i,a){if(!t[i]){if(!e[i]){var c="function"==typeof require&&requir' +
'e;if(!a&&c)return c(i,!0);if(o)return o(i,!0);var l=new Error("Cannot find modul' +
'e ''"+i+"''");throw l.code="MODULE_NOT_FOUND",l}var u=t[i]={exports:{}};e[i][0].ca' +
'll(u.exports,function(r){var t=e[i][1][r];return s(t?t:r)},u,u.exports,r,e,t,n)}' +
'return t[i].exports}for(var o="function"==typeof require&&require,i=0;i<n.length' +
';i++)s(n[i]);return s}({1:[function(e,r,t){"use strict";r.exports=e("entities/ma' +
'ps/entities.json")},{"entities/maps/entities.json":53}],2:[function(e,r,t){"use ' +
'strict";r.exports=["address","article","aside","base","basefont","blockquote","b' +
'ody","caption","center","col","colgroup","dd","details","dialog","dir","div","dl' +
'","dt","fieldset","figcaption","figure","footer","form","frame","frameset","h1",' +
'"head","header","hr","html","iframe","legend","li","link","main","menu","menuite' +
'm","meta","nav","noframes","ol","optgroup","option","p","param","pre","section",' +
'"source","title","summary","table","tbody","td","tfoot","th","thead","title","tr' +
'","track","ul"]},{}],3:[function(e,r,t){"use strict";var n="[a-zA-Z_:][a-zA-Z0-9' +
':._-]*",s="[^\"''=<>`\\x00-\\x20]+",o="''[^'']*''",i=''"[^"]*"'',a="(?:"+s+"|"+o+"|"+i' +
'+")",c="(?:\\s+"+n+"(?:\\s*=\\s*"+a+")?)",l="<[A-Za-z][A-Za-z0-9\\-]*"+c+"*\\s*\' +
'\/?>",u="<\\/[A-Za-z][A-Za-z0-9\\-]*\\s*>",p="<!---->|<!--(?:-?[^>-])(?:-?[^-])*' +
'-->",h="<[?].*?[?]>",f="<![A-Z]+\\s+[^>]*>",d="<!\\[CDATA\\[[\\s\\S]*?\\]\\]>",m' +
'=new RegExp("^(?:"+l+"|"+u+"|"+p+"|"+h+"|"+f+"|"+d+")"),_=new RegExp("^(?:"+l+"|' +
'"+u+")");r.exports.HTML_TAG_RE=m,r.exports.HTML_OPEN_CLOSE_TAG_RE=_},{}],4:[func' +
'tion(e,r,t){"use strict";function n(e){return Object.prototype.toString.call(e)}' +
'function s(e){return"[object String]"===n(e)}function o(e,r){return x.call(e,r)}' +
'function i(e){var r=Array.prototype.slice.call(arguments,1);return r.forEach(fun' +
'ction(r){if(r){if("object"!=typeof r)throw new TypeError(r+"must be object");Obj' +
'ect.keys(r).forEach(function(t){e[t]=r[t]})}}),e}function a(e,r,t){return[].conc' +
'at(e.slice(0,r),t,e.slice(r+1))}function c(e){return!(e>=55296&&e<=57343)&&(!(e>' +
'=64976&&e<=65007)&&(65535!==(65535&e)&&65534!==(65535&e)&&(!(e>=0&&e<=8)&&(11!==' +
'e&&(!(e>=14&&e<=31)&&(!(e>=127&&e<=159)&&!(e>1114111)))))))}function l(e){if(e>6' +
'5535){e-=65536;var r=55296+(e>>10),t=56320+(1023&e);return String.fromCharCode(r' +
',t)}return String.fromCharCode(e)}function u(e,r){var t=0;return o(D,r)?D[r]:35=' +
'==r.charCodeAt(0)&&w.test(r)&&(t="x"===r[1].toLowerCase()?parseInt(r.slice(2),16' +
'):parseInt(r.slice(1),10),c(t))?l(t):e}function p(e){return e.indexOf("\\")<0?e:' +
'e.replace(y,"$1")}function h(e){return e.indexOf("\\")<0&&e.indexOf("&")<0?e:e.r' +
'eplace(A,function(e,r,t){return r?r:u(e,t)})}function f(e){return S[e]}function ' +
'd(e){return q.test(e)?e.replace(E,f):e}function m(e){return e.replace(F,"\\$&")}' +
'function _(e){switch(e){case 9:case 32:return!0}return!1}function g(e){if(e>=819' +
'2&&e<=8202)return!0;switch(e){case 9:case 10:case 11:case 12:case 13:case 32:cas' +
'e 160:case 5760:case 8239:case 8287:case 12288:return!0}return!1}function k(e){r' +
'eturn z.test(e)}function b(e){switch(e){case 33:case 34:case 35:case 36:case 37:' +
'case 38:case 39:case 40:case 41:case 42:case 43:case 44:case 45:case 46:case 47:' +
'case 58:case 59:case 60:case 61:case 62:case 63:case 64:case 91:case 92:case 93:' +
'case 94:case 95:case 96:case 123:case 124:case 125:case 126:return!0;default:ret' +
'urn!1}}function v(e){return e.trim().replace(/\s+/g," ").toUpperCase()}var x=Obj' +
'ect.prototype.hasOwnProperty,y=/\\([!"#$%&''()*+,\-.\/:;<=>?@[\\\]^_`{|}~])/g,C=/' +
'&([a-z#][a-z0-9]{1,31});/gi,A=new RegExp(y.source+"|"+C.source,"gi"),w=/^#((?:x[' +
'a-f0-9]{1,8}|[0-9]{1,8}))/i,D=e("./entities"),q=/[&<>"]/,E=/[&<>"]/g,S={"&":"&am' +
'p;","<":"&lt;",">":"&gt;",''"'':"&quot;"},F=/[.?*+^$[\]\\(){}|-]/g,z=e("uc.micro/c' +
'ategories/P/regex");t.lib={},t.lib.mdurl=e("mdurl"),t.lib.ucmicro=e("uc.micro"),' +
't.assign=i,t.isString=s,t.has=o,t.unescapeMd=p,t.unescapeAll=h,t.isValidEntityCo' +
'de=c,t.fromCodePoint=l,t.escapeHtml=d,t.arrayReplaceAt=a,t.isSpace=_,t.isWhiteSp' +
'ace=g,t.isMdAsciiPunct=b,t.isPunctChar=k,t.escapeRE=m,t.normalizeReference=v},{"' +
'./entities":1,mdurl:59,"uc.micro":65,"uc.micro/categories/P/regex":63}],5:[funct' +
'ion(e,r,t){"use strict";t.parseLinkLabel=e("./parse_link_label"),t.parseLinkDest' +
'ination=e("./parse_link_destination"),t.parseLinkTitle=e("./parse_link_title")},' +
'{"./parse_link_destination":6,"./parse_link_label":7,"./parse_link_title":8}],6:' +
'[function(e,r,t){"use strict";var n=e("../common/utils").isSpace,s=e("../common/' +
'utils").unescapeAll;r.exports=function(e,r,t){var o,i,a=0,c=r,l={ok:!1,pos:0,lin' +
'es:0,str:""};if(60===e.charCodeAt(r)){for(r++;r<t;){if(o=e.charCodeAt(r),10===o|' +
'|n(o))return l;if(62===o)return l.pos=r+1,l.str=s(e.slice(c+1,r)),l.ok=!0,l;92==' +
'=o&&r+1<t?r+=2:r++}return l}for(i=0;r<t&&(o=e.charCodeAt(r),32!==o)&&!(o<32||127' +
'===o);)if(92===o&&r+1<t)r+=2;else{if(40===o&&(i++,i>1))break;if(41===o&&(i--,i<0' +
'))break;r++}return c===r?l:(l.str=s(e.slice(c,r)),l.lines=a,l.pos=r,l.ok=!0,l)}}' +
',{"../common/utils":4}],7:[function(e,r,t){"use strict";r.exports=function(e,r,t' +
'){var n,s,o,i,a=-1,c=e.posMax,l=e.pos;for(e.pos=r+1,n=1;e.pos<c;){if(o=e.src.cha' +
'rCodeAt(e.pos),93===o&&(n--,0===n)){s=!0;break}if(i=e.pos,e.md.inline.skipToken(' +
'e),91===o)if(i===e.pos-1)n++;else if(t)return e.pos=l,-1}return s&&(a=e.pos),e.p' +
'os=l,a}},{}],8:[function(e,r,t){"use strict";var n=e("../common/utils").unescape' +
'All;r.exports=function(e,r,t){var s,o,i=0,a=r,c={ok:!1,pos:0,lines:0,str:""};if(' +
'r>=t)return c;if(o=e.charCodeAt(r),34!==o&&39!==o&&40!==o)return c;for(r++,40===' +
'o&&(o=41);r<t;){if(s=e.charCodeAt(r),s===o)return c.pos=r+1,c.lines=i,c.str=n(e.' +
'slice(a+1,r)),c.ok=!0,c;10===s?i++:92===s&&r+1<t&&(r++,10===e.charCodeAt(r)&&i++' +
'),r++}return c}},{"../common/utils":4}],9:[function(e,r,t){"use strict";function' +
' n(e){var r=e.trim().toLowerCase();return!g.test(r)||!!k.test(r)}function s(e){v' +
'ar r=d.parse(e,!0);if(r.hostname&&(!r.protocol||b.indexOf(r.protocol)>=0))try{r.' +
'hostname=m.toASCII(r.hostname)}catch(t){}return d.encode(d.format(r))}function o' +
'(e){var r=d.parse(e,!0);if(r.hostname&&(!r.protocol||b.indexOf(r.protocol)>=0))t' +
'ry{r.hostname=m.toUnicode(r.hostname)}catch(t){}return d.decode(d.format(r))}fun' +
'ction i(e,r){return this instanceof i?(r||a.isString(e)||(r=e||{},e="default"),t' +
'his.inline=new h,this.block=new p,this.core=new u,this.renderer=new l,this.linki' +
'fy=new f,this.validateLink=n,this.normalizeLink=s,this.normalizeLinkText=o,this.' +
'utils=a,this.helpers=c,this.options={},this.configure(e),void(r&&this.set(r))):n' +
'ew i(e,r)}var a=e("./common/utils"),c=e("./helpers"),l=e("./renderer"),u=e("./pa' +
'rser_core"),p=e("./parser_block"),h=e("./parser_inline"),f=e("linkify-it"),d=e("' +
'mdurl"),m=e("punycode"),_={"default":e("./presets/default"),zero:e("./presets/ze' +
'ro"),commonmark:e("./presets/commonmark")},g=/^(vbscript|javascript|file|data):/' +
',k=/^data:image\/(gif|png|jpeg|webp);/,b=["http:","https:","mailto:"];i.prototyp' +
'e.set=function(e){return a.assign(this.options,e),this},i.prototype.configure=fu' +
'nction(e){var r,t=this;if(a.isString(e)&&(r=e,e=_[r],!e))throw new Error(''Wrong ' +
'`markdown-it` preset "''+r+''", check name'');if(!e)throw new Error("Wrong `markdow' +
'n-it` preset, can''t be empty");return e.options&&t.set(e.options),e.components&&' +
'Object.keys(e.components).forEach(function(r){e.components[r].rules&&t[r].ruler.' +
'enableOnly(e.components[r].rules),e.components[r].rules2&&t[r].ruler2.enableOnly' +
'(e.components[r].rules2)}),this},i.prototype.enable=function(e,r){var t=[];Array' +
'.isArray(e)||(e=[e]),["core","block","inline"].forEach(function(r){t=t.concat(th' +
'is[r].ruler.enable(e,!0))},this),t=t.concat(this.inline.ruler2.enable(e,!0));var' +
' n=e.filter(function(e){return t.indexOf(e)<0});if(n.length&&!r)throw new Error(' +
'"MarkdownIt. Failed to enable unknown rule(s): "+n);return this},i.prototype.dis' +
'able=function(e,r){var t=[];Array.isArray(e)||(e=[e]),["core","block","inline"].' +
'forEach(function(r){t=t.concat(this[r].ruler.disable(e,!0))},this),t=t.concat(th' +
'is.inline.ruler2.disable(e,!0));var n=e.filter(function(e){return t.indexOf(e)<0' +
'});if(n.length&&!r)throw new Error("MarkdownIt. Failed to disable unknown rule(s' +
'): "+n);return this},i.prototype.use=function(e){var r=[this].concat(Array.proto' +
'type.slice.call(arguments,1));return e.apply(e,r),this},i.prototype.parse=functi' +
'on(e,r){var t=new this.core.State(e,this,r);return this.core.process(t),t.tokens' +
'},i.prototype.render=function(e,r){return r=r||{},this.renderer.render(this.pars' +
'e(e,r),this.options,r)},i.prototype.parseInline=function(e,r){var t=new this.cor' +
'e.State(e,this,r);return t.inlineMode=!0,this.core.process(t),t.tokens},i.protot' +
'ype.renderInline=function(e,r){return r=r||{},this.renderer.render(this.parseInl' +
'ine(e,r),this.options,r)},r.exports=i},{"./common/utils":4,"./helpers":5,"./pars' +
'er_block":10,"./parser_core":11,"./parser_inline":12,"./presets/commonmark":13,"' +
'./presets/default":14,"./presets/zero":15,"./renderer":16,"linkify-it":54,mdurl:' +
'59,punycode:52}],10:[function(e,r,t){"use strict";function n(){this.ruler=new s;' +
'for(var e=0;e<o.length;e++)this.ruler.push(o[e][0],o[e][1],{alt:(o[e][2]||[]).sl' +
'ice()})}var s=e("./ruler"),o=[["table",e("./rules_block/table"),["paragraph","re' +
'ference"]],["code",e("./rules_block/code")],["fence",e("./rules_block/fence"),["' +
'paragraph","reference","blockquote","list"]],["blockquote",e("./rules_block/bloc' +
'kquote"),["paragraph","reference","list"]],["hr",e("./rules_block/hr"),["paragra' +
'ph","reference","blockquote","list"]],["list",e("./rules_block/list"),["paragrap' +
'h","reference","blockquote"]],["reference",e("./rules_block/reference")],["headi' +
'ng",e("./rules_block/heading"),["paragraph","reference","blockquote"]],["lheadin' +
'g",e("./rules_block/lheading")],["html_block",e("./rules_block/html_block"),["pa' +
'ragraph","reference","blockquote"]],["paragraph",e("./rules_block/paragraph")]];' +
'n.prototype.tokenize=function(e,r,t){for(var n,s,o=this.ruler.getRules(""),i=o.l' +
'ength,a=r,c=!1,l=e.md.options.maxNesting;a<t&&(e.line=a=e.skipEmptyLines(a),!(a>' +
'=t))&&!(e.sCount[a]<e.blkIndent);){if(e.level>=l){e.line=t;break}for(s=0;s<i&&!(' +
'n=o[s](e,a,t,!1));s++);if(e.tight=!c,e.isEmpty(e.line-1)&&(c=!0),a=e.line,a<t&&e' +
'.isEmpty(a)){if(c=!0,a++,a<t&&"list"===e.parentType&&e.isEmpty(a))break;e.line=a' +
'}}},n.prototype.parse=function(e,r,t,n){var s;e&&(s=new this.State(e,r,t,n),this' +
'.tokenize(s,s.line,s.lineMax))},n.prototype.State=e("./rules_block/state_block")' +
',r.exports=n},{"./ruler":17,"./rules_block/blockquote":18,"./rules_block/code":1' +
'9,"./rules_block/fence":20,"./rules_block/heading":21,"./rules_block/hr":22,"./r' +
'ules_block/html_block":23,"./rules_block/lheading":24,"./rules_block/list":25,".' +
'/rules_block/paragraph":26,"./rules_block/reference":27,"./rules_block/state_blo' +
'ck":28,"./rules_block/table":29}],11:[function(e,r,t){"use strict";function n(){' +
'this.ruler=new s;for(var e=0;e<o.length;e++)this.ruler.push(o[e][0],o[e][1])}var' +
' s=e("./ruler"),o=[["normalize",e("./rules_core/normalize")],["block",e("./rules' +
'_core/block")],["inline",e("./rules_core/inline")],["linkify",e("./rules_core/li' +
'nkify")],["replacements",e("./rules_core/replacements")],["smartquotes",e("./rul' +
'es_core/smartquotes")]];n.prototype.process=function(e){var r,t,n;for(n=this.rul' +
'er.getRules(""),r=0,t=n.length;r<t;r++)n[r](e)},n.prototype.State=e("./rules_cor' +
'e/state_core"),r.exports=n},{"./ruler":17,"./rules_core/block":30,"./rules_core/' +
'inline":31,"./rules_core/linkify":32,"./rules_core/normalize":33,"./rules_core/r' +
'eplacements":34,"./rules_core/smartquotes":35,"./rules_core/state_core":36}],12:' +
'[function(e,r,t){"use strict";function n(){var e;for(this.ruler=new s,e=0;e<o.le' +
'ngth;e++)this.ruler.push(o[e][0],o[e][1]);for(this.ruler2=new s,e=0;e<i.length;e' +
'++)this.ruler2.push(i[e][0],i[e][1])}var s=e("./ruler"),o=[["text",e("./rules_in' +
'line/text")],["newline",e("./rules_inline/newline")],["escape",e("./rules_inline' +
'/escape")],["backticks",e("./rules_inline/backticks")],["strikethrough",e("./rul' +
'es_inline/strikethrough").tokenize],["emphasis",e("./rules_inline/emphasis").tok' +
'enize],["link",e("./rules_inline/link")],["image",e("./rules_inline/image")],["a' +
'utolink",e("./rules_inline/autolink")],["html_inline",e("./rules_inline/html_inl' +
'ine")],["entity",e("./rules_inline/entity")]],i=[["balance_pairs",e("./rules_inl' +
'ine/balance_pairs")],["strikethrough",e("./rules_inline/strikethrough").postProc' +
'ess],["emphasis",e("./rules_inline/emphasis").postProcess],["text_collapse",e(".' +
'/rules_inline/text_collapse")]];n.prototype.skipToken=function(e){var r,t,n=e.po' +
's,s=this.ruler.getRules(""),o=s.length,i=e.md.options.maxNesting,a=e.cache;if("u' +
'ndefined"!=typeof a[n])return void(e.pos=a[n]);if(e.level<i)for(t=0;t<o&&(e.leve' +
'l++,r=s[t](e,!0),e.level--,!r);t++);else e.pos=e.posMax;r||e.pos++,a[n]=e.pos},n' +
'.prototype.tokenize=function(e){for(var r,t,n=this.ruler.getRules(""),s=n.length' +
',o=e.posMax,i=e.md.options.maxNesting;e.pos<o;){if(e.level<i)for(t=0;t<s&&!(r=n[' +
't](e,!1));t++);if(r){if(e.pos>=o)break}else e.pending+=e.src[e.pos++]}e.pending&' +
'&e.pushPending()},n.prototype.parse=function(e,r,t,n){var s,o,i,a=new this.State' +
'(e,r,t,n);for(this.tokenize(a),o=this.ruler2.getRules(""),i=o.length,s=0;s<i;s++' +
')o[s](a)},n.prototype.State=e("./rules_inline/state_inline"),r.exports=n},{"./ru' +
'ler":17,"./rules_inline/autolink":37,"./rules_inline/backticks":38,"./rules_inli' +
'ne/balance_pairs":39,"./rules_inline/emphasis":40,"./rules_inline/entity":41,"./' +
'rules_inline/escape":42,"./rules_inline/html_inline":43,"./rules_inline/image":4' +
'4,"./rules_inline/link":45,"./rules_inline/newline":46,"./rules_inline/state_inl' +
'ine":47,"./rules_inline/strikethrough":48,"./rules_inline/text":49,"./rules_inli' +
'ne/text_collapse":50}],13:[function(e,r,t){"use strict";r.exports={options:{html' +
':!0,xhtmlOut:!0,breaks:!1,langPrefix:"language-",linkify:!1,typographer:!1,quote' +
's:"\u201c\u201d\u2018\u2019",highlight:null,maxNesting:20},components:{core:{rul' +
'es:["normalize","block","inline"]},block:{rules:["blockquote","code","fence","he' +
'ading","hr","html_block","lheading","list","reference","paragraph"]},inline:{rul' +
'es:["autolink","backticks","emphasis","entity","escape","html_inline","image","l' +
'ink","newline","text"],rules2:["balance_pairs","emphasis","text_collapse"]}}}},{' +
'}],14:[function(e,r,t){"use strict";r.exports={options:{html:!1,xhtmlOut:!1,brea' +
'ks:!1,langPrefix:"language-",linkify:!1,typographer:!1,quotes:"\u201c\u201d\u201' +
'8\u2019",highlight:null,maxNesting:100},components:{core:{},block:{},inline:{}}}' +
'},{}],15:[function(e,r,t){"use strict";r.exports={options:{html:!1,xhtmlOut:!1,b' +
'reaks:!1,langPrefix:"language-",linkify:!1,typographer:!1,quotes:"\u201c\u201d\u' +
'2018\u2019",highlight:null,maxNesting:20},components:{core:{rules:["normalize","' +
'block","inline"]},block:{rules:["paragraph"]},inline:{rules:["text"],rules2:["ba' +
'lance_pairs","text_collapse"]}}}},{}],16:[function(e,r,t){"use strict";function ' +
'n(){this.rules=s({},a)}var s=e("./common/utils").assign,o=e("./common/utils").un' +
'escapeAll,i=e("./common/utils").escapeHtml,a={};a.code_inline=function(e,r,t,n,s' +
'){var o=e[r],a=s.renderAttrs(o);return"<code"+(a?" "+a:"")+">"+i(e[r].content)+"' +
'</code>"},a.code_block=function(e,r,t,n,s){var o=e[r],a=s.renderAttrs(o);return"' +
'<pre"+(a?" "+a:"")+"><code>"+i(e[r].content)+"</code></pre>\n"},a.fence=function' +
'(e,r,t,n,s){var a,c,l,u,p=e[r],h=p.info?o(p.info).trim():"",f="";return h&&(f=h.' +
'split(/\s+/g)[0]),a=t.highlight?t.highlight(p.content,f)||i(p.content):i(p.conte' +
'nt),0===a.indexOf("<pre")?a+"\n":h?(c=p.attrIndex("class"),l=p.attrs?p.attrs.sli' +
'ce():[],c<0?l.push(["class",t.langPrefix+f]):l[c]+=" "+t.langPrefix+f,u={attrs:l' +
'},"<pre><code"+s.renderAttrs(u)+">"+a+"</code></pre>\n"):"<pre><code"+s.renderAt' +
'trs(p)+">"+a+"</code></pre>\n"},a.image=function(e,r,t,n,s){var o=e[r];return o.' +
'attrs[o.attrIndex("alt")][1]=s.renderInlineAsText(o.children,t,n),s.renderToken(' +
'e,r,t)},a.hardbreak=function(e,r,t){return t.xhtmlOut?"<br />\n":"<br>\n"},a.sof' +
'tbreak=function(e,r,t){return t.breaks?t.xhtmlOut?"<br />\n":"<br>\n":"\n"},a.te' +
'xt=function(e,r){return i(e[r].content)},a.html_block=function(e,r){return e[r].' +
'content},a.html_inline=function(e,r){return e[r].content},n.prototype.renderAttr' +
's=function(e){var r,t,n;if(!e.attrs)return"";for(n="",r=0,t=e.attrs.length;r<t;r' +
'++)n+=" "+i(e.attrs[r][0])+''="''+i(e.attrs[r][1])+''"'';return n},n.prototype.rende' +
'rToken=function(e,r,t){var n,s="",o=!1,i=e[r];return i.hidden?"":(i.block&&i.nes' +
'ting!==-1&&r&&e[r-1].hidden&&(s+="\n"),s+=(i.nesting===-1?"</":"<")+i.tag,s+=thi' +
's.renderAttrs(i),0===i.nesting&&t.xhtmlOut&&(s+=" /"),i.block&&(o=!0,1===i.nesti' +
'ng&&r+1<e.length&&(n=e[r+1],"inline"===n.type||n.hidden?o=!1:n.nesting===-1&&n.t' +
'ag===i.tag&&(o=!1))),s+=o?">\n":">")},n.prototype.renderInline=function(e,r,t){f' +
'or(var n,s="",o=this.rules,i=0,a=e.length;i<a;i++)n=e[i].type,s+="undefined"!=ty' +
'peof o[n]?o[n](e,i,r,t,this):this.renderToken(e,i,r);return s},n.prototype.rende' +
'rInlineAsText=function(e,r,t){for(var n="",s=0,o=e.length;s<o;s++)"text"===e[s].' +
'type?n+=e[s].content:"image"===e[s].type&&(n+=this.renderInlineAsText(e[s].child' +
'ren,r,t));return n},n.prototype.render=function(e,r,t){var n,s,o,i="",a=this.rul' +
'es;for(n=0,s=e.length;n<s;n++)o=e[n].type,i+="inline"===o?this.renderInline(e[n]' +
'.children,r,t):"undefined"!=typeof a[o]?a[e[n].type](e,n,r,t,this):this.renderTo' +
'ken(e,n,r,t);return i},r.exports=n},{"./common/utils":4}],17:[function(e,r,t){"u' +
'se strict";function n(){this.__rules__=[],this.__cache__=null}n.prototype.__find' +
'__=function(e){for(var r=0;r<this.__rules__.length;r++)if(this.__rules__[r].name' +
'===e)return r;return-1},n.prototype.__compile__=function(){var e=this,r=[""];e._' +
'_rules__.forEach(function(e){e.enabled&&e.alt.forEach(function(e){r.indexOf(e)<0' +
'&&r.push(e)})}),e.__cache__={},r.forEach(function(r){e.__cache__[r]=[],e.__rules' +
'__.forEach(function(t){t.enabled&&(r&&t.alt.indexOf(r)<0||e.__cache__[r].push(t.' +
'fn))})})},n.prototype.at=function(e,r,t){var n=this.__find__(e),s=t||{};if(n===-' +
'1)throw new Error("Parser rule not found: "+e);this.__rules__[n].fn=r,this.__rul' +
'es__[n].alt=s.alt||[],this.__cache__=null},n.prototype.before=function(e,r,t,n){' +
'var s=this.__find__(e),o=n||{};if(s===-1)throw new Error("Parser rule not found:' +
' "+e);this.__rules__.splice(s,0,{name:r,enabled:!0,fn:t,alt:o.alt||[]}),this.__c' +
'ache__=null},n.prototype.after=function(e,r,t,n){var s=this.__find__(e),o=n||{};' +
'if(s===-1)throw new Error("Parser rule not found: "+e);this.__rules__.splice(s+1' +
',0,{name:r,enabled:!0,fn:t,alt:o.alt||[]}),this.__cache__=null},n.prototype.push' +
'=function(e,r,t){var n=t||{};this.__rules__.push({name:e,enabled:!0,fn:r,alt:n.a' +
'lt||[]}),this.__cache__=null},n.prototype.enable=function(e,r){Array.isArray(e)|' +
'|(e=[e]);var t=[];return e.forEach(function(e){var n=this.__find__(e);if(n<0){if' +
'(r)return;throw new Error("Rules manager: invalid rule name "+e)}this.__rules__[' +
'n].enabled=!0,t.push(e)},this),this.__cache__=null,t},n.prototype.enableOnly=fun' +
'ction(e,r){Array.isArray(e)||(e=[e]),this.__rules__.forEach(function(e){e.enable' +
'd=!1}),this.enable(e,r)},n.prototype.disable=function(e,r){Array.isArray(e)||(e=' +
'[e]);var t=[];return e.forEach(function(e){var n=this.__find__(e);if(n<0){if(r)r' +
'eturn;throw new Error("Rules manager: invalid rule name "+e)}this.__rules__[n].e' +
'nabled=!1,t.push(e)},this),this.__cache__=null,t},n.prototype.getRules=function(' +
'e){return null===this.__cache__&&this.__compile__(),this.__cache__[e]||[]},r.exp' +
'orts=n},{}],18:[function(e,r,t){"use strict";var n=e("../common/utils").isSpace;' +
'r.exports=function(e,r,t,s){var o,i,a,c,l,u,p,h,f,d,m,_,g,k,b,v,x=e.bMarks[r]+e.' +
'tShift[r],y=e.eMarks[r];if(62!==e.src.charCodeAt(x++))return!1;if(s)return!0;for' +
'(32===e.src.charCodeAt(x)&&x++,u=e.blkIndent,e.blkIndent=0,f=d=e.sCount[r]+x-(e.' +
'bMarks[r]+e.tShift[r]),l=[e.bMarks[r]],e.bMarks[r]=x;x<y&&(m=e.src.charCodeAt(x)' +
',n(m));)9===m?d+=4-d%4:d++,x++;for(i=x>=y,c=[e.sCount[r]],e.sCount[r]=d-f,a=[e.t' +
'Shift[r]],e.tShift[r]=x-e.bMarks[r],_=e.md.block.ruler.getRules("blockquote"),o=' +
'r+1;o<t&&!(e.sCount[o]<u)&&(x=e.bMarks[o]+e.tShift[o],y=e.eMarks[o],!(x>=y));o++' +
')if(62!==e.src.charCodeAt(x++)){if(i)break;for(v=!1,k=0,b=_.length;k<b;k++)if(_[' +
'k](e,o,t,!0)){v=!0;break}if(v)break;l.push(e.bMarks[o]),a.push(e.tShift[o]),c.pu' +
'sh(e.sCount[o]),e.sCount[o]=-1}else{for(32===e.src.charCodeAt(x)&&x++,f=d=e.sCou' +
'nt[o]+x-(e.bMarks[o]+e.tShift[o]),l.push(e.bMarks[o]),e.bMarks[o]=x;x<y&&(m=e.sr' +
'c.charCodeAt(x),n(m));)9===m?d+=4-d%4:d++,x++;i=x>=y,c.push(e.sCount[o]),e.sCoun' +
't[o]=d-f,a.push(e.tShift[o]),e.tShift[o]=x-e.bMarks[o]}for(p=e.parentType,e.pare' +
'ntType="blockquote",g=e.push("blockquote_open","blockquote",1),g.markup=">",g.ma' +
'p=h=[r,0],e.md.block.tokenize(e,r,o),g=e.push("blockquote_close","blockquote",-1' +
'),g.markup=">",e.parentType=p,h[1]=e.line,k=0;k<a.length;k++)e.bMarks[k+r]=l[k],' +
'e.tShift[k+r]=a[k],e.sCount[k+r]=c[k];return e.blkIndent=u,!0}},{"../common/util' +
's":4}],19:[function(e,r,t){"use strict";r.exports=function(e,r,t){var n,s,o,i=0;' +
'if(e.sCount[r]-e.blkIndent<4)return!1;for(s=n=r+1;n<t;)if(e.isEmpty(n)){if(i++,i' +
'>=2&&"list"===e.parentType)break;n++}else{if(i=0,!(e.sCount[n]-e.blkIndent>=4))b' +
'reak;n++,s=n}return e.line=s,o=e.push("code_block","code",0),o.content=e.getLine' +
's(r,s,4+e.blkIndent,!0),o.map=[r,e.line],!0}},{}],20:[function(e,r,t){"use stric' +
't";r.exports=function(e,r,t,n){var s,o,i,a,c,l,u,p=!1,h=e.bMarks[r]+e.tShift[r],' +
'f=e.eMarks[r];if(h+3>f)return!1;if(s=e.src.charCodeAt(h),126!==s&&96!==s)return!' +
'1;if(c=h,h=e.skipChars(h,s),o=h-c,o<3)return!1;if(u=e.src.slice(c,h),i=e.src.sli' +
'ce(h,f),i.indexOf("`")>=0)return!1;if(n)return!0;for(a=r;(a++,!(a>=t))&&(h=c=e.b' +
'Marks[a]+e.tShift[a],f=e.eMarks[a],!(h<f&&e.sCount[a]<e.blkIndent));)if(e.src.ch' +
'arCodeAt(h)===s&&!(e.sCount[a]-e.blkIndent>=4||(h=e.skipChars(h,s),h-c<o||(h=e.s' +
'kipSpaces(h),h<f)))){p=!0;break}return o=e.sCount[r],e.line=a+(p?1:0),l=e.push("' +
'fence","code",0),l.info=i,l.content=e.getLines(r+1,a,o,!0),l.markup=u,l.map=[r,e' +
'.line],!0}},{}],21:[function(e,r,t){"use strict";var n=e("../common/utils").isSp' +
'ace;r.exports=function(e,r,t,s){var o,i,a,c,l=e.bMarks[r]+e.tShift[r],u=e.eMarks' +
'[r];if(o=e.src.charCodeAt(l),35!==o||l>=u)return!1;for(i=1,o=e.src.charCodeAt(++' +
'l);35===o&&l<u&&i<=6;)i++,o=e.src.charCodeAt(++l);return!(i>6||l<u&&32!==o)&&(!!' +
's||(u=e.skipSpacesBack(u,l),a=e.skipCharsBack(u,35,l),a>l&&n(e.src.charCodeAt(a-' +
'1))&&(u=a),e.line=r+1,c=e.push("heading_open","h"+String(i),1),c.markup="#######' +
'#".slice(0,i),c.map=[r,e.line],c=e.push("inline","",0),c.content=e.src.slice(l,u' +
').trim(),c.map=[r,e.line],c.children=[],c=e.push("heading_close","h"+String(i),-' +
'1),c.markup="########".slice(0,i),!0))}},{"../common/utils":4}],22:[function(e,r' +
',t){"use strict";var n=e("../common/utils").isSpace;r.exports=function(e,r,t,s){' +
'var o,i,a,c,l=e.bMarks[r]+e.tShift[r],u=e.eMarks[r];if(o=e.src.charCodeAt(l++),4' +
'2!==o&&45!==o&&95!==o)return!1;for(i=1;l<u;){if(a=e.src.charCodeAt(l++),a!==o&&!' +
'n(a))return!1;a===o&&i++}return!(i<3)&&(!!s||(e.line=r+1,c=e.push("hr","hr",0),c' +
'.map=[r,e.line],c.markup=Array(i+1).join(String.fromCharCode(o)),!0))}},{"../com' +
'mon/utils":4}],23:[function(e,r,t){"use strict";var n=e("../common/html_blocks")' +
',s=e("../common/html_re").HTML_OPEN_CLOSE_TAG_RE,o=[[/^<(script|pre|style)(?=(\s' +
'|>|$))/i,/<\/(script|pre|style)>/i,!0],[/^<!--/,/-->/,!0],[/^<\?/,/\?>/,!0],[/^<' +
'![A-Z]/,/>/,!0],[/^<!\[CDATA\[/,/\]\]>/,!0],[new RegExp("^</?("+n.join("|")+")(?' +
'=(\\s|/?>|$))","i"),/^$/,!0],[new RegExp(s.source+"\\s*$"),/^$/,!1]];r.exports=f' +
'unction(e,r,t,n){var s,i,a,c,l=e.bMarks[r]+e.tShift[r],u=e.eMarks[r];if(!e.md.op' +
'tions.html)return!1;if(60!==e.src.charCodeAt(l))return!1;for(c=e.src.slice(l,u),' +
's=0;s<o.length&&!o[s][0].test(c);s++);if(s===o.length)return!1;if(n)return o[s][' +
'2];if(i=r+1,!o[s][1].test(c))for(;i<t&&!(e.sCount[i]<e.blkIndent);i++)if(l=e.bMa' +
'rks[i]+e.tShift[i],u=e.eMarks[i],c=e.src.slice(l,u),o[s][1].test(c)){0!==c.lengt' +
'h&&i++;break}return e.line=i,a=e.push("html_block","",0),a.map=[r,i],a.content=e' +
'.getLines(r,i,e.blkIndent,!0),!0}},{"../common/html_blocks":2,"../common/html_re' +
'":3}],24:[function(e,r,t){"use strict";r.exports=function(e,r,t){for(var n,s,o,i' +
',a,c,l,u,p,h=r+1,f=e.md.block.ruler.getRules("paragraph");h<t&&!e.isEmpty(h);h++' +
')if(!(e.sCount[h]-e.blkIndent>3)){if(e.sCount[h]>=e.blkIndent&&(c=e.bMarks[h]+e.' +
'tShift[h],l=e.eMarks[h],c<l&&(p=e.src.charCodeAt(c),(45===p||61===p)&&(c=e.skipC' +
'hars(c,p),c=e.skipSpaces(c),c>=l)))){u=61===p?1:2;break}if(!(e.sCount[h]<0)){for' +
'(s=!1,o=0,i=f.length;o<i;o++)if(f[o](e,h,t,!0)){s=!0;break}if(s)break}}return!!u' +
'&&(n=e.getLines(r,h,e.blkIndent,!1).trim(),e.line=h+1,a=e.push("heading_open","h' +
'"+String(u),1),a.markup=String.fromCharCode(p),a.map=[r,e.line],a=e.push("inline' +
'","",0),a.content=n,a.map=[r,e.line-1],a.children=[],a=e.push("heading_close","h' +
'"+String(u),-1),a.markup=String.fromCharCode(p),!0)}},{}],25:[function(e,r,t){"u' +
'se strict";function n(e,r){var t,n,s,o;return n=e.bMarks[r]+e.tShift[r],s=e.eMar' +
'ks[r],t=e.src.charCodeAt(n++),42!==t&&45!==t&&43!==t?-1:n<s&&(o=e.src.charCodeAt' +
'(n),!i(o))?-1:n}function s(e,r){var t,n=e.bMarks[r]+e.tShift[r],s=n,o=e.eMarks[r' +
'];if(s+1>=o)return-1;if(t=e.src.charCodeAt(s++),t<48||t>57)return-1;for(;;){if(s' +
'>=o)return-1;t=e.src.charCodeAt(s++);{if(!(t>=48&&t<=57)){if(41===t||46===t)brea' +
'k;return-1}if(s-n>=10)return-1}}return s<o&&(t=e.src.charCodeAt(s),!i(t))?-1:s}f' +
'unction o(e,r){var t,n,s=e.level+2;for(t=r+2,n=e.tokens.length-2;t<n;t++)e.token' +
's[t].level===s&&"paragraph_open"===e.tokens[t].type&&(e.tokens[t+2].hidden=!0,e.' +
'tokens[t].hidden=!0,t+=2)}var i=e("../common/utils").isSpace;r.exports=function(' +
'e,r,t,a){var c,l,u,p,h,f,d,m,_,g,k,b,v,x,y,C,A,w,D,q,E,S,F,z,L,T,R,M,I=!0;if((k=' +
's(e,r))>=0)w=!0;else{if(!((k=n(e,r))>=0))return!1;w=!1}if(A=e.src.charCodeAt(k-1' +
'),a)return!0;for(q=e.tokens.length,w?(g=e.bMarks[r]+e.tShift[r],C=Number(e.src.s' +
'ubstr(g,k-g-1)),L=e.push("ordered_list_open","ol",1),1!==C&&(L.attrs=[["start",C' +
']])):L=e.push("bullet_list_open","ul",1),L.map=S=[r,0],L.markup=String.fromCharC' +
'ode(A),c=r,E=!1,z=e.md.block.ruler.getRules("list");c<t;){for(v=k,x=e.eMarks[c],' +
'l=u=e.sCount[c]+k-(e.bMarks[r]+e.tShift[r]);v<x&&(b=e.src.charCodeAt(v),i(b));)9' +
'===b?u+=4-u%4:u++,v++;if(D=v,y=D>=x?1:u-l,y>4&&(y=1),p=l+y,L=e.push("list_item_o' +
'pen","li",1),L.markup=String.fromCharCode(A),L.map=F=[r,0],f=e.blkIndent,m=e.tig' +
'ht,h=e.tShift[r],d=e.sCount[r],_=e.parentType,e.blkIndent=p,e.tight=!0,e.parentT' +
'ype="list",e.tShift[r]=D-e.bMarks[r],e.sCount[r]=u,D>=x&&e.isEmpty(r+1)?e.line=M' +
'ath.min(e.line+2,t):e.md.block.tokenize(e,r,t,!0),e.tight&&!E||(I=!1),E=e.line-r' +
'>1&&e.isEmpty(e.line-1),e.blkIndent=f,e.tShift[r]=h,e.sCount[r]=d,e.tight=m,e.pa' +
'rentType=_,L=e.push("list_item_close","li",-1),L.markup=String.fromCharCode(A),c' +
'=r=e.line,F[1]=c,D=e.bMarks[r],c>=t)break;if(e.isEmpty(c))break;if(e.sCount[c]<e' +
'.blkIndent)break;for(M=!1,T=0,R=z.length;T<R;T++)if(z[T](e,c,t,!0)){M=!0;break}i' +
'f(M)break;if(w){if(k=s(e,c),k<0)break}else if(k=n(e,c),k<0)break;if(A!==e.src.ch' +
'arCodeAt(k-1))break}return L=w?e.push("ordered_list_close","ol",-1):e.push("bull' +
'et_list_close","ul",-1),L.markup=String.fromCharCode(A),S[1]=c,e.line=c,I&&o(e,q' +
'),!0}},{"../common/utils":4}],26:[function(e,r,t){"use strict";r.exports=functio' +
'n(e,r){for(var t,n,s,o,i,a=r+1,c=e.md.block.ruler.getRules("paragraph"),l=e.line' +
'Max;a<l&&!e.isEmpty(a);a++)if(!(e.sCount[a]-e.blkIndent>3||e.sCount[a]<0)){for(n' +
'=!1,s=0,o=c.length;s<o;s++)if(c[s](e,a,l,!0)){n=!0;break}if(n)break}return t=e.g' +
'etLines(r,a,e.blkIndent,!1).trim(),e.line=a,i=e.push("paragraph_open","p",1),i.m' +
'ap=[r,e.line],i=e.push("inline","",0),i.content=t,i.map=[r,e.line],i.children=[]' +
',i=e.push("paragraph_close","p",-1),!0}},{}],27:[function(e,r,t){"use strict";va' +
'r n=e("../helpers/parse_link_destination"),s=e("../helpers/parse_link_title"),o=' +
'e("../common/utils").normalizeReference,i=e("../common/utils").isSpace;r.exports' +
'=function(e,r,t,a){var c,l,u,p,h,f,d,m,_,g,k,b,v,x,y,C=0,A=e.bMarks[r]+e.tShift[' +
'r],w=e.eMarks[r],D=r+1;if(91!==e.src.charCodeAt(A))return!1;for(;++A<w;)if(93===' +
'e.src.charCodeAt(A)&&92!==e.src.charCodeAt(A-1)){if(A+1===w)return!1;if(58!==e.s' +
'rc.charCodeAt(A+1))return!1;break}for(p=e.lineMax,x=e.md.block.ruler.getRules("r' +
'eference");D<p&&!e.isEmpty(D);D++)if(!(e.sCount[D]-e.blkIndent>3||e.sCount[D]<0)' +
'){for(v=!1,f=0,d=x.length;f<d;f++)if(x[f](e,D,p,!0)){v=!0;break}if(v)break}for(b' +
'=e.getLines(r,D,e.blkIndent,!1).trim(),w=b.length,A=1;A<w;A++){if(c=b.charCodeAt' +
'(A),91===c)return!1;if(93===c){_=A;break}10===c?C++:92===c&&(A++,A<w&&10===b.cha' +
'rCodeAt(A)&&C++)}if(_<0||58!==b.charCodeAt(_+1))return!1;for(A=_+2;A<w;A++)if(c=' +
'b.charCodeAt(A),10===c)C++;else if(!i(c))break;if(g=n(b,A,w),!g.ok)return!1;if(h' +
'=e.md.normalizeLink(g.str),!e.md.validateLink(h))return!1;for(A=g.pos,C+=g.lines' +
',l=A,u=C,k=A;A<w;A++)if(c=b.charCodeAt(A),10===c)C++;else if(!i(c))break;for(g=s' +
'(b,A,w),A<w&&k!==A&&g.ok?(y=g.str,A=g.pos,C+=g.lines):(y="",A=l,C=u);A<w&&(c=b.c' +
'harCodeAt(A),i(c));)A++;if(A<w&&10!==b.charCodeAt(A)&&y)for(y="",A=l,C=u;A<w&&(c' +
'=b.charCodeAt(A),i(c));)A++;return!(A<w&&10!==b.charCodeAt(A))&&(!!(m=o(b.slice(' +
'1,_)))&&(!!a||("undefined"==typeof e.env.references&&(e.env.references={}),"unde' +
'fined"==typeof e.env.references[m]&&(e.env.references[m]={title:y,href:h}),e.lin' +
'e=r+C+1,!0)))}},{"../common/utils":4,"../helpers/parse_link_destination":6,"../h' +
'elpers/parse_link_title":8}],28:[function(e,r,t){"use strict";function n(e,r,t,n' +
'){var s,i,a,c,l,u,p,h;for(this.src=e,this.md=r,this.env=t,this.tokens=n,this.bMa' +
'rks=[],this.eMarks=[],this.tShift=[],this.sCount=[],this.blkIndent=0,this.line=0' +
',this.lineMax=0,this.tight=!1,this.parentType="root",this.ddIndent=-1,this.level' +
'=0,this.result="",i=this.src,h=!1,a=c=u=p=0,l=i.length;c<l;c++){if(s=i.charCodeA' +
't(c),!h){if(o(s)){u++,9===s?p+=4-p%4:p++;continue}h=!0}10!==s&&c!==l-1||(10!==s&' +
'&c++,this.bMarks.push(a),this.eMarks.push(c),this.tShift.push(u),this.sCount.pus' +
'h(p),h=!1,u=0,p=0,a=c+1)}this.bMarks.push(i.length),this.eMarks.push(i.length),t' +
'his.tShift.push(0),this.sCount.push(0),this.lineMax=this.bMarks.length-1}var s=e' +
'("../token"),o=e("../common/utils").isSpace;n.prototype.push=function(e,r,t){var' +
' n=new s(e,r,t);return n.block=!0,t<0&&this.level--,n.level=this.level,t>0&&this' +
'.level++,this.tokens.push(n),n},n.prototype.isEmpty=function(e){return this.bMar' +
'ks[e]+this.tShift[e]>=this.eMarks[e]},n.prototype.skipEmptyLines=function(e){for' +
'(var r=this.lineMax;e<r&&!(this.bMarks[e]+this.tShift[e]<this.eMarks[e]);e++);re' +
'turn e},n.prototype.skipSpaces=function(e){for(var r,t=this.src.length;e<t&&(r=t' +
'his.src.charCodeAt(e),o(r));e++);return e},n.prototype.skipSpacesBack=function(e' +
',r){if(e<=r)return e;for(;e>r;)if(!o(this.src.charCodeAt(--e)))return e+1;return' +
' e},n.prototype.skipChars=function(e,r){for(var t=this.src.length;e<t&&this.src.' +
'charCodeAt(e)===r;e++);return e},n.prototype.skipCharsBack=function(e,r,t){if(e<' +
'=t)return e;for(;e>t;)if(r!==this.src.charCodeAt(--e))return e+1;return e},n.pro' +
'totype.getLines=function(e,r,t,n){var s,i,a,c,l,u,p,h=e;if(e>=r)return"";for(u=n' +
'ew Array(r-e),s=0;h<r;h++,s++){for(i=0,p=c=this.bMarks[h],l=h+1<r||n?this.eMarks' +
'[h]+1:this.eMarks[h];c<l&&i<t;){if(a=this.src.charCodeAt(c),o(a))9===a?i+=4-i%4:' +
'i++;else{if(!(c-p<this.tShift[h]))break;i++}c++}u[s]=this.src.slice(c,l)}return ' +
'u.join("")},n.prototype.Token=s,r.exports=n},{"../common/utils":4,"../token":51}' +
'],29:[function(e,r,t){"use strict";function n(e,r){var t=e.bMarks[r]+e.blkIndent' +
',n=e.eMarks[r];return e.src.substr(t,n-t)}function s(e){var r,t=[],n=0,s=e.lengt' +
'h,o=0,i=0,a=!1,c=0;for(r=e.charCodeAt(n);n<s;)96===r&&o%2===0?(a=!a,c=n):124!==r' +
'||o%2!==0||a?92===r?o++:o=0:(t.push(e.substring(i,n)),i=n+1),n++,n===s&&a&&(a=!1' +
',n=c+1),r=e.charCodeAt(n);return t.push(e.substring(i)),t}r.exports=function(e,r' +
',t,o){var i,a,c,l,u,p,h,f,d,m,_,g;if(r+2>t)return!1;if(u=r+1,e.sCount[u]<e.blkIn' +
'dent)return!1;if(c=e.bMarks[u]+e.tShift[u],c>=e.eMarks[u])return!1;if(i=e.src.ch' +
'arCodeAt(c),124!==i&&45!==i&&58!==i)return!1;if(a=n(e,r+1),!/^[-:| ]+$/.test(a))' +
'return!1;for(p=a.split("|"),d=[],l=0;l<p.length;l++){if(m=p[l].trim(),!m){if(0==' +
'=l||l===p.length-1)continue; ' +
'return!1}if(!/^:?-+:?$/.test(m))return!1;58===m.charCodeAt(m.length-1)?d.push(58' +
'===m.charCodeAt(0)?"center":"right"):58===m.charCodeAt(0)?d.push("left"):d.push(' +
'"")}if(a=n(e,r).trim(),a.indexOf("|")===-1)return!1;if(p=s(a.replace(/^\||\|$/g,' +
'"")),h=p.length,h>d.length)return!1;if(o)return!0;for(f=e.push("table_open","tab' +
'le",1),f.map=_=[r,0],f=e.push("thead_open","thead",1),f.map=[r,r+1],f=e.push("tr' +
'_open","tr",1),f.map=[r,r+1],l=0;l<p.length;l++)f=e.push("th_open","th",1),f.map' +
'=[r,r+1],d[l]&&(f.attrs=[["style","text-align:"+d[l]]]),f=e.push("inline","",0),' +
'f.content=p[l].trim(),f.map=[r,r+1],f.children=[],f=e.push("th_close","th",-1);f' +
'or(f=e.push("tr_close","tr",-1),f=e.push("thead_close","thead",-1),f=e.push("tbo' +
'dy_open","tbody",1),f.map=g=[r+2,0],u=r+2;u<t&&!(e.sCount[u]<e.blkIndent)&&(a=n(' +
'e,u),a.indexOf("|")!==-1);u++){for(p=s(a.replace(/^\||\|\s*$/g,"")),f=e.push("tr' +
'_open","tr",1),l=0;l<h;l++)f=e.push("td_open","td",1),d[l]&&(f.attrs=[["style","' +
'text-align:"+d[l]]]),f=e.push("inline","",0),f.content=p[l]?p[l].trim():"",f.chi' +
'ldren=[],f=e.push("td_close","td",-1);f=e.push("tr_close","tr",-1)}return f=e.pu' +
'sh("tbody_close","tbody",-1),f=e.push("table_close","table",-1),_[1]=g[1]=u,e.li' +
'ne=u,!0}},{}],30:[function(e,r,t){"use strict";r.exports=function(e){var r;e.inl' +
'ineMode?(r=new e.Token("inline","",0),r.content=e.src,r.map=[0,1],r.children=[],' +
'e.tokens.push(r)):e.md.block.parse(e.src,e.md,e.env,e.tokens)}},{}],31:[function' +
'(e,r,t){"use strict";r.exports=function(e){var r,t,n,s=e.tokens;for(t=0,n=s.leng' +
'th;t<n;t++)r=s[t],"inline"===r.type&&e.md.inline.parse(r.content,e.md,e.env,r.ch' +
'ildren)}},{}],32:[function(e,r,t){"use strict";function n(e){return/^<a[>\s]/i.t' +
'est(e)}function s(e){return/^<\/a\s*>/i.test(e)}var o=e("../common/utils").array' +
'ReplaceAt;r.exports=function(e){var r,t,i,a,c,l,u,p,h,f,d,m,_,g,k,b,v,x=e.tokens' +
';if(e.md.options.linkify)for(t=0,i=x.length;t<i;t++)if("inline"===x[t].type&&e.m' +
'd.linkify.pretest(x[t].content))for(a=x[t].children,_=0,r=a.length-1;r>=0;r--)if' +
'(l=a[r],"link_close"!==l.type){if("html_inline"===l.type&&(n(l.content)&&_>0&&_-' +
'-,s(l.content)&&_++),!(_>0)&&"text"===l.type&&e.md.linkify.test(l.content)){for(' +
'h=l.content,v=e.md.linkify.match(h),u=[],m=l.level,d=0,p=0;p<v.length;p++)g=v[p]' +
'.url,k=e.md.normalizeLink(g),e.md.validateLink(k)&&(b=v[p].text,b=v[p].schema?"m' +
'ailto:"!==v[p].schema||/^mailto:/i.test(b)?e.md.normalizeLinkText(b):e.md.normal' +
'izeLinkText("mailto:"+b).replace(/^mailto:/,""):e.md.normalizeLinkText("http://"' +
'+b).replace(/^http:\/\//,""),f=v[p].index,f>d&&(c=new e.Token("text","",0),c.con' +
'tent=h.slice(d,f),c.level=m,u.push(c)),c=new e.Token("link_open","a",1),c.attrs=' +
'[["href",k]],c.level=m++,c.markup="linkify",c.info="auto",u.push(c),c=new e.Toke' +
'n("text","",0),c.content=b,c.level=m,u.push(c),c=new e.Token("link_close","a",(-' +
'1)),c.level=--m,c.markup="linkify",c.info="auto",u.push(c),d=v[p].lastIndex);d<h' +
'.length&&(c=new e.Token("text","",0),c.content=h.slice(d),c.level=m,u.push(c)),x' +
'[t].children=a=o(a,r,u)}}else for(r--;a[r].level!==l.level&&"link_open"!==a[r].t' +
'ype;)r--}},{"../common/utils":4}],33:[function(e,r,t){"use strict";var n=/\r[\n\' +
'u0085]?|[\u2424\u2028\u0085]/g,s=/\u0000/g;r.exports=function(e){var r;r=e.src.r' +
'eplace(n,"\n"),r=r.replace(s,"\ufffd"),e.src=r}},{}],34:[function(e,r,t){"use st' +
'rict";function n(e,r){return l[r.toLowerCase()]}function s(e){var r,t;for(r=e.le' +
'ngth-1;r>=0;r--)t=e[r],"text"===t.type&&(t.content=t.content.replace(c,n))}funct' +
'ion o(e){var r,t;for(r=e.length-1;r>=0;r--)t=e[r],"text"===t.type&&i.test(t.cont' +
'ent)&&(t.content=t.content.replace(/\+-/g,"\xb1").replace(/\.{2,}/g,"\u2026").re' +
'place(/([?!])\u2026/g,"$1..").replace(/([?!]){4,}/g,"$1$1$1").replace(/,{2,}/g,"' +
',").replace(/(^|[^-])---([^-]|$)/gm,"$1\u2014$2").replace(/(^|\s)--(\s|$)/gm,"$1' +
'\u2013$2").replace(/(^|[^-\s])--([^-\s]|$)/gm,"$1\u2013$2"))}var i=/\+-|\.\.|\?\' +
'?\?\?|!!!!|,,|--/,a=/\((c|tm|r|p)\)/i,c=/\((c|tm|r|p)\)/gi,l={c:"\xa9",r:"\xae",' +
'p:"\xa7",tm:"\u2122"};r.exports=function(e){var r;if(e.md.options.typographer)fo' +
'r(r=e.tokens.length-1;r>=0;r--)"inline"===e.tokens[r].type&&(a.test(e.tokens[r].' +
'content)&&s(e.tokens[r].children),i.test(e.tokens[r].content)&&o(e.tokens[r].chi' +
'ldren))}},{}],35:[function(e,r,t){"use strict";function n(e,r,t){return e.substr' +
'(0,r)+t+e.substr(r+1)}function s(e,r){var t,s,c,p,h,f,d,m,_,g,k,b,v,x,y,C,A,w,D,' +
'q,E;for(D=[],t=0;t<e.length;t++){for(s=e[t],d=e[t].level,A=D.length-1;A>=0&&!(D[' +
'A].level<=d);A--);if(D.length=A+1,"text"===s.type){c=s.content,h=0,f=c.length;e:' +
'for(;h<f&&(l.lastIndex=h,p=l.exec(c));){if(y=C=!0,h=p.index+1,w="''"===p[0],_=32,' +
'p.index-1>=0)_=c.charCodeAt(p.index-1);else for(A=t-1;A>=0;A--)if("text"===e[A].' +
'type){_=e[A].content.charCodeAt(e[A].content.length-1);break}if(g=32,h<f)g=c.cha' +
'rCodeAt(h);else for(A=t+1;A<e.length;A++)if("text"===e[A].type){g=e[A].content.c' +
'harCodeAt(0);break}if(k=a(_)||i(String.fromCharCode(_)),b=a(g)||i(String.fromCha' +
'rCode(g)),v=o(_),x=o(g),x?y=!1:b&&(v||k||(y=!1)),v?C=!1:k&&(x||b||(C=!1)),34===g' +
'&&''"''===p[0]&&_>=48&&_<=57&&(C=y=!1),y&&C&&(y=!1,C=b),y||C){if(C)for(A=D.length-' +
'1;A>=0&&(m=D[A],!(D[A].level<d));A--)if(m.single===w&&D[A].level===d){m=D[A],w?(' +
'q=r.md.options.quotes[2],E=r.md.options.quotes[3]):(q=r.md.options.quotes[0],E=r' +
'.md.options.quotes[1]),s.content=n(s.content,p.index,E),e[m.token].content=n(e[m' +
'.token].content,m.pos,q),h+=E.length-1,m.token===t&&(h+=q.length-1),c=s.content,' +
'f=c.length,D.length=A;continue e}y?D.push({token:t,pos:p.index,single:w,level:d}' +
'):C&&w&&(s.content=n(s.content,p.index,u))}else w&&(s.content=n(s.content,p.inde' +
'x,u))}}}}var o=e("../common/utils").isWhiteSpace,i=e("../common/utils").isPunctC' +
'har,a=e("../common/utils").isMdAsciiPunct,c=/[''"]/,l=/[''"]/g,u="\u2019";r.export' +
's=function(e){var r;if(e.md.options.typographer)for(r=e.tokens.length-1;r>=0;r--' +
')"inline"===e.tokens[r].type&&c.test(e.tokens[r].content)&&s(e.tokens[r].childre' +
'n,e)}},{"../common/utils":4}],36:[function(e,r,t){"use strict";function n(e,r,t)' +
'{this.src=e,this.env=t,this.tokens=[],this.inlineMode=!1,this.md=r}var s=e("../t' +
'oken");n.prototype.Token=s,r.exports=n},{"../token":51}],37:[function(e,r,t){"us' +
'e strict";var n=/^<([a-zA-Z0-9.!#$%&''*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]' +
'{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>/,s=/^<' +
'([a-zA-Z][a-zA-Z0-9+.\-]{1,31}):([^<>\x00-\x20]*)>/;r.exports=function(e,r){var ' +
't,o,i,a,c,l,u=e.pos;return 60===e.src.charCodeAt(u)&&(t=e.src.slice(u),!(t.index' +
'Of(">")<0)&&(s.test(t)?(o=t.match(s),a=o[0].slice(1,-1),c=e.md.normalizeLink(a),' +
'!!e.md.validateLink(c)&&(r||(l=e.push("link_open","a",1),l.attrs=[["href",c]],l.' +
'markup="autolink",l.info="auto",l=e.push("text","",0),l.content=e.md.normalizeLi' +
'nkText(a),l=e.push("link_close","a",-1),l.markup="autolink",l.info="auto"),e.pos' +
'+=o[0].length,!0)):!!n.test(t)&&(i=t.match(n),a=i[0].slice(1,-1),c=e.md.normaliz' +
'eLink("mailto:"+a),!!e.md.validateLink(c)&&(r||(l=e.push("link_open","a",1),l.at' +
'trs=[["href",c]],l.markup="autolink",l.info="auto",l=e.push("text","",0),l.conte' +
'nt=e.md.normalizeLinkText(a),l=e.push("link_close","a",-1),l.markup="autolink",l' +
'.info="auto"),e.pos+=i[0].length,!0))))}},{}],38:[function(e,r,t){"use strict";r' +
'.exports=function(e,r){var t,n,s,o,i,a,c=e.pos,l=e.src.charCodeAt(c);if(96!==l)r' +
'eturn!1;for(t=c,c++,n=e.posMax;c<n&&96===e.src.charCodeAt(c);)c++;for(s=e.src.sl' +
'ice(t,c),o=i=c;(o=e.src.indexOf("`",i))!==-1;){for(i=o+1;i<n&&96===e.src.charCod' +
'eAt(i);)i++;if(i-o===s.length)return r||(a=e.push("code_inline","code",0),a.mark' +
'up=s,a.content=e.src.slice(c,o).replace(/[ \n]+/g," ").trim()),e.pos=i,!0}return' +
' r||(e.pending+=s),e.pos+=s.length,!0}},{}],39:[function(e,r,t){"use strict";r.e' +
'xports=function(e){var r,t,n,s,o=e.delimiters,i=e.delimiters.length;for(r=0;r<i;' +
'r++)if(n=o[r],n.close)for(t=r-n.jump-1;t>=0;){if(s=o[t],s.open&&s.marker===n.mar' +
'ker&&s.end<0&&s.level===n.level){n.jump=r-t,n.open=!1,s.end=r,s.jump=0;break}t-=' +
's.jump+1}}},{}],40:[function(e,r,t){"use strict";r.exports.tokenize=function(e,r' +
'){var t,n,s,o=e.pos,i=e.src.charCodeAt(o);if(r)return!1;if(95!==i&&42!==i)return' +
'!1;for(n=e.scanDelims(e.pos,42===i),t=0;t<n.length;t++)s=e.push("text","",0),s.c' +
'ontent=String.fromCharCode(i),e.delimiters.push({marker:i,jump:t,token:e.tokens.' +
'length-1,level:e.level,end:-1,open:n.can_open,close:n.can_close});return e.pos+=' +
'n.length,!0},r.exports.postProcess=function(e){var r,t,n,s,o,i,a=e.delimiters,c=' +
'e.delimiters.length;for(r=0;r<c;r++)t=a[r],95!==t.marker&&42!==t.marker||t.end!=' +
'=-1&&(n=a[t.end],i=r+1<c&&a[r+1].end===t.end-1&&a[r+1].token===t.token+1&&a[t.en' +
'd-1].token===n.token-1&&a[r+1].marker===t.marker,o=String.fromCharCode(t.marker)' +
',s=e.tokens[t.token],s.type=i?"strong_open":"em_open",s.tag=i?"strong":"em",s.ne' +
'sting=1,s.markup=i?o+o:o,s.content="",s=e.tokens[n.token],s.type=i?"strong_close' +
'":"em_close",s.tag=i?"strong":"em",s.nesting=-1,s.markup=i?o+o:o,s.content="",i&' +
'&(e.tokens[a[r+1].token].content="",e.tokens[a[t.end-1].token].content="",r++))}' +
'},{}],41:[function(e,r,t){"use strict";var n=e("../common/entities"),s=e("../com' +
'mon/utils").has,o=e("../common/utils").isValidEntityCode,i=e("../common/utils").' +
'fromCodePoint,a=/^&#((?:x[a-f0-9]{1,8}|[0-9]{1,8}));/i,c=/^&([a-z][a-z0-9]{1,31}' +
');/i;r.exports=function(e,r){var t,l,u,p=e.pos,h=e.posMax;if(38!==e.src.charCode' +
'At(p))return!1;if(p+1<h)if(t=e.src.charCodeAt(p+1),35===t){if(u=e.src.slice(p).m' +
'atch(a))return r||(l="x"===u[1][0].toLowerCase()?parseInt(u[1].slice(1),16):pars' +
'eInt(u[1],10),e.pending+=i(o(l)?l:65533)),e.pos+=u[0].length,!0}else if(u=e.src.' +
'slice(p).match(c),u&&s(n,u[1]))return r||(e.pending+=n[u[1]]),e.pos+=u[0].length' +
',!0;return r||(e.pending+="&"),e.pos++,!0}},{"../common/entities":1,"../common/u' +
'tils":4}],42:[function(e,r,t){"use strict";for(var n=e("../common/utils").isSpac' +
'e,s=[],o=0;o<256;o++)s.push(0);"\\!\"#$%&''()*+,./:;<=>?@[]^_`{|}~-".split("").fo' +
'rEach(function(e){s[e.charCodeAt(0)]=1}),r.exports=function(e,r){var t,o=e.pos,i' +
'=e.posMax;if(92!==e.src.charCodeAt(o))return!1;if(o++,o<i){if(t=e.src.charCodeAt' +
'(o),t<256&&0!==s[t])return r||(e.pending+=e.src[o]),e.pos+=2,!0;if(10===t){for(r' +
'||e.push("hardbreak","br",0),o++;o<i&&(t=e.src.charCodeAt(o),n(t));)o++;return e' +
'.pos=o,!0}}return r||(e.pending+="\\"),e.pos++,!0}},{"../common/utils":4}],43:[f' +
'unction(e,r,t){"use strict";function n(e){var r=32|e;return r>=97&&r<=122}var s=' +
'e("../common/html_re").HTML_TAG_RE;r.exports=function(e,r){var t,o,i,a,c=e.pos;r' +
'eturn!!e.md.options.html&&(i=e.posMax,!(60!==e.src.charCodeAt(c)||c+2>=i)&&(t=e.' +
'src.charCodeAt(c+1),!(33!==t&&63!==t&&47!==t&&!n(t))&&(!!(o=e.src.slice(c).match' +
'(s))&&(r||(a=e.push("html_inline","",0),a.content=e.src.slice(c,c+o[0].length)),' +
'e.pos+=o[0].length,!0))))}},{"../common/html_re":3}],44:[function(e,r,t){"use st' +
'rict";var n=e("../helpers/parse_link_label"),s=e("../helpers/parse_link_destinat' +
'ion"),o=e("../helpers/parse_link_title"),i=e("../common/utils").normalizeReferen' +
'ce,a=e("../common/utils").isSpace;r.exports=function(e,r){var t,c,l,u,p,h,f,d,m,' +
'_,g,k,b,v="",x=e.pos,y=e.posMax;if(33!==e.src.charCodeAt(e.pos))return!1;if(91!=' +
'=e.src.charCodeAt(e.pos+1))return!1;if(h=e.pos+2,p=n(e,e.pos+1,!1),p<0)return!1;' +
'if(f=p+1,f<y&&40===e.src.charCodeAt(f)){for(f++;f<y&&(c=e.src.charCodeAt(f),a(c)' +
'||10===c);f++);if(f>=y)return!1;for(b=f,m=s(e.src,f,e.posMax),m.ok&&(v=e.md.norm' +
'alizeLink(m.str),e.md.validateLink(v)?f=m.pos:v=""),b=f;f<y&&(c=e.src.charCodeAt' +
'(f),a(c)||10===c);f++);if(m=o(e.src,f,e.posMax),f<y&&b!==f&&m.ok)for(_=m.str,f=m' +
'.pos;f<y&&(c=e.src.charCodeAt(f),a(c)||10===c);f++);else _="";if(f>=y||41!==e.sr' +
'c.charCodeAt(f))return e.pos=x,!1;f++}else{if("undefined"==typeof e.env.referenc' +
'es)return!1;if(f<y&&91===e.src.charCodeAt(f)?(b=f+1,f=n(e,f),f>=0?u=e.src.slice(' +
'b,f++):f=p+1):f=p+1,u||(u=e.src.slice(h,p)),d=e.env.references[i(u)],!d)return e' +
'.pos=x,!1;v=d.href,_=d.title}return r||(l=e.src.slice(h,p),e.md.inline.parse(l,e' +
'.md,e.env,k=[]),g=e.push("image","img",0),g.attrs=t=[["src",v],["alt",""]],g.chi' +
'ldren=k,g.content=l,_&&t.push(["title",_])),e.pos=f,e.posMax=y,!0}},{"../common/' +
'utils":4,"../helpers/parse_link_destination":6,"../helpers/parse_link_label":7,"' +
'../helpers/parse_link_title":8}],45:[function(e,r,t){"use strict";var n=e("../he' +
'lpers/parse_link_label"),s=e("../helpers/parse_link_destination"),o=e("../helper' +
's/parse_link_title"),i=e("../common/utils").normalizeReference,a=e("../common/ut' +
'ils").isSpace;r.exports=function(e,r){var t,c,l,u,p,h,f,d,m,_,g="",k=e.pos,b=e.p' +
'osMax,v=e.pos;if(91!==e.src.charCodeAt(e.pos))return!1;if(p=e.pos+1,u=n(e,e.pos,' +
'!0),u<0)return!1;if(h=u+1,h<b&&40===e.src.charCodeAt(h)){for(h++;h<b&&(c=e.src.c' +
'harCodeAt(h),a(c)||10===c);h++);if(h>=b)return!1;for(v=h,f=s(e.src,h,e.posMax),f' +
'.ok&&(g=e.md.normalizeLink(f.str),e.md.validateLink(g)?h=f.pos:g=""),v=h;h<b&&(c' +
'=e.src.charCodeAt(h),a(c)||10===c);h++);if(f=o(e.src,h,e.posMax),h<b&&v!==h&&f.o' +
'k)for(m=f.str,h=f.pos;h<b&&(c=e.src.charCodeAt(h),a(c)||10===c);h++);else m="";i' +
'f(h>=b||41!==e.src.charCodeAt(h))return e.pos=k,!1;h++}else{if("undefined"==type' +
'of e.env.references)return!1;if(h<b&&91===e.src.charCodeAt(h)?(v=h+1,h=n(e,h),h>' +
'=0?l=e.src.slice(v,h++):h=u+1):h=u+1,l||(l=e.src.slice(p,u)),d=e.env.references[' +
'i(l)],!d)return e.pos=k,!1;g=d.href,m=d.title}return r||(e.pos=p,e.posMax=u,_=e.' +
'push("link_open","a",1),_.attrs=t=[["href",g]],m&&t.push(["title",m]),e.md.inlin' +
'e.tokenize(e),_=e.push("link_close","a",-1)),e.pos=h,e.posMax=b,!0}},{"../common' +
'/utils":4,"../helpers/parse_link_destination":6,"../helpers/parse_link_label":7,' +
'"../helpers/parse_link_title":8}],46:[function(e,r,t){"use strict";r.exports=fun' +
'ction(e,r){var t,n,s=e.pos;if(10!==e.src.charCodeAt(s))return!1;for(t=e.pending.' +
'length-1,n=e.posMax,r||(t>=0&&32===e.pending.charCodeAt(t)?t>=1&&32===e.pending.' +
'charCodeAt(t-1)?(e.pending=e.pending.replace(/ +$/,""),e.push("hardbreak","br",0' +
')):(e.pending=e.pending.slice(0,-1),e.push("softbreak","br",0)):e.push("softbrea' +
'k","br",0)),s++;s<n&&32===e.src.charCodeAt(s);)s++;return e.pos=s,!0}},{}],47:[f' +
'unction(e,r,t){"use strict";function n(e,r,t,n){this.src=e,this.env=t,this.md=r,' +
'this.tokens=n,this.pos=0,this.posMax=this.src.length,this.level=0,this.pending="' +
'",this.pendingLevel=0,this.cache={},this.delimiters=[]}var s=e("../token"),o=e("' +
'../common/utils").isWhiteSpace,i=e("../common/utils").isPunctChar,a=e("../common' +
'/utils").isMdAsciiPunct;n.prototype.pushPending=function(){var e=new s("text",""' +
',0);return e.content=this.pending,e.level=this.pendingLevel,this.tokens.push(e),' +
'this.pending="",e},n.prototype.push=function(e,r,t){this.pending&&this.pushPendi' +
'ng();var n=new s(e,r,t);return t<0&&this.level--,n.level=this.level,t>0&&this.le' +
'vel++,this.pendingLevel=this.level,this.tokens.push(n),n},n.prototype.scanDelims' +
'=function(e,r){var t,n,s,c,l,u,p,h,f,d=e,m=!0,_=!0,g=this.posMax,k=this.src.char' +
'CodeAt(e);for(t=e>0?this.src.charCodeAt(e-1):32;d<g&&this.src.charCodeAt(d)===k;' +
')d++;return s=d-e,n=d<g?this.src.charCodeAt(d):32,p=a(t)||i(String.fromCharCode(' +
't)),f=a(n)||i(String.fromCharCode(n)),u=o(t),h=o(n),h?m=!1:f&&(u||p||(m=!1)),u?_' +
'=!1:p&&(h||f||(_=!1)),r?(c=m,l=_):(c=m&&(!_||p),l=_&&(!m||f)),{can_open:c,can_cl' +
'ose:l,length:s}},n.prototype.Token=s,r.exports=n},{"../common/utils":4,"../token' +
'":51}],48:[function(e,r,t){"use strict";r.exports.tokenize=function(e,r){var t,n' +
',s,o,i,a=e.pos,c=e.src.charCodeAt(a);if(r)return!1;if(126!==c)return!1;if(n=e.sc' +
'anDelims(e.pos,!0),o=n.length,i=String.fromCharCode(c),o<2)return!1;for(o%2&&(s=' +
'e.push("text","",0),s.content=i,o--),t=0;t<o;t+=2)s=e.push("text","",0),s.conten' +
't=i+i,e.delimiters.push({marker:c,jump:t,token:e.tokens.length-1,level:e.level,e' +
'nd:-1,open:n.can_open,close:n.can_close});return e.pos+=n.length,!0},r.exports.p' +
'ostProcess=function(e){var r,t,n,s,o,i=[],a=e.delimiters,c=e.delimiters.length;f' +
'or(r=0;r<c;r++)n=a[r],126===n.marker&&n.end!==-1&&(s=a[n.end],o=e.tokens[n.token' +
'],o.type="s_open",o.tag="s",o.nesting=1,o.markup="~~",o.content="",o=e.tokens[s.' +
'token],o.type="s_close",o.tag="s",o.nesting=-1,o.markup="~~",o.content="","text"' +
'===e.tokens[s.token-1].type&&"~"===e.tokens[s.token-1].content&&i.push(s.token-1' +
'));for(;i.length;){for(r=i.pop(),t=r+1;t<e.tokens.length&&"s_close"===e.tokens[t' +
'].type;)t++;t--,r!==t&&(o=e.tokens[t],e.tokens[t]=e.tokens[r],e.tokens[r]=o)}}},' +
'{}],49:[function(e,r,t){"use strict";function n(e){switch(e){case 10:case 33:cas' +
'e 35:case 36:case 37:case 38:case 42:case 43:case 45:case 58:case 60:case 61:cas' +
'e 62:case 64:case 91:case 92:case 93:case 94:case 95:case 96:case 123:case 125:c' +
'ase 126:return!0;default:return!1}}r.exports=function(e,r){for(var t=e.pos;t<e.p' +
'osMax&&!n(e.src.charCodeAt(t));)t++;return t!==e.pos&&(r||(e.pending+=e.src.slic' +
'e(e.pos,t)),e.pos=t,!0)}},{}],50:[function(e,r,t){"use strict";r.exports=functio' +
'n(e){var r,t,n=0,s=e.tokens,o=e.tokens.length;for(r=t=0;r<o;r++)n+=s[r].nesting,' +
's[r].level=n,"text"===s[r].type&&r+1<o&&"text"===s[r+1].type?s[r+1].content=s[r]' +
'.content+s[r+1].content:(r!==t&&(s[t]=s[r]),t++);r!==t&&(s.length=t)}},{}],51:[f' +
'unction(e,r,t){"use strict";function n(e,r,t){this.type=e,this.tag=r,this.attrs=' +
'null,this.map=null,this.nesting=t,this.level=0,this.children=null,this.content="' +
'",this.markup="",this.info="",this.meta=null,this.block=!1,this.hidden=!1}n.prot' +
'otype.attrIndex=function(e){var r,t,n;if(!this.attrs)return-1;for(r=this.attrs,t' +
'=0,n=r.length;t<n;t++)if(r[t][0]===e)return t;return-1},n.prototype.attrPush=fun' +
'ction(e){this.attrs?this.attrs.push(e):this.attrs=[e]},n.prototype.attrSet=funct' +
'ion(e,r){var t=this.attrIndex(e),n=[e,r];t<0?this.attrPush(n):this.attrs[t]=n},n' +
'.prototype.attrGet=function(e){var r=this.attrIndex(e),t=null;return r>=0&&(t=th' +
'is.attrs[r][1]),t},n.prototype.attrJoin=function(e,r){var t=this.attrIndex(e);t<' +
'0?this.attrPush([e,r]):this.attrs[t][1]=this.attrs[t][1]+" "+r},r.exports=n},{}]' +
',52:[function(r,t,n){(function(r){!function(s){function o(e){throw new RangeErro' +
'r(R[e])}function i(e,r){for(var t=e.length,n=[];t--;)n[t]=r(e[t]);return n}funct' +
'ion a(e,r){var t=e.split("@"),n="";t.length>1&&(n=t[0]+"@",e=t[1]),e=e.replace(T' +
',".");var s=e.split("."),o=i(s,r).join(".");return n+o}function c(e){for(var r,t' +
',n=[],s=0,o=e.length;s<o;)r=e.charCodeAt(s++),r>=55296&&r<=56319&&s<o?(t=e.charC' +
'odeAt(s++),56320==(64512&t)?n.push(((1023&r)<<10)+(1023&t)+65536):(n.push(r),s--' +
')):n.push(r);return n}function l(e){return i(e,function(e){var r="";return e>655' +
'35&&(e-=65536,r+=B(e>>>10&1023|55296),e=56320|1023&e),r+=B(e)}).join("")}functio' +
'n u(e){return e-48<10?e-22:e-65<26?e-65:e-97<26?e-97:C}function p(e,r){return e+' +
'22+75*(e<26)-((0!=r)<<5)}function h(e,r,t){var n=0;for(e=t?I(e/q):e>>1,e+=I(e/r)' +
';e>M*w>>1;n+=C)e=I(e/M);return I(n+(M+1)*e/(e+D))}function f(e){var r,t,n,s,i,a,' +
'c,p,f,d,m=[],_=e.length,g=0,k=S,b=E;for(t=e.lastIndexOf(F),t<0&&(t=0),n=0;n<t;++' +
'n)e.charCodeAt(n)>=128&&o("not-basic"),m.push(e.charCodeAt(n));for(s=t>0?t+1:0;s' +
'<_;){for(i=g,a=1,c=C;s>=_&&o("invalid-input"),p=u(e.charCodeAt(s++)),(p>=C||p>I(' +
'(y-g)/a))&&o("overflow"),g+=p*a,f=c<=b?A:c>=b+w?w:c-b,!(p<f);c+=C)d=C-f,a>I(y/d)' +
'&&o("overflow"),a*=d;r=m.length+1,b=h(g-i,r,0==i),I(g/r)>y-k&&o("overflow"),k+=I' +
'(g/r),g%=r,m.splice(g++,0,k)}return l(m)}function d(e){var r,t,n,s,i,a,l,u,f,d,m' +
',_,g,k,b,v=[];for(e=c(e),_=e.length,r=S,t=0,i=E,a=0;a<_;++a)m=e[a],m<128&&v.push' +
'(B(m));for(n=s=v.length,s&&v.push(F);n<_;){for(l=y,a=0;a<_;++a)m=e[a],m>=r&&m<l&' +
'&(l=m);for(g=n+1,l-r>I((y-t)/g)&&o("overflow"),t+=(l-r)*g,r=l,a=0;a<_;++a)if(m=e' +
'[a],m<r&&++t>y&&o("overflow"),m==r){for(u=t,f=C;d=f<=i?A:f>=i+w?w:f-i,!(u<d);f+=' +
'C)b=u-d,k=C-d,v.push(B(p(d+b%k,0))),u=I(b/k);v.push(B(p(u,0))),i=h(t,g,n==s),t=0' +
',++n}++t,++r}return v.join("")}function m(e){return a(e,function(e){return z.tes' +
't(e)?f(e.slice(4).toLowerCase()):e})}function _(e){return a(e,function(e){return' +
' L.test(e)?"xn--"+d(e):e})}var g="object"==typeof n&&n&&!n.nodeType&&n,k="object' +
'"==typeof t&&t&&!t.nodeType&&t,b="object"==typeof r&&r;b.global!==b&&b.window!==' +
'b&&b.self!==b||(s=b);var v,x,y=2147483647,C=36,A=1,w=26,D=38,q=700,E=72,S=128,F=' +
'"-",z=/^xn--/,L=/[^\x20-\x7E]/,T=/[\x2E\u3002\uFF0E\uFF61]/g,R={overflow:"Overfl' +
'ow: input needs wider integers to process","not-basic":"Illegal input >= 0x80 (n' +
'ot a basic code point)","invalid-input":"Invalid input"},M=C-A,I=Math.floor,B=St' +
'ring.fromCharCode;if(v={version:"1.4.1",ucs2:{decode:c,encode:l},decode:f,encode' +
':d,toASCII:_,toUnicode:m},"function"==typeof e&&"object"==typeof e.amd&&e.amd)e(' +
'"punycode",function(){return v});else if(g&&k)if(t.exports==g)k.exports=v;else f' +
'or(x in v)v.hasOwnProperty(x)&&(g[x]=v[x]);else s.punycode=v}(this)}).call(this,' +
'"undefined"!=typeof global?global:"undefined"!=typeof self?self:"undefined"!=typ' +
'eof window?window:{})},{}],53:[function(e,r,t){r.exports={Aacute:"\xc1",aacute:"' +
'\xe1",Abreve:"\u0102",abreve:"\u0103",ac:"\u223e",acd:"\u223f",acE:"\u223e\u0333' +
'",Acirc:"\xc2",acirc:"\xe2",acute:"\xb4",Acy:"\u0410",acy:"\u0430",AElig:"\xc6",' +
'aelig:"\xe6",af:"\u2061",Afr:"\ud835\udd04",afr:"\ud835\udd1e",Agrave:"\xc0",agr' +
'ave:"\xe0",alefsym:"\u2135",aleph:"\u2135",Alpha:"\u0391",alpha:"\u03b1",Amacr:"' +
'\u0100",amacr:"\u0101",amalg:"\u2a3f",amp:"&",AMP:"&",andand:"\u2a55",And:"\u2a5' +
'3",and:"\u2227",andd:"\u2a5c",andslope:"\u2a58",andv:"\u2a5a",ang:"\u2220",ange:' +
'"\u29a4",angle:"\u2220",angmsdaa:"\u29a8",angmsdab:"\u29a9",angmsdac:"\u29aa",an' +
'gmsdad:"\u29ab",angmsdae:"\u29ac",angmsdaf:"\u29ad",angmsdag:"\u29ae",angmsdah:"' +
'\u29af",angmsd:"\u2221",angrt:"\u221f",angrtvb:"\u22be",angrtvbd:"\u299d",angsph' +
':"\u2222",angst:"\xc5",angzarr:"\u237c",Aogon:"\u0104",aogon:"\u0105",Aopf:"\ud8' +
'35\udd38",aopf:"\ud835\udd52",apacir:"\u2a6f",ap:"\u2248",apE:"\u2a70",ape:"\u22' +
'4a",apid:"\u224b",apos:"''",ApplyFunction:"\u2061",approx:"\u2248",approxeq:"\u22' +
'4a",Aring:"\xc5",aring:"\xe5",Ascr:"\ud835\udc9c",ascr:"\ud835\udcb6",Assign:"\u' +
'2254",ast:"*",asymp:"\u2248",asympeq:"\u224d",Atilde:"\xc3",atilde:"\xe3",Auml:"' +
'\xc4",auml:"\xe4",awconint:"\u2233",awint:"\u2a11",backcong:"\u224c",backepsilon' +
':"\u03f6",backprime:"\u2035",backsim:"\u223d",backsimeq:"\u22cd",Backslash:"\u22' +
'16",Barv:"\u2ae7",barvee:"\u22bd",barwed:"\u2305",Barwed:"\u2306",barwedge:"\u23' +
'05",bbrk:"\u23b5",bbrktbrk:"\u23b6",bcong:"\u224c",Bcy:"\u0411",bcy:"\u0431",bdq' +
'uo:"\u201e",becaus:"\u2235",because:"\u2235",Because:"\u2235",bemptyv:"\u29b0",b' +
'epsi:"\u03f6",bernou:"\u212c",Bernoullis:"\u212c",Beta:"\u0392",beta:"\u03b2",be' +
'th:"\u2136",between:"\u226c",Bfr:"\ud835\udd05",bfr:"\ud835\udd1f",bigcap:"\u22c' +
'2",bigcirc:"\u25ef",bigcup:"\u22c3",bigodot:"\u2a00",bigoplus:"\u2a01",bigotimes' +
':"\u2a02",bigsqcup:"\u2a06",bigstar:"\u2605",bigtriangledown:"\u25bd",bigtriangl' +
'eup:"\u25b3",biguplus:"\u2a04",bigvee:"\u22c1",bigwedge:"\u22c0",bkarow:"\u290d"' +
',blacklozenge:"\u29eb",blacksquare:"\u25aa",blacktriangle:"\u25b4",blacktriangle' +
'down:"\u25be",blacktriangleleft:"\u25c2",blacktriangleright:"\u25b8",blank:"\u24' +
'23",blk12:"\u2592",blk14:"\u2591",blk34:"\u2593",block:"\u2588",bne:"=\u20e5",bn' +
'equiv:"\u2261\u20e5",bNot:"\u2aed",bnot:"\u2310",Bopf:"\ud835\udd39",bopf:"\ud83' +
'5\udd53",bot:"\u22a5",bottom:"\u22a5",bowtie:"\u22c8",boxbox:"\u29c9",boxdl:"\u2' +
'510",boxdL:"\u2555",boxDl:"\u2556",boxDL:"\u2557",boxdr:"\u250c",boxdR:"\u2552",' +
'boxDr:"\u2553",boxDR:"\u2554",boxh:"\u2500",boxH:"\u2550",boxhd:"\u252c",boxHd:"' +
'\u2564",boxhD:"\u2565",boxHD:"\u2566",boxhu:"\u2534",boxHu:"\u2567",boxhU:"\u256' +
'8",boxHU:"\u2569",boxminus:"\u229f",boxplus:"\u229e",boxtimes:"\u22a0",boxul:"\u' +
'2518",boxuL:"\u255b",boxUl:"\u255c",boxUL:"\u255d",boxur:"\u2514",boxuR:"\u2558"' +
',boxUr:"\u2559",boxUR:"\u255a",boxv:"\u2502",boxV:"\u2551",boxvh:"\u253c",boxvH:' +
'"\u256a",boxVh:"\u256b",boxVH:"\u256c",boxvl:"\u2524",boxvL:"\u2561",boxVl:"\u25' +
'62",boxVL:"\u2563",boxvr:"\u251c",boxvR:"\u255e",boxVr:"\u255f",boxVR:"\u2560",b' +
'prime:"\u2035",breve:"\u02d8",Breve:"\u02d8",brvbar:"\xa6",bscr:"\ud835\udcb7",B' +
'scr:"\u212c",bsemi:"\u204f",bsim:"\u223d",bsime:"\u22cd",bsolb:"\u29c5",bsol:"\\' +
'",bsolhsub:"\u27c8",bull:"\u2022",bullet:"\u2022",bump:"\u224e",bumpE:"\u2aae",b' +
'umpe:"\u224f",Bumpeq:"\u224e",bumpeq:"\u224f",Cacute:"\u0106",cacute:"\u0107",ca' +
'pand:"\u2a44",capbrcup:"\u2a49",capcap:"\u2a4b",cap:"\u2229",Cap:"\u22d2",capcup' +
':"\u2a47",capdot:"\u2a40",CapitalDifferentialD:"\u2145",caps:"\u2229\ufe00",care' +
't:"\u2041",caron:"\u02c7",Cayleys:"\u212d",ccaps:"\u2a4d",Ccaron:"\u010c",ccaron' +
':"\u010d",Ccedil:"\xc7",ccedil:"\xe7",Ccirc:"\u0108",ccirc:"\u0109",Cconint:"\u2' +
'230",ccups:"\u2a4c",ccupssm:"\u2a50",Cdot:"\u010a",cdot:"\u010b",cedil:"\xb8",Ce' +
'dilla:"\xb8",cemptyv:"\u29b2",cent:"\xa2",centerdot:"\xb7",CenterDot:"\xb7",cfr:' +
'"\ud835\udd20",Cfr:"\u212d",CHcy:"\u0427",chcy:"\u0447",check:"\u2713",checkmark' +
':"\u2713",Chi:"\u03a7",chi:"\u03c7",circ:"\u02c6",circeq:"\u2257",circlearrowlef' +
't:"\u21ba",circlearrowright:"\u21bb",circledast:"\u229b",circledcirc:"\u229a",ci' +
'rcleddash:"\u229d",CircleDot:"\u2299",circledR:"\xae",circledS:"\u24c8",CircleMi' +
'nus:"\u2296",CirclePlus:"\u2295",CircleTimes:"\u2297",cir:"\u25cb",cirE:"\u29c3"' +
',cire:"\u2257",cirfnint:"\u2a10",cirmid:"\u2aef",cirscir:"\u29c2",ClockwiseConto' +
'urIntegral:"\u2232",CloseCurlyDoubleQuote:"\u201d",CloseCurlyQuote:"\u2019",club' +
's:"\u2663",clubsuit:"\u2663",colon:":",Colon:"\u2237",Colone:"\u2a74",colone:"\u' +
'2254",coloneq:"\u2254",comma:",",commat:"@",comp:"\u2201",compfn:"\u2218",comple' +
'ment:"\u2201",complexes:"\u2102",cong:"\u2245",congdot:"\u2a6d",Congruent:"\u226' +
'1",conint:"\u222e",Conint:"\u222f",ContourIntegral:"\u222e",copf:"\ud835\udd54",' +
'Copf:"\u2102",coprod:"\u2210",Coproduct:"\u2210",copy:"\xa9",COPY:"\xa9",copysr:' +
'"\u2117",CounterClockwiseContourIntegral:"\u2233",crarr:"\u21b5",cross:"\u2717",' +
'Cross:"\u2a2f",Cscr:"\ud835\udc9e",cscr:"\ud835\udcb8",csub:"\u2acf",csube:"\u2a' +
'd1",csup:"\u2ad0",csupe:"\u2ad2",ctdot:"\u22ef",cudarrl:"\u2938",cudarrr:"\u2935' +
'",cuepr:"\u22de",cuesc:"\u22df",cularr:"\u21b6",cularrp:"\u293d",cupbrcap:"\u2a4' +
'8",cupcap:"\u2a46",CupCap:"\u224d",cup:"\u222a",Cup:"\u22d3",cupcup:"\u2a4a",cup' +
'dot:"\u228d",cupor:"\u2a45",cups:"\u222a\ufe00",curarr:"\u21b7",curarrm:"\u293c"' +
',curlyeqprec:"\u22de",curlyeqsucc:"\u22df",curlyvee:"\u22ce",curlywedge:"\u22cf"' +
',curren:"\xa4",curvearrowleft:"\u21b6",curvearrowright:"\u21b7",cuvee:"\u22ce",c' +
'uwed:"\u22cf",cwconint:"\u2232",cwint:"\u2231",cylcty:"\u232d",dagger:"\u2020",D' +
'agger:"\u2021",daleth:"\u2138",darr:"\u2193",Darr:"\u21a1",dArr:"\u21d3",dash:"\' +
'u2010",Dashv:"\u2ae4",dashv:"\u22a3",dbkarow:"\u290f",dblac:"\u02dd",Dcaron:"\u0' +
'10e",dcaron:"\u010f",Dcy:"\u0414",dcy:"\u0434",ddagger:"\u2021",ddarr:"\u21ca",D' +
'D:"\u2145",dd:"\u2146",DDotrahd:"\u2911",ddotseq:"\u2a77",deg:"\xb0",Del:"\u2207' +
'",Delta:"\u0394",delta:"\u03b4",demptyv:"\u29b1",dfisht:"\u297f",Dfr:"\ud835\udd' +
'07",dfr:"\ud835\udd21",dHar:"\u2965",dharl:"\u21c3",dharr:"\u21c2",DiacriticalAc' +
'ute:"\xb4",DiacriticalDot:"\u02d9",DiacriticalDoubleAcute:"\u02dd",DiacriticalGr' +
'ave:"`",DiacriticalTilde:"\u02dc",diam:"\u22c4",diamond:"\u22c4",Diamond:"\u22c4' +
'",diamondsuit:"\u2666",diams:"\u2666",die:"\xa8",DifferentialD:"\u2146",digamma:' +
'"\u03dd",disin:"\u22f2",div:"\xf7",divide:"\xf7",divideontimes:"\u22c7",divonx:"' +
'\u22c7",DJcy:"\u0402",djcy:"\u0452",dlcorn:"\u231e",dlcrop:"\u230d",dollar:"$",D' +
'opf:"\ud835\udd3b",dopf:"\ud835\udd55",Dot:"\xa8",dot:"\u02d9",DotDot:"\u20dc",d' +
'oteq:"\u2250",doteqdot:"\u2251",DotEqual:"\u2250",dotminus:"\u2238",dotplus:"\u2' +
'214",dotsquare:"\u22a1",doublebarwedge:"\u2306",DoubleContourIntegral:"\u222f",D' +
'oubleDot:"\xa8",DoubleDownArrow:"\u21d3",DoubleLeftArrow:"\u21d0",DoubleLeftRigh' +
'tArrow:"\u21d4",DoubleLeftTee:"\u2ae4",DoubleLongLeftArrow:"\u27f8",DoubleLongLe' +
'ftRightArrow:"\u27fa",DoubleLongRightArrow:"\u27f9",DoubleRightArrow:"\u21d2",Do' +
'ubleRightTee:"\u22a8",DoubleUpArrow:"\u21d1",DoubleUpDownArrow:"\u21d5",DoubleVe' +
'rticalBar:"\u2225",DownArrowBar:"\u2913",downarrow:"\u2193",DownArrow:"\u2193",D' +
'ownarrow:"\u21d3",DownArrowUpArrow:"\u21f5",DownBreve:"\u0311",downdownarrows:"\' +
'u21ca",downharpoonleft:"\u21c3",downharpoonright:"\u21c2",DownLeftRightVector:"\' +
'u2950",DownLeftTeeVector:"\u295e",DownLeftVectorBar:"\u2956",DownLeftVector:"\u2' +
'1bd",DownRightTeeVector:"\u295f",DownRightVectorBar:"\u2957",DownRightVector:"\u' +
'21c1",DownTeeArrow:"\u21a7",DownTee:"\u22a4",drbkarow:"\u2910",drcorn:"\u231f",d' +
'rcrop:"\u230c",Dscr:"\ud835\udc9f",dscr:"\ud835\udcb9",DScy:"\u0405",dscy:"\u045' +
'5",dsol:"\u29f6",Dstrok:"\u0110",dstrok:"\u0111",dtdot:"\u22f1",dtri:"\u25bf",dt' +
'rif:"\u25be",duarr:"\u21f5",duhar:"\u296f",dwangle:"\u29a6",DZcy:"\u040f",dzcy:"' +
'\u045f",dzigrarr:"\u27ff",Eacute:"\xc9",eacute:"\xe9",easter:"\u2a6e",Ecaron:"\u' +
'011a",ecaron:"\u011b",Ecirc:"\xca",ecirc:"\xea",ecir:"\u2256",ecolon:"\u2255",Ec' +
'y:"\u042d",ecy:"\u044d",eDDot:"\u2a77",Edot:"\u0116",edot:"\u0117",eDot:"\u2251"' +
',ee:"\u2147",efDot:"\u2252",Efr:"\ud835\udd08",efr:"\ud835\udd22",eg:"\u2a9a",Eg' +
'rave:"\xc8",egrave:"\xe8",egs:"\u2a96",egsdot:"\u2a98",el:"\u2a99",Element:"\u22' +
'08",elinters:"\u23e7",ell:"\u2113",els:"\u2a95",elsdot:"\u2a97",Emacr:"\u0112",e' +
'macr:"\u0113",empty:"\u2205",emptyset:"\u2205",EmptySmallSquare:"\u25fb",emptyv:' +
'"\u2205",EmptyVerySmallSquare:"\u25ab",emsp13:"\u2004",emsp14:"\u2005",emsp:"\u2' +
'003",ENG:"\u014a",eng:"\u014b",ensp:"\u2002",Eogon:"\u0118",eogon:"\u0119",Eopf:' +
'"\ud835\udd3c",eopf:"\ud835\udd56",epar:"\u22d5",eparsl:"\u29e3",eplus:"\u2a71",' +
'epsi:"\u03b5",Epsilon:"\u0395",epsilon:"\u03b5",epsiv:"\u03f5",eqcirc:"\u2256",e' +
'qcolon:"\u2255",eqsim:"\u2242",eqslantgtr:"\u2a96",eqslantless:"\u2a95",Equal:"\' +
'u2a75",equals:"=",EqualTilde:"\u2242",equest:"\u225f",Equilibrium:"\u21cc",equiv' +
':"\u2261",equivDD:"\u2a78",eqvparsl:"\u29e5",erarr:"\u2971",erDot:"\u2253",escr:' +
'"\u212f",Escr:"\u2130",esdot:"\u2250",Esim:"\u2a73",esim:"\u2242",Eta:"\u0397",e' +
'ta:"\u03b7",ETH:"\xd0",eth:"\xf0",Euml:"\xcb",euml:"\xeb",euro:"\u20ac",excl:"!"' +
',exist:"\u2203",Exists:"\u2203",expectation:"\u2130",exponentiale:"\u2147",Expon' +
'entialE:"\u2147",fallingdotseq:"\u2252",Fcy:"\u0424",fcy:"\u0444",female:"\u2640' +
'",ffilig:"\ufb03",fflig:"\ufb00",ffllig:"\ufb04",Ffr:"\ud835\udd09",ffr:"\ud835\' +
'udd23",filig:"\ufb01",FilledSmallSquare:"\u25fc",FilledVerySmallSquare:"\u25aa",' +
'fjlig:"fj",flat:"\u266d",fllig:"\ufb02",fltns:"\u25b1",fnof:"\u0192",Fopf:"\ud83' +
'5\udd3d",fopf:"\ud835\udd57",forall:"\u2200",ForAll:"\u2200",fork:"\u22d4",forkv' +
':"\u2ad9",Fouriertrf:"\u2131",fpartint:"\u2a0d",frac12:"\xbd",frac13:"\u2153",fr' +
'ac14:"\xbc",frac15:"\u2155",frac16:"\u2159",frac18:"\u215b",frac23:"\u2154",frac' +
'25:"\u2156",frac34:"\xbe",frac35:"\u2157",frac38:"\u215c",frac45:"\u2158",frac56' +
':"\u215a",frac58:"\u215d",frac78:"\u215e",frasl:"\u2044",frown:"\u2322",fscr:"\u' +
'd835\udcbb",Fscr:"\u2131",gacute:"\u01f5",Gamma:"\u0393",gamma:"\u03b3",Gammad:"' +
'\u03dc",gammad:"\u03dd",gap:"\u2a86",Gbreve:"\u011e",gbreve:"\u011f",Gcedil:"\u0' +
'122",Gcirc:"\u011c",gcirc:"\u011d",Gcy:"\u0413",gcy:"\u0433",Gdot:"\u0120",gdot:' +
'"\u0121",ge:"\u2265",gE:"\u2267",gEl:"\u2a8c",gel:"\u22db",geq:"\u2265",geqq:"\u' +
'2267",geqslant:"\u2a7e",gescc:"\u2aa9",ges:"\u2a7e",gesdot:"\u2a80",gesdoto:"\u2' +
'a82",gesdotol:"\u2a84",gesl:"\u22db\ufe00",gesles:"\u2a94",Gfr:"\ud835\udd0a",gf' +
'r:"\ud835\udd24",gg:"\u226b",Gg:"\u22d9",ggg:"\u22d9",gimel:"\u2137",GJcy:"\u040' +
'3",gjcy:"\u0453",gla:"\u2aa5",gl:"\u2277",glE:"\u2a92",glj:"\u2aa4",gnap:"\u2a8a' +
'",gnapprox:"\u2a8a",gne:"\u2a88",gnE:"\u2269",gneq:"\u2a88",gneqq:"\u2269",gnsim' +
':"\u22e7",Gopf:"\ud835\udd3e",gopf:"\ud835\udd58",grave:"`",GreaterEqual:"\u2265' +
'",GreaterEqualLess:"\u22db",GreaterFullEqual:"\u2267",GreaterGreater:"\u2aa2",Gr' +
'eaterLess:"\u2277",GreaterSlantEqual:"\u2a7e",GreaterTilde:"\u2273",Gscr:"\ud835' +
'\udca2",gscr:"\u210a",gsim:"\u2273",gsime:"\u2a8e",gsiml:"\u2a90",gtcc:"\u2aa7",' +
'gtcir:"\u2a7a",gt:">",GT:">",Gt:"\u226b",gtdot:"\u22d7",gtlPar:"\u2995",gtquest:' +
'"\u2a7c",gtrapprox:"\u2a86",gtrarr:"\u2978",gtrdot:"\u22d7",gtreqless:"\u22db",g' +
'treqqless:"\u2a8c",gtrless:"\u2277",gtrsim:"\u2273",gvertneqq:"\u2269\ufe00",gvn' +
'E:"\u2269\ufe00",Hacek:"\u02c7",hairsp:"\u200a",half:"\xbd",hamilt:"\u210b",HARD' +
'cy:"\u042a",hardcy:"\u044a",harrcir:"\u2948",harr:"\u2194",hArr:"\u21d4",harrw:"' +
'\u21ad",Hat:"^",hbar:"\u210f",Hcirc:"\u0124",hcirc:"\u0125",hearts:"\u2665",hear' +
'tsuit:"\u2665",hellip:"\u2026",hercon:"\u22b9",hfr:"\ud835\udd25",Hfr:"\u210c",H' +
'ilbertSpace:"\u210b",hksearow:"\u2925",hkswarow:"\u2926",hoarr:"\u21ff",homtht:"' +
'\u223b",hookleftarrow:"\u21a9",hookrightarrow:"\u21aa",hopf:"\ud835\udd59",Hopf:' +
'"\u210d",horbar:"\u2015",HorizontalLine:"\u2500",hscr:"\ud835\udcbd",Hscr:"\u210' +
'b", ' +
'hslash:"\u210f",Hstrok:"\u0126",hstrok:"\u0127",HumpDownHump:"\u224e",HumpEqual:' +
'"\u224f",hybull:"\u2043",hyphen:"\u2010",Iacute:"\xcd",iacute:"\xed",ic:"\u2063"' +
',Icirc:"\xce",icirc:"\xee",Icy:"\u0418",icy:"\u0438",Idot:"\u0130",IEcy:"\u0415"' +
',iecy:"\u0435",iexcl:"\xa1",iff:"\u21d4",ifr:"\ud835\udd26",Ifr:"\u2111",Igrave:' +
'"\xcc",igrave:"\xec",ii:"\u2148",iiiint:"\u2a0c",iiint:"\u222d",iinfin:"\u29dc",' +
'iiota:"\u2129",IJlig:"\u0132",ijlig:"\u0133",Imacr:"\u012a",imacr:"\u012b",image' +
':"\u2111",ImaginaryI:"\u2148",imagline:"\u2110",imagpart:"\u2111",imath:"\u0131"' +
',Im:"\u2111",imof:"\u22b7",imped:"\u01b5",Implies:"\u21d2",incare:"\u2105","in":' +
'"\u2208",infin:"\u221e",infintie:"\u29dd",inodot:"\u0131",intcal:"\u22ba","int":' +
'"\u222b",Int:"\u222c",integers:"\u2124",Integral:"\u222b",intercal:"\u22ba",Inte' +
'rsection:"\u22c2",intlarhk:"\u2a17",intprod:"\u2a3c",InvisibleComma:"\u2063",Inv' +
'isibleTimes:"\u2062",IOcy:"\u0401",iocy:"\u0451",Iogon:"\u012e",iogon:"\u012f",I' +
'opf:"\ud835\udd40",iopf:"\ud835\udd5a",Iota:"\u0399",iota:"\u03b9",iprod:"\u2a3c' +
'",iquest:"\xbf",iscr:"\ud835\udcbe",Iscr:"\u2110",isin:"\u2208",isindot:"\u22f5"' +
',isinE:"\u22f9",isins:"\u22f4",isinsv:"\u22f3",isinv:"\u2208",it:"\u2062",Itilde' +
':"\u0128",itilde:"\u0129",Iukcy:"\u0406",iukcy:"\u0456",Iuml:"\xcf",iuml:"\xef",' +
'Jcirc:"\u0134",jcirc:"\u0135",Jcy:"\u0419",jcy:"\u0439",Jfr:"\ud835\udd0d",jfr:"' +
'\ud835\udd27",jmath:"\u0237",Jopf:"\ud835\udd41",jopf:"\ud835\udd5b",Jscr:"\ud83' +
'5\udca5",jscr:"\ud835\udcbf",Jsercy:"\u0408",jsercy:"\u0458",Jukcy:"\u0404",jukc' +
'y:"\u0454",Kappa:"\u039a",kappa:"\u03ba",kappav:"\u03f0",Kcedil:"\u0136",kcedil:' +
'"\u0137",Kcy:"\u041a",kcy:"\u043a",Kfr:"\ud835\udd0e",kfr:"\ud835\udd28",kgreen:' +
'"\u0138",KHcy:"\u0425",khcy:"\u0445",KJcy:"\u040c",kjcy:"\u045c",Kopf:"\ud835\ud' +
'd42",kopf:"\ud835\udd5c",Kscr:"\ud835\udca6",kscr:"\ud835\udcc0",lAarr:"\u21da",' +
'Lacute:"\u0139",lacute:"\u013a",laemptyv:"\u29b4",lagran:"\u2112",Lambda:"\u039b' +
'",lambda:"\u03bb",lang:"\u27e8",Lang:"\u27ea",langd:"\u2991",langle:"\u27e8",lap' +
':"\u2a85",Laplacetrf:"\u2112",laquo:"\xab",larrb:"\u21e4",larrbfs:"\u291f",larr:' +
'"\u2190",Larr:"\u219e",lArr:"\u21d0",larrfs:"\u291d",larrhk:"\u21a9",larrlp:"\u2' +
'1ab",larrpl:"\u2939",larrsim:"\u2973",larrtl:"\u21a2",latail:"\u2919",lAtail:"\u' +
'291b",lat:"\u2aab",late:"\u2aad",lates:"\u2aad\ufe00",lbarr:"\u290c",lBarr:"\u29' +
'0e",lbbrk:"\u2772",lbrace:"{",lbrack:"[",lbrke:"\u298b",lbrksld:"\u298f",lbrkslu' +
':"\u298d",Lcaron:"\u013d",lcaron:"\u013e",Lcedil:"\u013b",lcedil:"\u013c",lceil:' +
'"\u2308",lcub:"{",Lcy:"\u041b",lcy:"\u043b",ldca:"\u2936",ldquo:"\u201c",ldquor:' +
'"\u201e",ldrdhar:"\u2967",ldrushar:"\u294b",ldsh:"\u21b2",le:"\u2264",lE:"\u2266' +
'",LeftAngleBracket:"\u27e8",LeftArrowBar:"\u21e4",leftarrow:"\u2190",LeftArrow:"' +
'\u2190",Leftarrow:"\u21d0",LeftArrowRightArrow:"\u21c6",leftarrowtail:"\u21a2",L' +
'eftCeiling:"\u2308",LeftDoubleBracket:"\u27e6",LeftDownTeeVector:"\u2961",LeftDo' +
'wnVectorBar:"\u2959",LeftDownVector:"\u21c3",LeftFloor:"\u230a",leftharpoondown:' +
'"\u21bd",leftharpoonup:"\u21bc",leftleftarrows:"\u21c7",leftrightarrow:"\u2194",' +
'LeftRightArrow:"\u2194",Leftrightarrow:"\u21d4",leftrightarrows:"\u21c6",leftrig' +
'htharpoons:"\u21cb",leftrightsquigarrow:"\u21ad",LeftRightVector:"\u294e",LeftTe' +
'eArrow:"\u21a4",LeftTee:"\u22a3",LeftTeeVector:"\u295a",leftthreetimes:"\u22cb",' +
'LeftTriangleBar:"\u29cf",LeftTriangle:"\u22b2",LeftTriangleEqual:"\u22b4",LeftUp' +
'DownVector:"\u2951",LeftUpTeeVector:"\u2960",LeftUpVectorBar:"\u2958",LeftUpVect' +
'or:"\u21bf",LeftVectorBar:"\u2952",LeftVector:"\u21bc",lEg:"\u2a8b",leg:"\u22da"' +
',leq:"\u2264",leqq:"\u2266",leqslant:"\u2a7d",lescc:"\u2aa8",les:"\u2a7d",lesdot' +
':"\u2a7f",lesdoto:"\u2a81",lesdotor:"\u2a83",lesg:"\u22da\ufe00",lesges:"\u2a93"' +
',lessapprox:"\u2a85",lessdot:"\u22d6",lesseqgtr:"\u22da",lesseqqgtr:"\u2a8b",Les' +
'sEqualGreater:"\u22da",LessFullEqual:"\u2266",LessGreater:"\u2276",lessgtr:"\u22' +
'76",LessLess:"\u2aa1",lesssim:"\u2272",LessSlantEqual:"\u2a7d",LessTilde:"\u2272' +
'",lfisht:"\u297c",lfloor:"\u230a",Lfr:"\ud835\udd0f",lfr:"\ud835\udd29",lg:"\u22' +
'76",lgE:"\u2a91",lHar:"\u2962",lhard:"\u21bd",lharu:"\u21bc",lharul:"\u296a",lhb' +
'lk:"\u2584",LJcy:"\u0409",ljcy:"\u0459",llarr:"\u21c7",ll:"\u226a",Ll:"\u22d8",l' +
'lcorner:"\u231e",Lleftarrow:"\u21da",llhard:"\u296b",lltri:"\u25fa",Lmidot:"\u01' +
'3f",lmidot:"\u0140",lmoustache:"\u23b0",lmoust:"\u23b0",lnap:"\u2a89",lnapprox:"' +
'\u2a89",lne:"\u2a87",lnE:"\u2268",lneq:"\u2a87",lneqq:"\u2268",lnsim:"\u22e6",lo' +
'ang:"\u27ec",loarr:"\u21fd",lobrk:"\u27e6",longleftarrow:"\u27f5",LongLeftArrow:' +
'"\u27f5",Longleftarrow:"\u27f8",longleftrightarrow:"\u27f7",LongLeftRightArrow:"' +
'\u27f7",Longleftrightarrow:"\u27fa",longmapsto:"\u27fc",longrightarrow:"\u27f6",' +
'LongRightArrow:"\u27f6",Longrightarrow:"\u27f9",looparrowleft:"\u21ab",looparrow' +
'right:"\u21ac",lopar:"\u2985",Lopf:"\ud835\udd43",lopf:"\ud835\udd5d",loplus:"\u' +
'2a2d",lotimes:"\u2a34",lowast:"\u2217",lowbar:"_",LowerLeftArrow:"\u2199",LowerR' +
'ightArrow:"\u2198",loz:"\u25ca",lozenge:"\u25ca",lozf:"\u29eb",lpar:"(",lparlt:"' +
'\u2993",lrarr:"\u21c6",lrcorner:"\u231f",lrhar:"\u21cb",lrhard:"\u296d",lrm:"\u2' +
'00e",lrtri:"\u22bf",lsaquo:"\u2039",lscr:"\ud835\udcc1",Lscr:"\u2112",lsh:"\u21b' +
'0",Lsh:"\u21b0",lsim:"\u2272",lsime:"\u2a8d",lsimg:"\u2a8f",lsqb:"[",lsquo:"\u20' +
'18",lsquor:"\u201a",Lstrok:"\u0141",lstrok:"\u0142",ltcc:"\u2aa6",ltcir:"\u2a79"' +
',lt:"<",LT:"<",Lt:"\u226a",ltdot:"\u22d6",lthree:"\u22cb",ltimes:"\u22c9",ltlarr' +
':"\u2976",ltquest:"\u2a7b",ltri:"\u25c3",ltrie:"\u22b4",ltrif:"\u25c2",ltrPar:"\' +
'u2996",lurdshar:"\u294a",luruhar:"\u2966",lvertneqq:"\u2268\ufe00",lvnE:"\u2268\' +
'ufe00",macr:"\xaf",male:"\u2642",malt:"\u2720",maltese:"\u2720",Map:"\u2905",map' +
':"\u21a6",mapsto:"\u21a6",mapstodown:"\u21a7",mapstoleft:"\u21a4",mapstoup:"\u21' +
'a5",marker:"\u25ae",mcomma:"\u2a29",Mcy:"\u041c",mcy:"\u043c",mdash:"\u2014",mDD' +
'ot:"\u223a",measuredangle:"\u2221",MediumSpace:"\u205f",Mellintrf:"\u2133",Mfr:"' +
'\ud835\udd10",mfr:"\ud835\udd2a",mho:"\u2127",micro:"\xb5",midast:"*",midcir:"\u' +
'2af0",mid:"\u2223",middot:"\xb7",minusb:"\u229f",minus:"\u2212",minusd:"\u2238",' +
'minusdu:"\u2a2a",MinusPlus:"\u2213",mlcp:"\u2adb",mldr:"\u2026",mnplus:"\u2213",' +
'models:"\u22a7",Mopf:"\ud835\udd44",mopf:"\ud835\udd5e",mp:"\u2213",mscr:"\ud835' +
'\udcc2",Mscr:"\u2133",mstpos:"\u223e",Mu:"\u039c",mu:"\u03bc",multimap:"\u22b8",' +
'mumap:"\u22b8",nabla:"\u2207",Nacute:"\u0143",nacute:"\u0144",nang:"\u2220\u20d2' +
'",nap:"\u2249",napE:"\u2a70\u0338",napid:"\u224b\u0338",napos:"\u0149",napprox:"' +
'\u2249",natural:"\u266e",naturals:"\u2115",natur:"\u266e",nbsp:"\xa0",nbump:"\u2' +
'24e\u0338",nbumpe:"\u224f\u0338",ncap:"\u2a43",Ncaron:"\u0147",ncaron:"\u0148",N' +
'cedil:"\u0145",ncedil:"\u0146",ncong:"\u2247",ncongdot:"\u2a6d\u0338",ncup:"\u2a' +
'42",Ncy:"\u041d",ncy:"\u043d",ndash:"\u2013",nearhk:"\u2924",nearr:"\u2197",neAr' +
'r:"\u21d7",nearrow:"\u2197",ne:"\u2260",nedot:"\u2250\u0338",NegativeMediumSpace' +
':"\u200b",NegativeThickSpace:"\u200b",NegativeThinSpace:"\u200b",NegativeVeryThi' +
'nSpace:"\u200b",nequiv:"\u2262",nesear:"\u2928",nesim:"\u2242\u0338",NestedGreat' +
'erGreater:"\u226b",NestedLessLess:"\u226a",NewLine:"\n",nexist:"\u2204",nexists:' +
'"\u2204",Nfr:"\ud835\udd11",nfr:"\ud835\udd2b",ngE:"\u2267\u0338",nge:"\u2271",n' +
'geq:"\u2271",ngeqq:"\u2267\u0338",ngeqslant:"\u2a7e\u0338",nges:"\u2a7e\u0338",n' +
'Gg:"\u22d9\u0338",ngsim:"\u2275",nGt:"\u226b\u20d2",ngt:"\u226f",ngtr:"\u226f",n' +
'Gtv:"\u226b\u0338",nharr:"\u21ae",nhArr:"\u21ce",nhpar:"\u2af2",ni:"\u220b",nis:' +
'"\u22fc",nisd:"\u22fa",niv:"\u220b",NJcy:"\u040a",njcy:"\u045a",nlarr:"\u219a",n' +
'lArr:"\u21cd",nldr:"\u2025",nlE:"\u2266\u0338",nle:"\u2270",nleftarrow:"\u219a",' +
'nLeftarrow:"\u21cd",nleftrightarrow:"\u21ae",nLeftrightarrow:"\u21ce",nleq:"\u22' +
'70",nleqq:"\u2266\u0338",nleqslant:"\u2a7d\u0338",nles:"\u2a7d\u0338",nless:"\u2' +
'26e",nLl:"\u22d8\u0338",nlsim:"\u2274",nLt:"\u226a\u20d2",nlt:"\u226e",nltri:"\u' +
'22ea",nltrie:"\u22ec",nLtv:"\u226a\u0338",nmid:"\u2224",NoBreak:"\u2060",NonBrea' +
'kingSpace:"\xa0",nopf:"\ud835\udd5f",Nopf:"\u2115",Not:"\u2aec",not:"\xac",NotCo' +
'ngruent:"\u2262",NotCupCap:"\u226d",NotDoubleVerticalBar:"\u2226",NotElement:"\u' +
'2209",NotEqual:"\u2260",NotEqualTilde:"\u2242\u0338",NotExists:"\u2204",NotGreat' +
'er:"\u226f",NotGreaterEqual:"\u2271",NotGreaterFullEqual:"\u2267\u0338",NotGreat' +
'erGreater:"\u226b\u0338",NotGreaterLess:"\u2279",NotGreaterSlantEqual:"\u2a7e\u0' +
'338",NotGreaterTilde:"\u2275",NotHumpDownHump:"\u224e\u0338",NotHumpEqual:"\u224' +
'f\u0338",notin:"\u2209",notindot:"\u22f5\u0338",notinE:"\u22f9\u0338",notinva:"\' +
'u2209",notinvb:"\u22f7",notinvc:"\u22f6",NotLeftTriangleBar:"\u29cf\u0338",NotLe' +
'ftTriangle:"\u22ea",NotLeftTriangleEqual:"\u22ec",NotLess:"\u226e",NotLessEqual:' +
'"\u2270",NotLessGreater:"\u2278",NotLessLess:"\u226a\u0338",NotLessSlantEqual:"\' +
'u2a7d\u0338",NotLessTilde:"\u2274",NotNestedGreaterGreater:"\u2aa2\u0338",NotNes' +
'tedLessLess:"\u2aa1\u0338",notni:"\u220c",notniva:"\u220c",notnivb:"\u22fe",notn' +
'ivc:"\u22fd",NotPrecedes:"\u2280",NotPrecedesEqual:"\u2aaf\u0338",NotPrecedesSla' +
'ntEqual:"\u22e0",NotReverseElement:"\u220c",NotRightTriangleBar:"\u29d0\u0338",N' +
'otRightTriangle:"\u22eb",NotRightTriangleEqual:"\u22ed",NotSquareSubset:"\u228f\' +
'u0338",NotSquareSubsetEqual:"\u22e2",NotSquareSuperset:"\u2290\u0338",NotSquareS' +
'upersetEqual:"\u22e3",NotSubset:"\u2282\u20d2",NotSubsetEqual:"\u2288",NotSuccee' +
'ds:"\u2281",NotSucceedsEqual:"\u2ab0\u0338",NotSucceedsSlantEqual:"\u22e1",NotSu' +
'cceedsTilde:"\u227f\u0338",NotSuperset:"\u2283\u20d2",NotSupersetEqual:"\u2289",' +
'NotTilde:"\u2241",NotTildeEqual:"\u2244",NotTildeFullEqual:"\u2247",NotTildeTild' +
'e:"\u2249",NotVerticalBar:"\u2224",nparallel:"\u2226",npar:"\u2226",nparsl:"\u2a' +
'fd\u20e5",npart:"\u2202\u0338",npolint:"\u2a14",npr:"\u2280",nprcue:"\u22e0",npr' +
'ec:"\u2280",npreceq:"\u2aaf\u0338",npre:"\u2aaf\u0338",nrarrc:"\u2933\u0338",nra' +
'rr:"\u219b",nrArr:"\u21cf",nrarrw:"\u219d\u0338",nrightarrow:"\u219b",nRightarro' +
'w:"\u21cf",nrtri:"\u22eb",nrtrie:"\u22ed",nsc:"\u2281",nsccue:"\u22e1",nsce:"\u2' +
'ab0\u0338",Nscr:"\ud835\udca9",nscr:"\ud835\udcc3",nshortmid:"\u2224",nshortpara' +
'llel:"\u2226",nsim:"\u2241",nsime:"\u2244",nsimeq:"\u2244",nsmid:"\u2224",nspar:' +
'"\u2226",nsqsube:"\u22e2",nsqsupe:"\u22e3",nsub:"\u2284",nsubE:"\u2ac5\u0338",ns' +
'ube:"\u2288",nsubset:"\u2282\u20d2",nsubseteq:"\u2288",nsubseteqq:"\u2ac5\u0338"' +
',nsucc:"\u2281",nsucceq:"\u2ab0\u0338",nsup:"\u2285",nsupE:"\u2ac6\u0338",nsupe:' +
'"\u2289",nsupset:"\u2283\u20d2",nsupseteq:"\u2289",nsupseteqq:"\u2ac6\u0338",ntg' +
'l:"\u2279",Ntilde:"\xd1",ntilde:"\xf1",ntlg:"\u2278",ntriangleleft:"\u22ea",ntri' +
'anglelefteq:"\u22ec",ntriangleright:"\u22eb",ntrianglerighteq:"\u22ed",Nu:"\u039' +
'd",nu:"\u03bd",num:"#",numero:"\u2116",numsp:"\u2007",nvap:"\u224d\u20d2",nvdash' +
':"\u22ac",nvDash:"\u22ad",nVdash:"\u22ae",nVDash:"\u22af",nvge:"\u2265\u20d2",nv' +
'gt:">\u20d2",nvHarr:"\u2904",nvinfin:"\u29de",nvlArr:"\u2902",nvle:"\u2264\u20d2' +
'",nvlt:"<\u20d2",nvltrie:"\u22b4\u20d2",nvrArr:"\u2903",nvrtrie:"\u22b5\u20d2",n' +
'vsim:"\u223c\u20d2",nwarhk:"\u2923",nwarr:"\u2196",nwArr:"\u21d6",nwarrow:"\u219' +
'6",nwnear:"\u2927",Oacute:"\xd3",oacute:"\xf3",oast:"\u229b",Ocirc:"\xd4",ocirc:' +
'"\xf4",ocir:"\u229a",Ocy:"\u041e",ocy:"\u043e",odash:"\u229d",Odblac:"\u0150",od' +
'blac:"\u0151",odiv:"\u2a38",odot:"\u2299",odsold:"\u29bc",OElig:"\u0152",oelig:"' +
'\u0153",ofcir:"\u29bf",Ofr:"\ud835\udd12",ofr:"\ud835\udd2c",ogon:"\u02db",Ograv' +
'e:"\xd2",ograve:"\xf2",ogt:"\u29c1",ohbar:"\u29b5",ohm:"\u03a9",oint:"\u222e",ol' +
'arr:"\u21ba",olcir:"\u29be",olcross:"\u29bb",oline:"\u203e",olt:"\u29c0",Omacr:"' +
'\u014c",omacr:"\u014d",Omega:"\u03a9",omega:"\u03c9",Omicron:"\u039f",omicron:"\' +
'u03bf",omid:"\u29b6",ominus:"\u2296",Oopf:"\ud835\udd46",oopf:"\ud835\udd60",opa' +
'r:"\u29b7",OpenCurlyDoubleQuote:"\u201c",OpenCurlyQuote:"\u2018",operp:"\u29b9",' +
'oplus:"\u2295",orarr:"\u21bb",Or:"\u2a54",or:"\u2228",ord:"\u2a5d",order:"\u2134' +
'",orderof:"\u2134",ordf:"\xaa",ordm:"\xba",origof:"\u22b6",oror:"\u2a56",orslope' +
':"\u2a57",orv:"\u2a5b",oS:"\u24c8",Oscr:"\ud835\udcaa",oscr:"\u2134",Oslash:"\xd' +
'8",oslash:"\xf8",osol:"\u2298",Otilde:"\xd5",otilde:"\xf5",otimesas:"\u2a36",Oti' +
'mes:"\u2a37",otimes:"\u2297",Ouml:"\xd6",ouml:"\xf6",ovbar:"\u233d",OverBar:"\u2' +
'03e",OverBrace:"\u23de",OverBracket:"\u23b4",OverParenthesis:"\u23dc",para:"\xb6' +
'",parallel:"\u2225",par:"\u2225",parsim:"\u2af3",parsl:"\u2afd",part:"\u2202",Pa' +
'rtialD:"\u2202",Pcy:"\u041f",pcy:"\u043f",percnt:"%",period:".",permil:"\u2030",' +
'perp:"\u22a5",pertenk:"\u2031",Pfr:"\ud835\udd13",pfr:"\ud835\udd2d",Phi:"\u03a6' +
'",phi:"\u03c6",phiv:"\u03d5",phmmat:"\u2133",phone:"\u260e",Pi:"\u03a0",pi:"\u03' +
'c0",pitchfork:"\u22d4",piv:"\u03d6",planck:"\u210f",planckh:"\u210e",plankv:"\u2' +
'10f",plusacir:"\u2a23",plusb:"\u229e",pluscir:"\u2a22",plus:"+",plusdo:"\u2214",' +
'plusdu:"\u2a25",pluse:"\u2a72",PlusMinus:"\xb1",plusmn:"\xb1",plussim:"\u2a26",p' +
'lustwo:"\u2a27",pm:"\xb1",Poincareplane:"\u210c",pointint:"\u2a15",popf:"\ud835\' +
'udd61",Popf:"\u2119",pound:"\xa3",prap:"\u2ab7",Pr:"\u2abb",pr:"\u227a",prcue:"\' +
'u227c",precapprox:"\u2ab7",prec:"\u227a",preccurlyeq:"\u227c",Precedes:"\u227a",' +
'PrecedesEqual:"\u2aaf",PrecedesSlantEqual:"\u227c",PrecedesTilde:"\u227e",preceq' +
':"\u2aaf",precnapprox:"\u2ab9",precneqq:"\u2ab5",precnsim:"\u22e8",pre:"\u2aaf",' +
'prE:"\u2ab3",precsim:"\u227e",prime:"\u2032",Prime:"\u2033",primes:"\u2119",prna' +
'p:"\u2ab9",prnE:"\u2ab5",prnsim:"\u22e8",prod:"\u220f",Product:"\u220f",profalar' +
':"\u232e",profline:"\u2312",profsurf:"\u2313",prop:"\u221d",Proportional:"\u221d' +
'",Proportion:"\u2237",propto:"\u221d",prsim:"\u227e",prurel:"\u22b0",Pscr:"\ud83' +
'5\udcab",pscr:"\ud835\udcc5",Psi:"\u03a8",psi:"\u03c8",puncsp:"\u2008",Qfr:"\ud8' +
'35\udd14",qfr:"\ud835\udd2e",qint:"\u2a0c",qopf:"\ud835\udd62",Qopf:"\u211a",qpr' +
'ime:"\u2057",Qscr:"\ud835\udcac",qscr:"\ud835\udcc6",quaternions:"\u210d",quatin' +
't:"\u2a16",quest:"?",questeq:"\u225f",quot:''"'',QUOT:''"'',rAarr:"\u21db",race:"\u2' +
'23d\u0331",Racute:"\u0154",racute:"\u0155",radic:"\u221a",raemptyv:"\u29b3",rang' +
':"\u27e9",Rang:"\u27eb",rangd:"\u2992",range:"\u29a5",rangle:"\u27e9",raquo:"\xb' +
'b",rarrap:"\u2975",rarrb:"\u21e5",rarrbfs:"\u2920",rarrc:"\u2933",rarr:"\u2192",' +
'Rarr:"\u21a0",rArr:"\u21d2",rarrfs:"\u291e",rarrhk:"\u21aa",rarrlp:"\u21ac",rarr' +
'pl:"\u2945",rarrsim:"\u2974",Rarrtl:"\u2916",rarrtl:"\u21a3",rarrw:"\u219d",rata' +
'il:"\u291a",rAtail:"\u291c",ratio:"\u2236",rationals:"\u211a",rbarr:"\u290d",rBa' +
'rr:"\u290f",RBarr:"\u2910",rbbrk:"\u2773",rbrace:"}",rbrack:"]",rbrke:"\u298c",r' +
'brksld:"\u298e",rbrkslu:"\u2990",Rcaron:"\u0158",rcaron:"\u0159",Rcedil:"\u0156"' +
',rcedil:"\u0157",rceil:"\u2309",rcub:"}",Rcy:"\u0420",rcy:"\u0440",rdca:"\u2937"' +
',rdldhar:"\u2969",rdquo:"\u201d",rdquor:"\u201d",rdsh:"\u21b3",real:"\u211c",rea' +
'line:"\u211b",realpart:"\u211c",reals:"\u211d",Re:"\u211c",rect:"\u25ad",reg:"\x' +
'ae",REG:"\xae",ReverseElement:"\u220b",ReverseEquilibrium:"\u21cb",ReverseUpEqui' +
'librium:"\u296f",rfisht:"\u297d",rfloor:"\u230b",rfr:"\ud835\udd2f",Rfr:"\u211c"' +
',rHar:"\u2964",rhard:"\u21c1",rharu:"\u21c0",rharul:"\u296c",Rho:"\u03a1",rho:"\' +
'u03c1",rhov:"\u03f1",RightAngleBracket:"\u27e9",RightArrowBar:"\u21e5",rightarro' +
'w:"\u2192",RightArrow:"\u2192",Rightarrow:"\u21d2",RightArrowLeftArrow:"\u21c4",' +
'rightarrowtail:"\u21a3",RightCeiling:"\u2309",RightDoubleBracket:"\u27e7",RightD' +
'ownTeeVector:"\u295d",RightDownVectorBar:"\u2955",RightDownVector:"\u21c2",Right' +
'Floor:"\u230b",rightharpoondown:"\u21c1",rightharpoonup:"\u21c0",rightleftarrows' +
':"\u21c4",rightleftharpoons:"\u21cc",rightrightarrows:"\u21c9",rightsquigarrow:"' +
'\u219d",RightTeeArrow:"\u21a6",RightTee:"\u22a2",RightTeeVector:"\u295b",rightth' +
'reetimes:"\u22cc",RightTriangleBar:"\u29d0",RightTriangle:"\u22b3",RightTriangle' +
'Equal:"\u22b5",RightUpDownVector:"\u294f",RightUpTeeVector:"\u295c",RightUpVecto' +
'rBar:"\u2954",RightUpVector:"\u21be",RightVectorBar:"\u2953",RightVector:"\u21c0' +
'",ring:"\u02da",risingdotseq:"\u2253",rlarr:"\u21c4",rlhar:"\u21cc",rlm:"\u200f"' +
',rmoustache:"\u23b1",rmoust:"\u23b1",rnmid:"\u2aee",roang:"\u27ed",roarr:"\u21fe' +
'",robrk:"\u27e7",ropar:"\u2986",ropf:"\ud835\udd63",Ropf:"\u211d",roplus:"\u2a2e' +
'",rotimes:"\u2a35",RoundImplies:"\u2970",rpar:")",rpargt:"\u2994",rppolint:"\u2a' +
'12",rrarr:"\u21c9",Rrightarrow:"\u21db",rsaquo:"\u203a",rscr:"\ud835\udcc7",Rscr' +
':"\u211b",rsh:"\u21b1",Rsh:"\u21b1",rsqb:"]",rsquo:"\u2019",rsquor:"\u2019",rthr' +
'ee:"\u22cc",rtimes:"\u22ca",rtri:"\u25b9",rtrie:"\u22b5",rtrif:"\u25b8",rtriltri' +
':"\u29ce",RuleDelayed:"\u29f4",ruluhar:"\u2968",rx:"\u211e",Sacute:"\u015a",sacu' +
'te:"\u015b",sbquo:"\u201a",scap:"\u2ab8",Scaron:"\u0160",scaron:"\u0161",Sc:"\u2' +
'abc",sc:"\u227b",sccue:"\u227d",sce:"\u2ab0",scE:"\u2ab4",Scedil:"\u015e",scedil' +
':"\u015f",Scirc:"\u015c",scirc:"\u015d",scnap:"\u2aba",scnE:"\u2ab6",scnsim:"\u2' +
'2e9",scpolint:"\u2a13",scsim:"\u227f",Scy:"\u0421",scy:"\u0441",sdotb:"\u22a1",s' +
'dot:"\u22c5",sdote:"\u2a66",searhk:"\u2925",searr:"\u2198",seArr:"\u21d8",searro' +
'w:"\u2198",sect:"\xa7",semi:";",seswar:"\u2929",setminus:"\u2216",setmn:"\u2216"' +
',sext:"\u2736",Sfr:"\ud835\udd16",sfr:"\ud835\udd30",sfrown:"\u2322",sharp:"\u26' +
'6f",SHCHcy:"\u0429",shchcy:"\u0449",SHcy:"\u0428",shcy:"\u0448",ShortDownArrow:"' +
'\u2193",ShortLeftArrow:"\u2190",shortmid:"\u2223",shortparallel:"\u2225",ShortRi' +
'ghtArrow:"\u2192",ShortUpArrow:"\u2191",shy:"\xad",Sigma:"\u03a3",sigma:"\u03c3"' +
',sigmaf:"\u03c2",sigmav:"\u03c2",sim:"\u223c",simdot:"\u2a6a",sime:"\u2243",sime' +
'q:"\u2243",simg:"\u2a9e",simgE:"\u2aa0",siml:"\u2a9d",simlE:"\u2a9f",simne:"\u22' +
'46",simplus:"\u2a24",simrarr:"\u2972",slarr:"\u2190",SmallCircle:"\u2218",smalls' +
'etminus:"\u2216",smashp:"\u2a33",smeparsl:"\u29e4",smid:"\u2223",smile:"\u2323",' +
'smt:"\u2aaa",smte:"\u2aac",smtes:"\u2aac\ufe00",SOFTcy:"\u042c",softcy:"\u044c",' +
'solbar:"\u233f",solb:"\u29c4",sol:"/",Sopf:"\ud835\udd4a",sopf:"\ud835\udd64",sp' +
'ades:"\u2660",spadesuit:"\u2660",spar:"\u2225",sqcap:"\u2293",sqcaps:"\u2293\ufe' +
'00",sqcup:"\u2294",sqcups:"\u2294\ufe00",Sqrt:"\u221a",sqsub:"\u228f",sqsube:"\u' +
'2291",sqsubset:"\u228f",sqsubseteq:"\u2291",sqsup:"\u2290",sqsupe:"\u2292",sqsup' +
'set:"\u2290",sqsupseteq:"\u2292",square:"\u25a1",Square:"\u25a1",SquareIntersect' +
'ion:"\u2293",SquareSubset:"\u228f",SquareSubsetEqual:"\u2291",SquareSuperset:"\u' +
'2290",SquareSupersetEqual:"\u2292",SquareUnion:"\u2294",squarf:"\u25aa",squ:"\u2' +
'5a1",squf:"\u25aa",srarr:"\u2192",Sscr:"\ud835\udcae",sscr:"\ud835\udcc8",ssetmn' +
':"\u2216",ssmile:"\u2323",sstarf:"\u22c6",Star:"\u22c6",star:"\u2606",starf:"\u2' +
'605",straightepsilon:"\u03f5",straightphi:"\u03d5",strns:"\xaf",sub:"\u2282",Sub' +
':"\u22d0",subdot:"\u2abd",subE:"\u2ac5",sube:"\u2286",subedot:"\u2ac3",submult:"' +
'\u2ac1",subnE:"\u2acb",subne:"\u228a",subplus:"\u2abf",subrarr:"\u2979",subset:"' +
'\u2282",Subset:"\u22d0",subseteq:"\u2286",subseteqq:"\u2ac5",SubsetEqual:"\u2286' +
'",subsetneq:"\u228a",subsetneqq:"\u2acb",subsim:"\u2ac7",subsub:"\u2ad5",subsup:' +
'"\u2ad3",succapprox:"\u2ab8",succ:"\u227b",succcurlyeq:"\u227d",Succeeds:"\u227b' +
'",SucceedsEqual:"\u2ab0",SucceedsSlantEqual:"\u227d",SucceedsTilde:"\u227f",succ' +
'eq:"\u2ab0",succnapprox:"\u2aba",succneqq:"\u2ab6",succnsim:"\u22e9",succsim:"\u' +
'227f",SuchThat:"\u220b",sum:"\u2211",Sum:"\u2211",sung:"\u266a",sup1:"\xb9",sup2' +
':"\xb2",sup3:"\xb3",sup:"\u2283",Sup:"\u22d1",supdot:"\u2abe",supdsub:"\u2ad8",s' +
'upE:"\u2ac6",supe:"\u2287",supedot:"\u2ac4",Superset:"\u2283",SupersetEqual:"\u2' +
'287",suphsol:"\u27c9",suphsub:"\u2ad7",suplarr:"\u297b",supmult:"\u2ac2",supnE:"' +
'\u2acc",supne:"\u228b",supplus:"\u2ac0",supset:"\u2283",Supset:"\u22d1",supseteq' +
':"\u2287",supseteqq:"\u2ac6",supsetneq:"\u228b",supsetneqq:"\u2acc",supsim:"\u2a' +
'c8",supsub:"\u2ad4",supsup:"\u2ad6",swarhk:"\u2926",swarr:"\u2199",swArr:"\u21d9' +
'",swarrow:"\u2199",swnwar:"\u292a",szlig:"\xdf",Tab:"\t",target:"\u2316",Tau:"\u' +
'03a4",tau:"\u03c4",tbrk:"\u23b4",Tcaron:"\u0164",tcaron:"\u0165",Tcedil:"\u0162"' +
',tcedil:"\u0163",Tcy:"\u0422",tcy:"\u0442",tdot:"\u20db",telrec:"\u2315",Tfr:"\u' +
'd835\udd17",tfr:"\ud835\udd31",there4:"\u2234",therefore:"\u2234",Therefore:"\u2' +
'234",Theta:"\u0398",theta:"\u03b8",thetasym:"\u03d1",thetav:"\u03d1",thickapprox' +
':"\u2248",thicksim:"\u223c",ThickSpace:"\u205f\u200a",ThinSpace:"\u2009",thinsp:' +
'"\u2009",thkap:"\u2248",thksim:"\u223c",THORN:"\xde",thorn:"\xfe",tilde:"\u02dc"' +
',Tilde:"\u223c",TildeEqual:"\u2243",TildeFullEqual:"\u2245",TildeTilde:"\u2248",' +
'timesbar:"\u2a31",timesb:"\u22a0",times:"\xd7",timesd:"\u2a30",tint:"\u222d",toe' +
'a:"\u2928",topbot:"\u2336",topcir:"\u2af1",top:"\u22a4",Topf:"\ud835\udd4b",topf' +
':"\ud835\udd65",topfork:"\u2ada",tosa:"\u2929",tprime:"\u2034",trade:"\u2122",TR' +
'ADE:"\u2122",triangle:"\u25b5",triangledown:"\u25bf",triangleleft:"\u25c3",trian' +
'glelefteq:"\u22b4",triangleq:"\u225c",triangleright:"\u25b9",trianglerighteq:"\u' +
'22b5",tridot:"\u25ec",trie:"\u225c",triminus:"\u2a3a",TripleDot:"\u20db",triplus' +
':"\u2a39",trisb:"\u29cd",tritime:"\u2a3b",trpezium:"\u23e2",Tscr:"\ud835\udcaf",' +
'tscr:"\ud835\udcc9",TScy:"\u0426",tscy:"\u0446",TSHcy:"\u040b",tshcy:"\u045b",Ts' +
'trok:"\u0166",tstrok:"\u0167",twixt:"\u226c",twoheadleftarrow:"\u219e",twoheadri' +
'ghtarrow:"\u21a0",Uacute:"\xda",uacute:"\xfa",uarr:"\u2191",Uarr:"\u219f",uArr:"' +
'\u21d1",Uarrocir:"\u2949",Ubrcy:"\u040e",ubrcy:"\u045e",Ubreve:"\u016c",ubreve:"' +
'\u016d",Ucirc:"\xdb",ucirc:"\xfb",Ucy:"\u0423",ucy:"\u0443",udarr:"\u21c5",Udbla' +
'c:"\u0170",udblac:"\u0171",udhar:"\u296e",ufisht:"\u297e",Ufr:"\ud835\udd18",ufr' +
':"\ud835\udd32",Ugrave:"\xd9",ugrave:"\xf9",uHar:"\u2963",uharl:"\u21bf",uharr:"' +
'\u21be",uhblk:"\u2580",ulcorn:"\u231c",ulcorner:"\u231c",ulcrop:"\u230f",ultri:"' +
'\u25f8",Umacr:"\u016a",umacr:"\u016b",uml:"\xa8",UnderBar:"_",UnderBrace:"\u23df' +
'",UnderBracket:"\u23b5",UnderParenthesis:"\u23dd",Union:"\u22c3",UnionPlus:"\u22' +
'8e",Uogon:"\u0172",uogon:"\u0173",Uopf:"\ud835\udd4c",uopf:"\ud835\udd66",UpArro' +
'wBar:"\u2912",uparrow:"\u2191",UpArrow:"\u2191",Uparrow:"\u21d1",UpArrowDownArro' +
'w:"\u21c5",updownarrow:"\u2195",UpDownArrow:"\u2195",Updownarrow:"\u21d5",UpEqui' +
'librium:"\u296e",upharpoonleft:"\u21bf",upharpoonright:"\u21be",uplus:"\u228e",U' +
'pperLeftArrow:"\u2196",UpperRightArrow:"\u2197",upsi:"\u03c5",Upsi:"\u03d2",upsi' +
'h:"\u03d2",Upsilon:"\u03a5",upsilon:"\u03c5",UpTeeArrow:"\u21a5",UpTee:"\u22a5",' +
'upuparrows:"\u21c8",urcorn:"\u231d",urcorner:"\u231d",urcrop:"\u230e",Uring:"\u0' +
'16e",uring:"\u016f",urtri:"\u25f9",Uscr:"\ud835\udcb0",uscr:"\ud835\udcca",utdot' +
':"\u22f0",Utilde:"\u0168",utilde:"\u0169",utri:"\u25b5",utrif:"\u25b4",uuarr:"\u' +
'21c8",Uuml:"\xdc",uuml:"\xfc",uwangle:"\u29a7",vangrt:"\u299c",varepsilon:"\u03f' +
'5",varkappa:"\u03f0",varnothing:"\u2205",varphi:"\u03d5",varpi:"\u03d6",varpropt' +
'o:"\u221d",varr:"\u2195",vArr:"\u21d5",varrho:"\u03f1",varsigma:"\u03c2",varsubs' +
'etneq:"\u228a\ufe00",varsubsetneqq:"\u2acb\ufe00",varsupsetneq:"\u228b\ufe00",va' +
'rsupsetneqq:"\u2acc\ufe00",vartheta:"\u03d1",vartriangleleft:"\u22b2",vartriangl' +
'eright:"\u22b3",vBar:"\u2ae8",Vbar:"\u2aeb",vBarv:"\u2ae9",Vcy:"\u0412",vcy:"\u0' +
'432",vdash:"\u22a2",vDash:"\u22a8",Vdash:"\u22a9",VDash:"\u22ab",Vdashl:"\u2ae6"' +
',veebar:"\u22bb",vee:"\u2228",Vee:"\u22c1",veeeq:"\u225a",vellip:"\u22ee",verbar' +
':"|",Verbar:"\u2016",vert:"|",Vert:"\u2016",VerticalBar:"\u2223",VerticalLine:"|' +
'",VerticalSeparator:"\u2758",VerticalTilde:"\u2240",VeryThinSpace:"\u200a",Vfr:"' +
'\ud835\udd19",vfr:"\ud835\udd33",vltri:"\u22b2",vnsub:"\u2282\u20d2",vnsup:"\u22' +
'83\u20d2",Vopf:"\ud835\udd4d",vopf:"\ud835\udd67",vprop:"\u221d",vrtri:"\u22b3",' +
'Vscr:"\ud835\udcb1",vscr:"\ud835\udccb",vsubnE:"\u2acb\ufe00",vsubne:"\u228a\ufe' +
'00",vsupnE:"\u2acc\ufe00",vsupne:"\u228b\ufe00",Vvdash:"\u22aa",vzigzag:"\u299a"' +
',Wcirc:"\u0174",wcirc:"\u0175",wedbar:"\u2a5f",wedge:"\u2227",Wedge:"\u22c0",wed' +
'geq:"\u2259",weierp:"\u2118",Wfr:"\ud835\udd1a",wfr:"\ud835\udd34",Wopf:"\ud835\' +
'udd4e",wopf:"\ud835\udd68",wp:"\u2118",wr:"\u2240",wreath:"\u2240",Wscr:"\ud835\' +
'udcb2",wscr:"\ud835\udccc",xcap:"\u22c2",xcirc:"\u25ef",xcup:"\u22c3",xdtri:"\u2' +
'5bd",Xfr:"\ud835\udd1b",xfr:"\ud835\udd35",xharr:"\u27f7",xhArr:"\u27fa",Xi:"\u0' +
'39e",xi:"\u03be",xlarr:"\u27f5",xlArr:"\u27f8",xmap:"\u27fc",xnis:"\u22fb",xodot' +
':"\u2a00",Xopf:"\ud835\udd4f",xopf:"\ud835\udd69",xoplus:"\u2a01",xotime:"\u2a02' +
'",xrarr:"\u27f6",xrArr:"\u27f9",Xscr:"\ud835\udcb3",xscr:"\ud835\udccd",xsqcup:"' +
'\u2a06",xuplus:"\u2a04",xutri:"\u25b3",xvee:"\u22c1",xwedge:"\u22c0",Yacute:"\xd' +
'd",yacute:"\xfd",YAcy:"\u042f",yacy:"\u044f",Ycirc:"\u0176",ycirc:"\u0177",Ycy:"' +
'\u042b",ycy:"\u044b",yen:"\xa5",Yfr:"\ud835\udd1c",yfr:"\ud835\udd36",YIcy:"\u04' +
'07",yicy:"\u0457",Yopf:"\ud835\udd50",yopf:"\ud835\udd6a",Yscr:"\ud835\udcb4",ys' +
'cr:"\ud835\udcce",YUcy:"\u042e",yucy:"\u044e",yuml:"\xff",Yuml:"\u0178",Zacute:"' +
'\u0179",zacute:"\u017a",Zcaron:"\u017d",zcaron:"\u017e",Zcy:"\u0417",zcy:"\u0437' +
'",Zdot:"\u017b",zdot:"\u017c",zeetrf:"\u2128",ZeroWidthSpace:"\u200b",Zeta:"\u03' +
'96",zeta:"\u03b6",zfr:"\ud835\udd37",Zfr:"\u2128",ZHcy:"\u0416",zhcy:"\u0436",zi' +
'grarr:"\u21dd",zopf:"\ud835\udd6b",Zopf:"\u2124",Zscr:"\ud835\udcb5",zscr:"\ud83' +
'5\udccf",zwj:"\u200d",zwnj:"\u200c"}},{}],54:[function(e,r,t){"use strict";funct' +
'ion n(e){var r=Array.prototype.slice.call(arguments,1);return r.forEach(function' +
'(r){r&&Object.keys(r).forEach(function(t){e[t]=r[t]})}),e}function s(e){return O' +
'bject.prototype.toString.call(e)}function o(e){return"[object String]"===s(e)}fu' +
'nction i(e){return"[object Object]"===s(e)}function a(e){return"[object RegExp]"' +
'===s(e)}function c(e){return"[object Function]"===s(e)}function l(e){return e.re' +
'place(/[.?*+^$[\]\\(){}|-]/g,"\\$&")}function u(e){return Object.keys(e||{}).red' +
'uce(function(e,r){return e||k.hasOwnProperty(r)},!1)}function p(e){e.__index__=-' +
'1,e.__text_cache__=""}function h(e){return function(r,t){var n=r.slice(t);return' +
' e.test(n)?n.match(e)[0].length:0}}function f(){return function(e,r){r.normalize' +
'(e)}}function d(r){function t(e){return e.replace("%TLDS%",s.src_tlds)}function ' +
'n(e,r){throw new Error(''(LinkifyIt) Invalid schema "''+e+''": ''+r)}var s=r.re=e(".' +
'/lib/re")(r.__opts__),u=r.__tlds__.slice();r.onCompile(),r.__tlds_replaced__||u.' +
'push(v),u.push(s.src_xn),s.src_tlds=u.join("|"),s.email_fuzzy=RegExp(t(s.tpl_ema' +
'il_fuzzy),"i"),s.link_fuzzy=RegExp(t(s.tpl_link_fuzzy),"i"),s.link_no_ip_fuzzy=R' +
'egExp(t(s.tpl_link_no_ip_fuzzy),"i"),s.host_fuzzy_test=RegExp(t(s.tpl_host_fuzzy' +
'_test),"i");var d=[];r.__compiled__={},Object.keys(r.__schemas__).forEach(functi' +
'on(e){var t=r.__schemas__[e];if(null!==t){var s={validate:null,link:null};return' +
' r.__compiled__[e]=s,i(t)?(a(t.validate)?s.validate=h(t.validate):c(t.validate)?' +
's.validate=t.validate:n(e,t),void(c(t.normalize)?s.normalize=t.normalize:t.norma' +
'lize?n(e,t):s.normalize=f())):o(t)?void d.push(e):void n(e,t)}}),d.forEach(funct' +
'ion(e){r.__compiled__[r.__schemas__[e]]&&(r.__compiled__[e].validate=r.__compile' +
'd__[r.__schemas__[e]].validate,r.__compiled__[e].normalize=r.__compiled__[r.__sc' +
'hemas__[e]].normalize)}),r.__compiled__[""]={validate:null,normalize:f()};var m=' +
'Object.keys(r.__compiled__).filter(function(e){return e.length>0&&r.__compiled__' +
'[e]}).map(l).join("|");r.re.schema_test=RegExp("(^|(?!_)(?:[><]|"+s.src_ZPCc+"))' +
'("+m+")","i"),r.re.schema_search=RegExp("(^|(?!_)(?:[><]|"+s.src_ZPCc+"))("+m+")' +
'","ig"),r.re.pretest=RegExp("("+r.re.schema_test.source+")|("+r.re.host_fuzzy_te' +
'st.source+")|@","i"),p(r)}function m(e,r){var t=e.__index__,n=e.__last_index__,s' +
'=e.__text_cache__.slice(t,n);this.schema=e.__schema__.toLowerCase(),this.index=t' +
'+r,this.lastIndex=n+r,this.raw=s,this.text=s,this.url=s}function _(e,r){var t=ne' +
'w m(e,r);return e.__compiled__[t.schema].normalize(t,e),t}function g(e,r){return' +
' this instanceof g?(r||u(e)&&(r=e,e={}),this.__opts__=n({},k,r),this.__index__=-' +
'1,this.__last_index__=-1,this.__schema__="",this.__text_cache__="",this.__schema' +
's__=n({},b,e),this.__compiled__={},this.__tlds__=x,this.__tlds_replaced__=!1,thi' +
's.re={},void d(this)):new g(e,r)}var k={fuzzyLink:!0,fuzzyEmail:!0,fuzzyIP:!1},b' +
'={"http:":{validate:function(e,r,t){var n=e.slice(r);return t.re.http||(t.re.htt' +
'p=new RegExp("^\\/\\/"+t.re.src_auth+t.re.src_host_port_strict+t.re.src_path,"i"' +
')),t.re.http.test(n)?n.match(t.re.http)[0].length:0}},"https:":"http:","ftp:":"h' +
'ttp:","//":{validate:function(e,r,t){var n=e.slice(r);return t.re.no_http||(t.re' +
'.no_http=new RegExp("^"+t.re.src_auth+"(?:localhost|(?:(?:"+t.re.src_domain+")\\' +
'.)+"+t.re.src_domain_root+")"+t.re.src_port+t.re.src_host_terminator+t.re.src_pa' +
'th,"i")),t.re.no_http.test(n)?r>=3&&":"===e[r-3]?0:r>=3&&"/"===e[r-3]?0:n.match(' +
't.re.no_http)[0].length:0}},"mailto:":{validate:function(e,r,t){var n=e.slice(r)' +
';return t.re.mailto||(t.re.mailto=new RegExp("^"+t.re.src_email_name+"@"+t.re.sr' +
'c_host_strict,"i")),t.re.mailto.test(n)?n.match(t.re.mailto)[0].length:0}}},v="a' +
'[cdefgilmnoqrstuwxz]|b[abdefghijmnorstvwyz]|c[acdfghiklmnoruvwxyz]|d[ejkmoz]|e[c' +
'egrstu]|f[ijkmor]|g[abdefghilmnpqrstuwy]|h[kmnrtu]|i[delmnoqrst]|j[emop]|k[eghim' +
'nprwyz]|l[abcikrstuvy]|m[acdeghklmnopqrstuvwxyz]|n[acefgilopruz]|om|p[aefghklmnr' +
'stwy]|qa|r[eosuw]|s[abcdeghijklmnortuvxyz]|t[cdfghjklmnortvwz]|u[agksyz]|v[acegi' +
'nu]|w[fs]|y[et]|z[amw]",x="biz|com|edu|gov|net|org|pro|web|xxx|aero|asia|coop|in' +
'fo|museum|name|shop|\u0440\u0444".split("|");g.prototype.add=function(e,r){retur' +
'n this.__schemas__[e]=r,d(this),this},g.prototype.set=function(e){return this.__' +
'opts__=n(this.__opts__,e),this},g.prototype.test=function(e){if(this.__text_cach' +
'e__=e,this.__index__=-1,!e.length)return!1;var r,t,n,s,o,i,a,c,l;if(this.re.sche' +
'ma_test.test(e))for(a=this.re.schema_search,a.lastIndex=0;null!==(r=a.exec(e));)' +
'if(s=this.testSchemaAt(e,r[2],a.lastIndex)){this.__schema__=r[2],this.__index__=' +
'r.index+r[1].length,this.__last_index__=r.index+r[0].length+s;break}return this.' +
'__opts__.fuzzyLink&&this.__compiled__["http:"]&&(c=e.search(this.re.host_fuzzy_t' +
'est),c>=0&&(this.__index__<0||c<this.__index__)&&null!==(t=e.match(this.__opts__' +
'.fuzzyIP?this.re.link_fuzzy:this.re.link_no_ip_fuzzy))&&(o=t.index+t[1].length,(' +
'this.__index__<0||o<this.__index__)&&(this.__schema__="",this.__index__=o,this._' +
'_last_index__=t.index+t[0].length))),this.__opts__.fuzzyEmail&&this.__compiled__' +
'["mailto:"]&&(l=e.indexOf("@"),l>=0&&null!==(n=e.match(this.re.email_fuzzy))&&(o' +
'=n.index+n[1].length,i=n.index+n[0].length,(this.__index__<0||o<this.__index__||' +
'o===this.__index__&&i>this.__last_index__)&&(this.__schema__="mailto:",this.__in' +
'dex__=o,this.__last_index__=i))),this.__index__>=0},g.prototype.pretest=function' +
'(e){return this.re.pretest.test(e)},g.prototype.testSchemaAt=function(e,r,t){ret' +
'urn this.__compiled__[r.toLowerCase()]?this.__compiled__[r.toLowerCase()].valida' +
'te(e,t,this):0},g.prototype.match=function(e){var r=0,t=[];this.__index__>=0&&th' +
'is.__text_cache__===e&&(t.push(_(this,r)),r=this.__last_index__);for(var n=r?e.s' +
'lice(r):e;this.test(n);)t.push(_(this,r)),n=n.slice(this.__last_index__),r+=this' +
'.__last_index__;return t.length?t:null},g.prototype.tlds=function(e,r){return e=' +
'Array.isArray(e)?e:[e],r?(this.__tlds__=this.__tlds__.concat(e).sort().filter(fu' +
'nction(e,r,t){return e!==t[r-1]}).reverse(),d(this),this):(this.__tlds__=e.slice' +
'(),this.__tlds_replaced__=!0,d(this),this)},g.prototype.normalize=function(e){e.' +
'schema||(e.url="http://"+e.url),"mailto:"!==e.schema||/^mailto:/i.test(e.url)||(' +
'e.url="mailto:"+e.url)},g.prototype.onCompile=function(){},r.exports=g},{"./lib/' +
're":55}],55:[function(e,r,t){"use strict";r.exports=function(r){var t={};return ' +
't.src_Any=e("uc.micro/properties/Any/regex").source,t.src_Cc=e("uc.micro/categor' +
'ies/Cc/regex").source,t.src_Z=e("uc.micro/categories/Z/regex").source,t.src_P=e(' +
'"uc.micro/categories/P/regex").source,t.src_ZPCc=[t.src_Z,t.src_P,t.src_Cc].join' +
'("|"),t.src_ZCc=[t.src_Z,t.src_Cc].join("|"),t.src_pseudo_letter="(?:(?!>|<|"+t.' +
'src_ZPCc+")"+t.src_Any+")",t.src_ip4="(?:(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\' +
'\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",t.src_auth="(?:(?:(?!"+t.src_ZCc+"' +
'|[@/]).)+@)?",t.src_port="(?::(?:6(?:[0-4]\\d{3}|5(?:[0-4]\\d{2}|5(?:[0-2]\\d|3[' +
'0-5])))|[1-5]?\\d{1,4}))?",t.src_host_terminator="(?=$|>|<|"+t.src_ZPCc+")(?!-|_' +
'|:\\d|\\.-|\\.(?!$|"+t.src_ZPCc+"))",t.src_path="(?:[/?#](?:(?!"+t.src_ZCc+"|[()' +
'[\\]{}.,\"''?!\\-<>]).|\\[(?:(?!"+t.src_ZCc+"|\\]).)*\\]|\\((?:(?!"+t.src_ZCc+"|[' +
')]).)*\\)|\\{(?:(?!"+t.src_ZCc+''|[}]).)*\\}|\\"(?:(?!''+t.src_ZCc+''|["]).)+\\"|\\' +
'\''(?:(?!''+t.src_ZCc+"|['']).)+\\''|\\''(?="+t.src_pseudo_letter+"|[-]).|\\.{2,3}[a-' +
'zA-Z0-9%/]|\\.(?!"+t.src_ZCc+"|[.]).|"+(r&&r["---"]?"\\-(?!--(?:[^-]|$))(?:-*)|"' +
':"\\-+|")+"\\,(?!"+t.src_ZCc+").|\\!(?!"+t.src_ZCc+"|[!]).|\\?(?!"+t.src_ZCc+"|[' +
'?]).)+|\\/)?", ' +
't.src_email_name=''[\\-;:&=\\+\\$,\\"\\.a-zA-Z0-9_]+'',t.src_xn="xn--[a-z0-9\\-]{1' +
',59}",t.src_domain_root="(?:"+t.src_xn+"|"+t.src_pseudo_letter+"{1,63})",t.src_d' +
'omain="(?:"+t.src_xn+"|(?:"+t.src_pseudo_letter+")|(?:"+t.src_pseudo_letter+"(?:' +
'-(?!-)|"+t.src_pseudo_letter+"){0,61}"+t.src_pseudo_letter+"))",t.src_host="(?:(' +
'?:(?:(?:"+t.src_domain+")\\.)*"+t.src_domain_root+"))",t.tpl_host_fuzzy="(?:"+t.' +
'src_ip4+"|(?:(?:(?:"+t.src_domain+")\\.)+(?:%TLDS%)))",t.tpl_host_no_ip_fuzzy="(' +
'?:(?:(?:"+t.src_domain+")\\.)+(?:%TLDS%))",t.src_host_strict=t.src_host+t.src_ho' +
'st_terminator,t.tpl_host_fuzzy_strict=t.tpl_host_fuzzy+t.src_host_terminator,t.s' +
'rc_host_port_strict=t.src_host+t.src_port+t.src_host_terminator,t.tpl_host_port_' +
'fuzzy_strict=t.tpl_host_fuzzy+t.src_port+t.src_host_terminator,t.tpl_host_port_n' +
'o_ip_fuzzy_strict=t.tpl_host_no_ip_fuzzy+t.src_port+t.src_host_terminator,t.tpl_' +
'host_fuzzy_test="localhost|www\\.|\\.\\d{1,3}\\.|(?:\\.(?:%TLDS%)(?:"+t.src_ZPCc' +
'+"|>|$))",t.tpl_email_fuzzy="(^|<|>|\\(|"+t.src_ZCc+")("+t.src_email_name+"@"+t.' +
'tpl_host_fuzzy_strict+")",t.tpl_link_fuzzy="(^|(?![.:/\\-_@])(?:[$+<=>^`|]|"+t.s' +
'rc_ZPCc+"))((?![$+<=>^`|])"+t.tpl_host_port_fuzzy_strict+t.src_path+")",t.tpl_li' +
'nk_no_ip_fuzzy="(^|(?![.:/\\-_@])(?:[$+<=>^`|]|"+t.src_ZPCc+"))((?![$+<=>^`|])"+' +
't.tpl_host_port_no_ip_fuzzy_strict+t.src_path+")",t}},{"uc.micro/categories/Cc/r' +
'egex":61,"uc.micro/categories/P/regex":63,"uc.micro/categories/Z/regex":64,"uc.m' +
'icro/properties/Any/regex":66}],56:[function(e,r,t){"use strict";function n(e){v' +
'ar r,t,n=o[e];if(n)return n;for(n=o[e]=[],r=0;r<128;r++)t=String.fromCharCode(r)' +
',n.push(t);for(r=0;r<e.length;r++)t=e.charCodeAt(r),n[t]="%"+("0"+t.toString(16)' +
'.toUpperCase()).slice(-2);return n}function s(e,r){var t;return"string"!=typeof ' +
'r&&(r=s.defaultChars),t=n(r),e.replace(/(%[a-f0-9]{2})+/gi,function(e){var r,n,s' +
',o,i,a,c,l="";for(r=0,n=e.length;r<n;r+=3)s=parseInt(e.slice(r+1,r+3),16),s<128?' +
'l+=t[s]:192===(224&s)&&r+3<n&&(o=parseInt(e.slice(r+4,r+6),16),128===(192&o))?(c' +
'=s<<6&1984|63&o,l+=c<128?"\ufffd\ufffd":String.fromCharCode(c),r+=3):224===(240&' +
's)&&r+6<n&&(o=parseInt(e.slice(r+4,r+6),16),i=parseInt(e.slice(r+7,r+9),16),128=' +
'==(192&o)&&128===(192&i))?(c=s<<12&61440|o<<6&4032|63&i,l+=c<2048||c>=55296&&c<=' +
'57343?"\ufffd\ufffd\ufffd":String.fromCharCode(c),r+=6):240===(248&s)&&r+9<n&&(o' +
'=parseInt(e.slice(r+4,r+6),16),i=parseInt(e.slice(r+7,r+9),16),a=parseInt(e.slic' +
'e(r+10,r+12),16),128===(192&o)&&128===(192&i)&&128===(192&a))?(c=s<<18&1835008|o' +
'<<12&258048|i<<6&4032|63&a,c<65536||c>1114111?l+="\ufffd\ufffd\ufffd\ufffd":(c-=' +
'65536,l+=String.fromCharCode(55296+(c>>10),56320+(1023&c))),r+=9):l+="\ufffd";re' +
'turn l})}var o={};s.defaultChars=";/?:@&=+$,#",s.componentChars="",r.exports=s},' +
'{}],57:[function(e,r,t){"use strict";function n(e){var r,t,n=o[e];if(n)return n;' +
'for(n=o[e]=[],r=0;r<128;r++)t=String.fromCharCode(r),/^[0-9a-z]$/i.test(t)?n.pus' +
'h(t):n.push("%"+("0"+r.toString(16).toUpperCase()).slice(-2));for(r=0;r<e.length' +
';r++)n[e.charCodeAt(r)]=e[r];return n}function s(e,r,t){var o,i,a,c,l,u="";for("' +
'string"!=typeof r&&(t=r,r=s.defaultChars),"undefined"==typeof t&&(t=!0),l=n(r),o' +
'=0,i=e.length;o<i;o++)if(a=e.charCodeAt(o),t&&37===a&&o+2<i&&/^[0-9a-f]{2}$/i.te' +
'st(e.slice(o+1,o+3)))u+=e.slice(o,o+3),o+=2;else if(a<128)u+=l[a];else if(a>=552' +
'96&&a<=57343){if(a>=55296&&a<=56319&&o+1<i&&(c=e.charCodeAt(o+1),c>=56320&&c<=57' +
'343)){u+=encodeURIComponent(e[o]+e[o+1]),o++;continue}u+="%EF%BF%BD"}else u+=enc' +
'odeURIComponent(e[o]);return u}var o={};s.defaultChars=";/?:@&=+$,-_.!~*''()#",s.' +
'componentChars="-_.!~*''()",r.exports=s},{}],58:[function(e,r,t){"use strict";r.e' +
'xports=function(e){var r="";return r+=e.protocol||"",r+=e.slashes?"//":"",r+=e.a' +
'uth?e.auth+"@":"",r+=e.hostname&&e.hostname.indexOf(":")!==-1?"["+e.hostname+"]"' +
':e.hostname||"",r+=e.port?":"+e.port:"",r+=e.pathname||"",r+=e.search||"",r+=e.h' +
'ash||""}},{}],59:[function(e,r,t){"use strict";r.exports.encode=e("./encode"),r.' +
'exports.decode=e("./decode"),r.exports.format=e("./format"),r.exports.parse=e(".' +
'/parse")},{"./decode":56,"./encode":57,"./format":58,"./parse":60}],60:[function' +
'(e,r,t){"use strict";function n(){this.protocol=null,this.slashes=null,this.auth' +
'=null,this.port=null,this.hostname=null,this.hash=null,this.search=null,this.pat' +
'hname=null}function s(e,r){if(e&&e instanceof n)return e;var t=new n;return t.pa' +
'rse(e,r),t}var o=/^([a-z0-9.+-]+:)/i,i=/:[0-9]*$/,a=/^(\/\/?(?!\/)[^\?\s]*)(\?[^' +
'\s]*)?$/,c=["<",">",''"'',"`"," ","\r","\n","\t"],l=["{","}","|","\\","^","`"].con' +
'cat(c),u=["''"].concat(l),p=["%","/","?",";","#"].concat(u),h=["/","?","#"],f=255' +
',d=/^[+a-z0-9A-Z_-]{0,63}$/,m=/^([+a-z0-9A-Z_-]{0,63})(.*)$/,_={javascript:!0,"j' +
'avascript:":!0},g={http:!0,https:!0,ftp:!0,gopher:!0,file:!0,"http:":!0,"https:"' +
':!0,"ftp:":!0,"gopher:":!0,"file:":!0};n.prototype.parse=function(e,r){var t,n,s' +
',i,c,l=e;if(l=l.trim(),!r&&1===e.split("#").length){var u=a.exec(l);if(u)return ' +
'this.pathname=u[1],u[2]&&(this.search=u[2]),this}var k=o.exec(l);if(k&&(k=k[0],s' +
'=k.toLowerCase(),this.protocol=k,l=l.substr(k.length)),(r||k||l.match(/^\/\/[^@\' +
'/]+@[^@\/]+/))&&(c="//"===l.substr(0,2),!c||k&&_[k]||(l=l.substr(2),this.slashes' +
'=!0)),!_[k]&&(c||k&&!g[k])){var b=-1;for(t=0;t<h.length;t++)i=l.indexOf(h[t]),i!' +
'==-1&&(b===-1||i<b)&&(b=i);var v,x;for(x=b===-1?l.lastIndexOf("@"):l.lastIndexOf' +
'("@",b),x!==-1&&(v=l.slice(0,x),l=l.slice(x+1),this.auth=v),b=-1,t=0;t<p.length;' +
't++)i=l.indexOf(p[t]),i!==-1&&(b===-1||i<b)&&(b=i);b===-1&&(b=l.length),":"===l[' +
'b-1]&&b--;var y=l.slice(0,b);l=l.slice(b),this.parseHost(y),this.hostname=this.h' +
'ostname||"";var C="["===this.hostname[0]&&"]"===this.hostname[this.hostname.leng' +
'th-1];if(!C){var A=this.hostname.split(/\./);for(t=0,n=A.length;t<n;t++){var w=A' +
'[t];if(w&&!w.match(d)){for(var D="",q=0,E=w.length;q<E;q++)D+=w.charCodeAt(q)>12' +
'7?"x":w[q];if(!D.match(d)){var S=A.slice(0,t),F=A.slice(t+1),z=w.match(m);z&&(S.' +
'push(z[1]),F.unshift(z[2])),F.length&&(l=F.join(".")+l),this.hostname=S.join("."' +
');break}}}}this.hostname.length>f&&(this.hostname=""),C&&(this.hostname=this.hos' +
'tname.substr(1,this.hostname.length-2))}var L=l.indexOf("#");L!==-1&&(this.hash=' +
'l.substr(L),l=l.slice(0,L));var T=l.indexOf("?");return T!==-1&&(this.search=l.s' +
'ubstr(T),l=l.slice(0,T)),l&&(this.pathname=l),g[s]&&this.hostname&&!this.pathnam' +
'e&&(this.pathname=""),this},n.prototype.parseHost=function(e){var r=i.exec(e);r&' +
'&(r=r[0],":"!==r&&(this.port=r.substr(1)),e=e.substr(0,e.length-r.length)),e&&(t' +
'his.hostname=e)},r.exports=s},{}],61:[function(e,r,t){r.exports=/[\0-\x1F\x7F-\x' +
'9F]/},{}],62:[function(e,r,t){r.exports=/[\xAD\u0600-\u0605\u061C\u06DD\u070F\u1' +
'80E\u200B-\u200F\u202A-\u202E\u2060-\u2064\u2066-\u206F\uFEFF\uFFF9-\uFFFB]|\uD8' +
'04\uDCBD|\uD82F[\uDCA0-\uDCA3]|\uD834[\uDD73-\uDD7A]|\uDB40[\uDC01\uDC20-\uDC7F]' +
'/},{}],63:[function(e,r,t){r.exports=/[!-#%-\*,-\/:;\?@\[-\]_\{\}\xA1\xA7\xAB\xB' +
'6\xB7\xBB\xBF\u037E\u0387\u055A-\u055F\u0589\u058A\u05BE\u05C0\u05C3\u05C6\u05F3' +
'\u05F4\u0609\u060A\u060C\u060D\u061B\u061E\u061F\u066A-\u066D\u06D4\u0700-\u070D' +
'\u07F7-\u07F9\u0830-\u083E\u085E\u0964\u0965\u0970\u0AF0\u0DF4\u0E4F\u0E5A\u0E5B' +
'\u0F04-\u0F12\u0F14\u0F3A-\u0F3D\u0F85\u0FD0-\u0FD4\u0FD9\u0FDA\u104A-\u104F\u10' +
'FB\u1360-\u1368\u1400\u166D\u166E\u169B\u169C\u16EB-\u16ED\u1735\u1736\u17D4-\u1' +
'7D6\u17D8-\u17DA\u1800-\u180A\u1944\u1945\u1A1E\u1A1F\u1AA0-\u1AA6\u1AA8-\u1AAD\' +
'u1B5A-\u1B60\u1BFC-\u1BFF\u1C3B-\u1C3F\u1C7E\u1C7F\u1CC0-\u1CC7\u1CD3\u2010-\u20' +
'27\u2030-\u2043\u2045-\u2051\u2053-\u205E\u207D\u207E\u208D\u208E\u2308-\u230B\u' +
'2329\u232A\u2768-\u2775\u27C5\u27C6\u27E6-\u27EF\u2983-\u2998\u29D8-\u29DB\u29FC' +
'\u29FD\u2CF9-\u2CFC\u2CFE\u2CFF\u2D70\u2E00-\u2E2E\u2E30-\u2E42\u3001-\u3003\u30' +
'08-\u3011\u3014-\u301F\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF\uA60D-\uA60F\uA673\uA' +
'67E\uA6F2-\uA6F7\uA874-\uA877\uA8CE\uA8CF\uA8F8-\uA8FA\uA8FC\uA92E\uA92F\uA95F\u' +
'A9C1-\uA9CD\uA9DE\uA9DF\uAA5C-\uAA5F\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F\u' +
'FE10-\uFE19\uFE30-\uFE52\uFE54-\uFE61\uFE63\uFE68\uFE6A\uFE6B\uFF01-\uFF03\uFF05' +
'-\uFF0A\uFF0C-\uFF0F\uFF1A\uFF1B\uFF1F\uFF20\uFF3B-\uFF3D\uFF3F\uFF5B\uFF5D\uFF5' +
'F-\uFF65]|\uD800[\uDD00-\uDD02\uDF9F\uDFD0]|\uD801\uDD6F|\uD802[\uDC57\uDD1F\uDD' +
'3F\uDE50-\uDE58\uDE7F\uDEF0-\uDEF6\uDF39-\uDF3F\uDF99-\uDF9C]|\uD804[\uDC47-\uDC' +
'4D\uDCBB\uDCBC\uDCBE-\uDCC1\uDD40-\uDD43\uDD74\uDD75\uDDC5-\uDDC9\uDDCD\uDDDB\uD' +
'DDD-\uDDDF\uDE38-\uDE3D\uDEA9]|\uD805[\uDCC6\uDDC1-\uDDD7\uDE41-\uDE43\uDF3C-\uD' +
'F3E]|\uD809[\uDC70-\uDC74]|\uD81A[\uDE6E\uDE6F\uDEF5\uDF37-\uDF3B\uDF44]|\uD82F\' +
'uDC9F|\uD836[\uDE87-\uDE8B]/},{}],64:[function(e,r,t){r.exports=/[ \xA0\u1680\u2' +
'000-\u200A\u202F\u205F\u3000]/},{}],65:[function(e,r,t){r.exports.Any=e("./prope' +
'rties/Any/regex"),r.exports.Cc=e("./categories/Cc/regex"),r.exports.Cf=e("./cate' +
'gories/Cf/regex"),r.exports.P=e("./categories/P/regex"),r.exports.Z=e("./categor' +
'ies/Z/regex")},{"./categories/Cc/regex":61,"./categories/Cf/regex":62,"./categor' +
'ies/P/regex":63,"./categories/Z/regex":64,"./properties/Any/regex":66}],66:[func' +
'tion(e,r,t){r.exports=/[\0-\uD7FF\uE000-\uFFFF]|[\uD800-\uDBFF][\uDC00-\uDFFF]|[' +
'\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?:[^\uD800-\uDBFF]|^)[\uDC00-\uDFFF]/},{}],67' +
':[function(e,r,t){"use strict";r.exports=e("./lib/")},{"./lib/":9}]},{},[67])(67' +
')}); '
+#13'	</script>        '
+#13'	'
+#13'	 <script type="text/javascript">'
+#13'            '
+#13'		var md = window.markdownit({html:true, linkify: true});'
+#13'		function update(){'
+#13'			var res = md.render(document.getElementById("wmd-input").value);'
+#13'			document.getElementById(''resultado'').innerHTML = res;	'
+#13'		}'
+#13'            update();'
+#13'        </script>';


ABOUTMDPAD = 'MDPad v 1.3.3 beta'
+#13' Author: Victor Alberto Gil <vhanla>'
+#13' http://apps.codigobit.info'
+#13
+#13' Third party Markdown Engines:'
+#13' - PageDown'
+#13' - MarkdownJS v0.6.0beta1'
+#13' - Marked v0.3.5'
+#13' - MarkdownIt 7.0.0'
+#13' Source Code on their github repo, no modified';


DEFAULTTHEME = '{ ' +
'   "Colors": { ' +
'      "Info": { ' +
'         "General": { ' +
'            "Version": "1.6.0", ' +
'            "Date": "21.05.2016" ' +
'         }, ' +
'         "Author": { ' +
'            "Name": "Lasse Rautiainen", ' +
'            "Mail": "lasse@bonecode.com" ' +
'         } ' +
'      }, ' +
'      "Editor": { ' +
'         "Colors": { ' +
'            "Background": "$00FFFFFF", ' +
'            "ActiveLineBackground": "$00FFFFFF", ' +
'            "CodeFoldingActiveLineBackground": "$00FFFFFF", ' +
'            "CodeFoldingBackground": "$00FFFFFF", ' +
'            "CodeFoldingCollapsedLine": "$009F9F9F", ' +
'            "CodeFoldingFoldingLine": "$009F9F9F", ' +
'            "CodeFoldingFoldingLineHighlight": "$009F9F9F", ' +
'            "CodeFoldingIndent": "$00414746", ' +
'            "CodeFoldingIndentHighlight": "$00414746", ' +
'            "CodeFoldingHintBackground": "$00FFFFFF", ' +
'            "CodeFoldingHintBorder": "$00414746", ' +
'            "CodeFoldingHintText": "$00F8F8F2", ' +
'            "CompletionProposalBackground": "$00FFFFFF", ' +
'            "CompletionProposalForeground": "$00F8F8F2", ' +
'            "CompletionProposalSelectedBackground": "$003E4849", ' +
'            "CompletionProposalSelectedText": "clHighlightText", ' +
'            "LeftMarginActiveLineBackground": "$00FFFFFF", ' +
'            "LeftMarginBackground": "$00FFFFFF", ' +
'            "LeftMarginBorder": "$00222827", ' +
'            "LeftMarginLineNumberLine": "$009F9F9F", ' +
'            "LeftMarginLineNumbers": "$009F9F9F", ' +
'            "LeftMarginLineStateModified": "$0074DBE6", ' +
'            "LeftMarginLineStateNormal": "$002EE2A6", ' +
'            "LeftMarginBookmarkPanel": "$00FFFFFF", ' +
'            "MatchingPairMatched": "$007226F9", ' +
'            "MatchingPairUnderline": "$00414746", ' +
'            "MatchingPairUnmatched": "clYellow", ' +
'            "MinimapBackground": "clNone", ' +
'            "MinimapBookmark": "$005E7175", ' +
'            "MinimapVisibleLines": "$003E4849", ' +
'            "RightMargin": "clSilver", ' +
'            "RightMovingEdge": "clSilver", ' +
'            "SearchHighlighterBackground": "$003E4849", ' +
'            "SearchHighlighterForeground": "clNone", ' +
'            "SearchMapActiveLine": "$00F0F0F0", ' +
'            "SearchMapBackground": "$00F4F4F4", ' +
'            "SearchMapForeground": "$0078AAFF", ' +
'            "SelectionBackground": "clHighlight", ' +
'            "SelectionForeground": "clHighlightText", ' +
'            "SyncEditBackground": "$00FFFFFF", ' +
'            "SyncEditEditBorder": "$00F8F8F2", ' +
'            "SyncEditWordBorder": "$003E4849", ' +
'            "WordWrapIndicatorArrow": "$00000000", ' +
'            "WordWrapIndicatorLines": "$00000000" ' +
'         } ' +
'      }, ' +
'      "Elements": [ ' +
'         { ' +
'            "Name": "Editor", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "Comment", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "String", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "Directive", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "Character", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "ReservedWord", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF", ' +
'            "Style": "Bold" ' +
'         }, ' +
'         { ' +
'            "Name": "Symbol", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "Number", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "HexNumber", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "HighlightedBlock", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "HighlightedBlockSymbol", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "AssemblerComment", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "AssemblerReservedWord", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF", ' +
'            "Style": "Bold" ' +
'         }, ' +
'         { ' +
'            "Name": "Attribute", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         }, ' +
'         { ' +
'            "Name": "Method", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF", ' +
'            "Style": "Italic" ' +
'         }, ' +
'         { ' +
'            "Name": "MethodName", ' +
'            "Foreground": "$00000000", ' +
'            "Background": "$00FFFFFF" ' +
'         } ' +
'      ] ' +
'   } ' +
'} ';

