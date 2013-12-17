if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim


Snippet html <!DOCTYPE HTML><CR><html><CR><head><CR><title> <{}> </title><CR></head><CR><body><CR><{}><CR></body><CR></html>
Snippet p <p><{}></p>
Snippet a <a href="<{}>"><{}></a>
Snippet img <p style="text-align:left"><img src="<{}>"/></p>
Snippet bl <blockquote><p><{}></p></blockquote>
Snippet pre <pre class='prettyprint'><{}></pre>
Snippet for {% for <{story}> in <{stories}> %}<CR><TAB>{{ <{story}><{}>|upper }}<CR><BS>{% endfor %}
Snippet if {% if <{}> %}<CR><TAB><{}><CR><BS>{% else %}<CR><TAB><{}><CR><BS>{% endif %}
Snippet b <b><{}></b>
Snippet i <i><{}></i>
Snippet code <code><{}></code><{}>
Snippet input  <label><{}> <input type="text/submit/hidden/button<{}>" name="<{name}>" value="<{}>" /></label><{}>
Snippet dl <dl><CR><dt><{}></dt><CR><dd><{}></dd><CR><{}></dl>
Snippet dt <dt><{}></dt><CR><dd><{}></dd><CR><{}>
Snippet ol <ol><CR><li><{}></li><CR><{}></ol><CR>
Snippet ul <ul><CR><li><{}></li><CR><{}></ul><CR>
Snippet li <li><{}></li><CR><{}>
Snippet h1 <h1 id="<{}>"><{}></h1><CR><{}>
Snippet h2 <h2 id="<{}>"><{}></h2><CR><{}>
Snippet h3 <h3 id="<{}>"><{}></h3><CR><{}>
Snippet h4 <h4 id="<{}>"><{}></h4><CR><{}>
