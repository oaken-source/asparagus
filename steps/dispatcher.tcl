
 ##############################################################################
 #                                asparagus                                   #
 #                                                                            #
 #    Copyright (C) 2014  Andreas Grapentin                                   #
 #                                                                            #
 #    This program is free software: you can redistribute it and/or modify    #
 #    it under the terms of the GNU General Public License as published by    #
 #    the Free Software Foundation, either version 3 of the License, or       #
 #    (at your option) any later version.                                     #
 #                                                                            #
 #    This program is distributed in the hope that it will be useful,         #
 #    but WITHOUT ANY WARRANTY; without even the implied warranty of          #
 #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
 #    GNU General Public License for more details.                            #
 #                                                                            #
 #    You should have received a copy of the GNU General Public License       #
 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.   #
 ##############################################################################

 # This script handles the step dispatching.
 ##############################################################################

# this is the entry point to asparagus - each test should start with either
# `given' or `Given'. Dispatch what is `given' here and call the corresponding
# handler proc.
proc Given { args } { given {*}"$args" }

proc given { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_step_type "Given"
  set asparagus_current_step_type "Given"
  set asparagus_current_step $args

  dispatch_step {*}"given $args"

}

proc When { args } { when {*}"$args" }

proc when { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_step_type "When"
  set asparagus_current_step_type "  When"
  set asparagus_current_step $args

  dispatch_step {*}"when $args"

}

proc Then { args } { then {*}"$args" }

proc then { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_step_type "Then"
  set asparagus_current_step_type "  Then"
  set asparagus_current_step $args

  dispatch_step {*}"then $args"

}

proc And { args } { and {*}"$args" }

proc and { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_current_step_type "  And"
  set asparagus_current_step $args

  dispatch_step {*}"$asparagus_step_type $args"

}

proc dispatch_step { args } {

  global asparagus_step_definitions

  foreach { func step } $asparagus_step_definitions {
    if { [ string_starts_with "$args" "$step" ] } {
      $func {*}[ string_pop "$args" "$step" ]
      return
    }
  }

  fail_unknown

}

proc asparagus_register_step { func step } {

  global asparagus_step_definitions

  lappend asparagus_step_definitions $func $step

}
