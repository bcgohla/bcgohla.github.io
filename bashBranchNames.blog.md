How to create branch tags in bash
=================================

I need to create [git](http://www.git-scm.org) topic branches a lot.
They usually have the format

~~~~~~
username/ISSUE/some-semi-lengthy-description
~~~~~~

where the latter part comes from the title of a
[Jira](https://www.atlassian.com/software/jira) ticket. Because I love
working on the command line I paste the ticket title to the
[readline](http://en.wikipedia.org/wiki/GNU_Readline) buffer after all
the rest of the command to get something like this:

~~~~~~
git checkout -b username/ISSUE/some semi lengthy description
~~~~~~

Now, normally I would have to replace all the spaces with hyphens
manually. Luckily this can be automated:

1. Write a [bash](http://en.wikipedia.org/wiki/Bash_(Unix_shell))
function that does the transformation for us.

~~~~~~
function makeTicketName {
    local input=${READLINE_LINE:$READLINE_POINT} ;
    local output="`sed -e 's/[\",.@]/ /gi' <<< $input`" ;
    output="`sed -e 's/[^A-Za-z1-9_]/ /gi' <<< $output`" ;
    output=${READLINE_LINE/$input/"`sed -e 's/\s\+/-/gi' <<< $output`"} ;
    READLINE_LINE=$output
}
~~~~~~

This takes the line buffer from the insertion point on, applies the
substitutions, puts it back together with the rest of the buffer
content and then updates it.

2. Bind the function to a key sequence. 

~~~~~~
bind -x '"\C-x\C-t":makeTicketName'
~~~~~~

Put these things in your `~/.bashrc`, restart the shell. 

Now, `git checkout -b username/ISSUE/some semi lengthy description` becomes

~~~~~~
git checkout -b username/ISSUE/some-semi-lengthy-description
~~~~~~

upon moving the cursor to the last `/` for example and pressing
`Control-x` followed by `Control-t`.
