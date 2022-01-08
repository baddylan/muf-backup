( multi-guest.muf - Multiple Guest Processor V1.1
                                          We all speak a different language.
 
     Coded by: Taura LearFox, tlima@interserv.com
 
  No-nonsense setup instructions:
 
     1. Edit the $defines below, create and @set this program
        to W and L.
 
     2. @pcreate the following players:
          Guest
          Guest1
          Guest2 ...
        As many guests as you want.   Please note that their names do
        NOT have to be guest, you SHOULD change the seek name below
        in the $def section.
 
     3. @Create an object called Guest Daemon and @set the following
        on it:
          W flag
          X-Forceable flag
          @flock to this program
 
     4. @Set all Guests players with the prop:
          _connect/def:&You wake up and find yourself at {name:here}.
          {muf:#12345,}
        and
          _disconnect:&{muf:#12345,quit}
        Where #12345 is the dbref of this program.
)
 
$def guestname "Guest"
$def guestpw1 "guest"
$def daemondbref #73
 
$define
 .tell
 me @ swap notify
$enddef
 
$define
 msg_maxguest_tell
 "Sorry, there are too many guests connected right now." .tell
 "Please try again later." .tell
$enddef
 
(                Please do not edit anything below this line.               )
( ------------------------------------------------------------------------- )
 
var counta
var str1
 
: db2con ( d -- i ; returns connection number of d )
 concount counta !
  begin
  counta @ while
  counta @ condbref over dbcmp not while
  counta @ 1 - counta !
 repeat
 pop counta @
;
: guest_find_avail ( -- d ; dbref of first avail guest or #-1 if none avail )
 1 counta !
  begin
  Guestname counta @ intostr strcat "*" swap strcat match
  dup #-1 dbcmp if break then
  dup #-2 dbcmp if break then
  dup #-3 dbcmp if break then
   dup player? not if
   pop counta @ 1 + counta ! continue
   else
    dup awake? 0 = if
    break
    else
    pop counta @ 1 + counta !
   then
  then
 repeat
;
 
: guest_proc ( -- ; guest processor )
 guest_find_avail
 dup #-1 dbcmp if pop msg_maxguest_tell me @ db2con conboot exit then
 dup #-2 dbcmp if pop msg_maxguest_tell me @ db2con conboot exit then
 daemondbref "@name #" me @ intostr strcat "=" strcat
 guestname strcat "_temp " strcat guestpw1 strcat force
 dup name str1 !
 daemondbref swap "@name #" swap intostr strcat "=" strcat
 guestname strcat " " strcat guestpw1 strcat force
 daemondbref "@name #" me @ intostr strcat "=" strcat
 str1 @ strcat " " strcat guestpw1 strcat force
 "You have connected as " str1 @ strcat "." strcat .tell
;
: guest_quit_proc ( -- ; moves the guest home and boots off the MUCK )
  me @ "J" flag? not if
  daemondbref "@set #" me @ intostr strcat "=J" strcat force
 then
 me @ getlink me @ swap moveto
 me @ "leave_mesg" sysparm .tell
 me @ db2con conboot
;
: main
  me @ name guestname stringcmp if "This program is for guests only."
  .tell
  me @ db2con conboot
  exit
 then
"quit" stringcmp not if guest_quit_proc exit then
 guest_proc
;

