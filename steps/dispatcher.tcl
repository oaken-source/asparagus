
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

  if { [string_starts_with "$args" "an executable"] } {
    given_an_executable {*}[string_pop "$args" "an executable"]
  } else {
    fail_unknown
  }

}

proc Then { args } { then {*}"$args" }

proc then { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_step_type "Then"
  set asparagus_current_step_type "  Then"
  set asparagus_current_step $args

  if { [string_starts_with "$args" "I should see"] } {
    then_I_should_see {*}[string_pop "$args" "I should see"]
  } elseif { [string_starts_with "$args" "I should not see"] } {
    then_I_should_not_see {*}[string_pop "$args" "I should not see"]
  } elseif { [string_starts_with "$args" "it should return"] } {
    then_it_should_return {*}[string_pop "$args" "it should return"]
  } elseif { [string_starts_with "$args" "it should not return"] } {
    then_it_should_not_return {*}[string_pop "$args" "it should not return"]
  } elseif { [string_starts_with "$args" "write the output to log"] } {
    then_write_the_output_to_log {*}[string_pop "$args" "write the output to log"]
  } else {
    fail_unknown
  }

}

proc When { args } { when {*}"$args" }

proc when { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_step_type "When"
  set asparagus_current_step_type "  When"
  set asparagus_current_step $args

  if { [ string_starts_with "$args" "I run with parameters" ] } {
    when_I_run_with_parameters {*}[string_pop "$args" "I run with parameters"]
  } elseif { [string_starts_with "$args" "I run"] } {
    when_I_run {*}[string_pop "$args" "I run"]
  } elseif { [string_starts_with "$args" "I send"] } {
    when_I_send {*}[string_pop "$args" "I send"]
  } else {
    fail_unknown
  }

}

proc And { args } { and {*}"$args" }

proc and { args } {

  global asparagus_step_type
  global asparagus_current_step_type
  global asparagus_current_step

  set asparagus_current_step_type "  And"
  set asparagus_current_step $args

  if { ! [ string compare "Given" $asparagus_step_type ] } {
    given {*}"$args"
  } elseif { ! [ string compare "Then" $asparagus_step_type ] } {
    then {*}"$args"
  } elseif { ! [ string compare "When" $asparagus_step_type ] } {
    when {*}"$args"
  } else {
    fail_unknown
  }

}

