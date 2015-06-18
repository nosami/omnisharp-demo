 This minor mode allows functions to operate on the current line if
 they would normally operate on a region and region is currently
 undefined.

 The primary use for this is to kill (cut) the current line if no
 region is defined, and kill-region is invoked.  It basically saves
 you the effort of going to the begining of the line, selecting the
 text up to the end of the line, and killing.  Similarly, when
 yanking, it's smart enough to know that the string to be yanked
 was killed as a whole line, and it should be yanked as one, too.
 So you don't need to position yourself at the start of the line
 before yanking.  If region *is* defined, though, all functions act
 as normal.

 The inspiration for this came from an old editor I used to use
 (brief maybe?), that did this exact thing for you.  It was a handy
 feature to have, and I definitely wanted it when I moved to Emacs.
 I've extended the concept slightly, to let you copy N whole lines,
 using the standard prefix method.

 NOTE: This package will behave unexpectedly (and indeed is nearly
 useless) if `transient-mark-mode' is off, as there is then always
 a region defined.

 NOTE: I haven't gotten this to work under XEmacs (though I
 honestly haven't tried real hard).
