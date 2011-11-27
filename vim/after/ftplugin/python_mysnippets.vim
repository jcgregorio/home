if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

function! SelectImport()
    let st = g:snip_start_tag
    let et = g:snip_end_tag
    let cd = g:snip_elem_delim
    let dt = inputlist(['Select import:',
                \ '1. db',
                \ '2. users',
                \ '3. memcached'])
    let dts = {1: "from google.appengine.ext import db\nclass TaskModel(db.Model):\ndb".st.et,
             \ 2: "from google.appengine.api import users<CR>from google.appengine.ext.webapp.util import login_required<CR><CR>@login_required<CR>users.get_current_user()<{}>".st.et,
             \ 3: "from google.appengine.api import memcache<CR><{}>".st.et}

    return dts[dt]
endfunction

exec "Snippet import ``SelectImport()``"

Snippet db from google.appengine.ext import db<CR><CR>class TaskModel(db.Model):<CR>db<{}>
Snippet template from google.appengine.ext.webapp import template<CR><{}>
Snippet users from google.appengine.api import users<CR>from google.appengine.ext.webapp.util import login_required<CR><CR>@login_required<CR>users.GetCurrentUser()<CR><{}>
Snippet str <{}> = db.StringProperty()<CR><{}>
Snippet date <{}> = db.DateTimeProperty(auto_now_add=True)<CR><{}>

exec "Snippet main #!/usr/bin/env python
\<CR>
\<CR>import os
\<CR>import wsgiref.handlers\
\<CR>
\<CR>from google.appengine.ext import webapp\
\<CR>from google.appengine.ext.webapp import template
\<CR>
\<CR>class TestHandler(webapp.RequestHandler):
\<CR>
\<CR>def get(self):
\<CR>template_values = {\"foo\" : 1}
\<CR>template_file = os.path.join(os.path.dirname(__file__), \"test.html\")
\<CR>self.response.out.write(template.render(template_file, template_values))
\<CR>
\<CR><BS>def main():
\<CR>application = webapp.WSGIApplication([('/', TestHandler)], debug=True)
\<CR>wsgiref.handlers.CGIHandler().run(application)
\<CR>
\<CR>
\<CR><BS><BS>if __name__ == '__main__':
\<CR>main()"
