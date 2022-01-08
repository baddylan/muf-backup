(
   pet.muf     by Gyroplast  03/14/99
 
   Let objects follow you around like a pet. Zombie 'light'.
 
   SETUP:
     1. Create an action called pmake;pcall;phome;pstat;preset;pet;pset
        and link it to this program.
     2. @create an object to be the pet
     3. Run pmake <object>
     4. Check pet #help
 
   Have Phun!
 
  *** check http://www.gyroplast.com for this and many other programs! ***
  *** This program is distributed under the GPL. Porting and mods      ***
  *** are explicitly allowed as long as this header stays intact, and  ***
  *** the result of any modification is distributed under the GPL.     ***
  *** For a detailed description of the DOs and DONTs, read the GPL at ***
  *** http://www.gyroplast.com/help/gpl.txt   --Thank you--            ***
 
)
$def MoveDefault "bounds in after you."
$def OMoveDefault "bounds in after %m."
$def AMoveDefault "bounds out after %m."
$def HomeDefault "bounds off to home."
$def CallDefault "You called %n to you."
$def OCallDefault "called %m."
$def SleepDefault "falls asleep."
$def HEADER "PET v1.1b   by Gyroplast@FuzzyLogic   03/14/99"
$def LINE   "-------------------------------------------------------------"
$def SPACES "                                                             "
$def .uline dup strlen LINE swap strcut pop .tell
 
lvar param
lvar petname
 
: pad  ( s i -- s )
  swap SPACES strcat swap strcut pop 
;
 
: obj_ok?  ( s -- b )
  dup not if pop 0 "I don't see that here." .tell exit then
   "*" over "*" strcat strcat petname !
   me @ "_pet/list" getpropstr
   dup if
    " " explode
    BEGIN
      dup while
      1 - swap
      atoi dbref dup name petname @ smatch if param ! else pop then 
    REPEAT
    pop
   else pop then
   param @ dbref? if exit then
  match
  dup #-1 dbcmp if pop "I don't see that here." .tell 0 exit then
  dup #-2 dbcmp if pop "I don't know which one you mean." .tell 0 exit then
  dup thing? not if pop "Only things can be pets." .tell 0 exit then
  dup owner me @ dbcmp not if pop "You do not own that object." .tell 0 exit then
  param ! 1
;
 
: loc_ok? ( d -- b )
  dup "pets_allowed?" getpropstr .yes? if pop 1 exit then
  dup "pets_allowed?" getpropstr dup if .no? if pop 0 exit then else pop then
  dup owner me @ dbcmp if pop 1 exit then
  "j" flag?
;
 
: inlist?  ( d -- b )
  me @ "_pet/list" getpropstr
  swap intostr instring
;
 
: showhelp
  HEADER dup .tell .uline
  "Commands:" .tell
  "               pstat : Shows the status of all your pets." .tell
  "       pset <object> : Sets <object> to be the default pet."
  "      pmake <object> : Sets up the <object> to follow you around." .tell
  "     psleep <object> : Deactivates <object>." .tell
  "  phome [object|all] : Sends <object> or your default pet to its home." .tell
  " preset [object|all] : Resets <object> or your default pet." .tell
  "  pcall [object|all] : Summons <object>, or your default pet" .tell
  "                       if no argument is given." .tell
  " " .tell
  "           pet #help : Show this help screen" .tell
  "           pet #prop : Show property help screen" .tell
  " " .tell
;
 
: prophelp
  HEADER dup .tell .uline
  "Properties:" .tell
  "-----------" .tell
  "On the pet object:" .tell
  "   _pet/move    : What you see when the object follows you." .tell
  "                  (default: <objname> " MoveDefault ")" strcat strcat .tell
  "   _pet/omove   : What everyone sees in the room when object enters." .tell 
  "                  (default: <objname> " OMoveDefault ")" strcat strcat .tell
  "   _pet/amove   : What everyone sees in the room the object leaves." .tell
  "                  This message is displayed regardless of success or failure." .tell
  "                  (default: <objname> " AMoveDefault ")" strcat strcat .tell
  "   _pet/home    : Message you see when pet is sent home." .tell
  "   _pet/ohome   : Message everyone else sees when pet is sent home." .tell
  "                  (default for both: <objname> " HomeDefault ")" strcat strcat .tell
  "   _pet/call    : Message you see when summoning pet." .tell
  "                  (default: " CallDefault ")" strcat strcat .tell
  "   _pet/ocall   : Message others see when summoning pet." .tell
  "                  (default: <yourname> " OCallDefault ")" strcat strcat .tell
  "   _pet/sleep   : Message everyone sees when pet falls asleep." .tell
  "                  (default: <objname> " SleepDefault ")" strcat strcat .tell
  " " .tell
  "  Normal pronoun substitutions work with these messages relative to the pet." .tell
  "  Any %m will be substituted with the player's name, or the pet's name in " .tell
  "  the _pet/ocall message." .tell
  "  All messages are prefixed with the pet's name and a space automatically." .tell
  "  The location the pet is linked to is used as its home." .tell
;
 
: SetAsDefault  ( d --  )
  intostr "" "#" subst
  me @ swap "_pet/def" swap 1 ADDPROP
;
 
: GetMove  ( d -- s )
  dup "_pet/move" getpropstr
  dup not if
   pop dup name " " strcat swap MoveDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst  pronoun_sub
  then
;
 
: GetOMove  ( d -- s )
  dup "_pet/omove" getpropstr
  dup not if
   pop dup name " " strcat swap OMoveDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst pronoun_sub
  then
;
 
: GetAMove  ( d -- s )
  dup "_pet/amove" getpropstr
  dup not if
   pop dup name " " strcat swap AMoveDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst pronoun_sub
  then
;
 
: GetHome  ( d -- s )
  dup "_pet/home" getpropstr
  dup not if
   pop dup name " " strcat swap HomeDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst pronoun_sub
  then
;
 
: GetOHome  ( d -- s )
  dup "_pet/ohome" getpropstr
  dup not if
   pop dup name " " strcat swap HomeDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst pronoun_sub
  then
;
: GetCall  ( d -- s )
  dup "_pet/call" getpropstr
  dup not if
   pop CallDefault
  then
  me @ name "%m" subst pronoun_sub
;
 
: GetOCall  ( d -- s )
  dup "_pet/ocall" getpropstr
  dup not if
   pop OCallDefault
  then
   swap name "%m" subst me @ swap pronoun_sub me @ name " " strcat swap strcat
;
 
: GetSleep  ( d -- s )
  dup "_pet/sleep" getpropstr
  dup not if
   pop dup name " " strcat swap SleepDefault me @ name "%m" subst pronoun_sub strcat
  else
   over name " " strcat swap strcat me @ name "%m" subst pronoun_sub
  then
;
 
: do_move  ( d --  )
  me @ location loc_ok? not if
   dup me @ moveto
   name " has been put into your inventory. Room does not allow puppets."
   strcat .tell
   exit
  then
  dup GetMove .tell
  dup GetOMove .otell
  dup GetAMove over location #-1 rot notify_except
  me @ location moveto
;
 
: do_pmake   ( d --  )
  dup "_pet/active?" "yes" 1 ADDPROP
  dup inlist? not if
   me @ "_pet/list" getpropstr
   over intostr "" "#" subst " " swap strcat strcat STRIP
   me @ swap "_pet/list" swap 1 ADDPROP
  then
  dup SetAsDefault
  dup name " will follow you now!" strcat .tell
  me @ location loc_ok? if me @ location else me @ then
  moveto
  me @ "_arrive/pet" prog intostr 1 ADDPROP
;
 
: move_all
  me @ "_pet/list" getpropstr
  dup not if pop exit then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    dup "_pet/active?" getpropstr .yes? not if pop continue then
    dup location me @ dbcmp if pop continue then
    do_move
  REPEAT
  pop
;
 
: go_home ( d --  )
  dup "_pet/active?" "no" 1 ADDPROP
  dup GetHome .tell
  dup GetOHome .otell
  dup getlink moveto
;
 
: go_home_all
  me @ "_pet/list" getpropstr
  dup not if pop exit then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    dup "_pet/active?" "no" 1 ADDPROP
    dup getlink moveto
  REPEAT
  pop
  "You send all your pets home." .tell
;
 
: do_reset  ( d --  )
  dup "_pet/active?" remove_prop
  dup name " will not follow you anymore." strcat .tell
  me @ "_pet/def" getpropstr atoi dbref over dbcmp if
   me @ "_pet/def" remove_prop
  then
  intostr me @ "_pet/list" getpropstr swap
  dup strlen 1 + -3 rotate over swap instring 1 - strcut
  rot strcut swap pop strcat
  me @ "_pet/list" rot 1 ADDPROP 
;
: reset_all
  "This will eliminate ALL your pets! Are you sure? (y/n)" .tell
  READ STRIP
  .yes? if
  me @ "_pet/list" getpropstr
  dup not if pop "You do not have any pets. Aborting." .tell exit then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    do_reset
  REPEAT
  pop
  "All pets reset." .tell
  else
   "Aborted." .tell
  then
  me @ "_arrive/pet" remove_prop
;
: show_stat
  "PET STATUS:" .tell
  me @ "_pet/list" getpropstr
  dup not if pop "    You don't have any pets." .tell exit then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    "    " over name strcat "(#" strcat over intostr strcat ")" strcat
    24 pad " is " strcat
    over "_pet/active?" getpropstr .yes? if "AWAKE in " else "ASLEEP in " then
    strcat
    swap location
    dup me @ dbcmp if pop "your inventory" else name then
    "." strcat strcat .tell
  REPEAT
  pop
  " " .tell
  "  Default pet: " me @ "_pet/def" getpropstr
  dup not if pop "None" else atoi dbref name then
  strcat .tell
;
 
: do_call  ( d --  )
  dup "_pet/active?" "yes" 1 ADDPROP
  dup me @ location loc_ok? if me @ location else me @ then
  moveto
  dup GetCall .tell
  GetOCall .otell
;
 
: call_all
  me @ "_pet/list" getpropstr
  dup not if pop "You don't have any pets." .tell exit then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    do_call
  REPEAT
  pop
;
 
: do_psleep  ( d --  )
  dup "_pet/active?" "no" 1 ADDPROP
  dup GetSleep .tell
  GetSleep .otell
;
 
: CheckDefaultPet
  me @ "_pet/def" getpropstr
  dup not if pop exit then
  atoi dbref
  dup ok? if
   dup thing? over owner me @ dbcmp AND if pop exit then
  then
  me @ "_pet/def" remove_prop pop
;
 
: CheckList
  me @ "_pet/list" getpropstr
  dup not if pop exit else me @ "_pet/list" remove_prop then
  " " explode
  BEGIN
    dup while
    1 - swap
    atoi dbref
    dup ok? if
     dup thing? over owner me @ dbcmp AND if 
      dup intostr me @ "_pet/list" getpropstr " " strcat swap strcat
      STRIP me @ swap "_pet/list" swap 1 ADDPROP
     then
    then
    pop
  REPEAT
  pop
;
 
: CheckPets
  CheckDefaultPet 
  CheckList
;
 
: main
  CheckPets
  STRIP dup " " instring dup if 1 - strcut pop param ! else pop param ! then
  command @
  dup "pet" stringcmp not if
   pop
   param @ "#h" stringpfx 1 = if showhelp else
    param @ "#p" stringpfx 1 = if prophelp else
     "Unknown command: " command @ strcat " " strcat param @ strcat .tell
    then
   then
  else dup "pmake" stringcmp not if
   pop
   param @ obj_ok? if param @ do_pmake then   
  else dup "Queued event." strcmp not if
   pop
   param @ "Arrive" strcmp not if move_all then
  else dup "pset" stringcmp not if
   pop
   param @ obj_ok? if param @ dup SetAsDefault name " set as default pet."
   strcat .tell then
  else dup "phome" stringcmp not if
   pop
   param @ not if
    me @ "_pet/def" getpropstr dup if atoi dbref go_home else
     pop "No default pet set." .tell
    then
   else param @ "all" stringcmp not if go_home_all
   else param @ obj_ok? if param @ inlist? else exit then if param @ go_home else
    "This is not a pet." .tell
   then
   then
   then
  else dup "preset" stringcmp not if
   pop
   param @ not if
    me @ "_pet/def" getpropstr dup if atoi dbref do_reset else
     pop "No default pet set." .tell
    then
   else param @ "all" stringcmp not if reset_all
   else param @ obj_ok? if param @ inlist? else exit then if param @ do_reset else
    "This is not a pet." .tell
   then
   then
   then
  else dup "pstat" stringcmp not if
   pop show_stat
  else dup "pcall" stringcmp not if
   pop
   param @ not if
    me @ "_pet/def" getpropstr dup if atoi dbref do_call else
     pop "No default pet set." .tell
    then
   else param @ "all" stringcmp not if call_all
   else param @ obj_ok? if param @ inlist? else exit then if param @ do_call else
    "This is not a pet." .tell
   then
   then
   then
  else dup "psleep" stringcmp not if
   pop
   param @ not if
    me @ "_pet/def" getpropstr dup if atoi dbref do_psleep else
     pop "No default pet set." .tell
    then
   else param @ obj_ok? if param @ inlist? else exit then if param @ do_psleep else
    "This is not a pet." .tell
   then
   then
  else
   "Unknown command: " command @ strcat " " strcat param @ strcat .tell
  then then then then then then then then then
;

