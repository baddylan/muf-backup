( Sq-Funcs.muf  --  7/8/93  by Squirrelly )
(
    omsg-sub  { s -- s }
        Takes a standard o-message [such as on @osucc, @odrop, etc.],
        does pronoun-subbing, and puts the name in front, ready for
        displaying.
    nl-repl  { s1 s2 -- s }
        Replaces all hard-coded new-line characters in s1 with
        string s2.
)
 
: omsg-sub  ( s -- s )
    dup if ME @ swap pronoun_sub ME @ name " " strcat swap strcat then
;
 
: nl-repl  ( s1 s2 -- s )
    prog "_nl" getpropstr subst
;
 
public omsg-sub
public nl-repl

