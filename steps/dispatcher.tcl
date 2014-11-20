
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

  if { [string_starts_with "$args" "an executable "] } {
    given_an_executable {*}[string_pop "$args" "an executable "]
  } else {
    fail_unknown "Given $args"
    return
  }

}

# dispatch a statement of an asparagus test - can be either a `when' or a
# `then' statement - an `and' statement mimics the statement before.
proc dispatch_statement { exe pid last_statement args } {

  if { [string length "$args"] == 0 } {
    return
  } elseif { [string_starts_with "$args" "when "] } {
    dispatch_statement_when "$exe" $pid "When" {*}[string_pop "$args" "when "]
  } elseif { [string_starts_with "$args" "then "] } {
    dispatch_statement_then "$exe" $pid "Then" {*}[string_pop "$args" "then "]
  } elseif { [string_starts_with "$args" "and "] } {
    if { [string equal "$last_statement" "when"] } {
      dispatch_statement_when "$exe" $pid "And" {*}[string_pop "$args" "and "]
    } elseif { [string equal "$last_statement" "then"] } {
      dispatch_statement_then "$exe" $pid "And" {*}[string_pop "$args" "and "]
    } else {
      fail_fatal "unexpected `and' statement after `$last_statement'"
    }
  } else {
    fail_unknown "  $args"
  }

}

# dispatch a `when' step - add your steps here
proc dispatch_statement_when { exe pid prefix args } {

  if { [string_starts_with "$args" "I run with parameters "] } {
    when_I_run_with_parameters "$exe" $pid "$prefix" {*}[string_pop "$args" "I run with parameters "]
  } elseif { [string_starts_with "$args" "I run "] } {
    when_I_run "$exe" $pid "$prefix" {*}[string_pop "$args" "I run "]
  } elseif { [string_starts_with "$args" "I send "] } {
    when_I_send "$exe" $pid "$prefix" {*}[string_pop "$args" "I send "]
  } else {
    fail_unknown "  When $args"
  }

}

# dispatch a `then' step - add your steps here
proc dispatch_statement_then { exe pid prefix args } {

  if { [string_starts_with "$args" "I should see "] } {
    then_I_should_see "$exe" $pid "$prefix" {*}[string_pop "$args" "I should see "]
  } elseif { [string_starts_with "$args" "I should not see "] } {
    then_I_should_not_see "$exe" $pid "$prefix" {*}[string_pop "$args" "I should not see "]
  } elseif { [string_starts_with "$args" "it should return "] } {
    then_it_should_return "$exe" $pid "$prefix" {*}[string_pop "$args" "it should return "]
  } elseif { [string_starts_with "$args" "it should not return "] } {
    then_it_should_not_return "$exe" $pid "$prefix" {*}[string_pop "$args" "it should not return "]
  } elseif { [string_starts_with "$args" "write the output to log"] } {
    then_write_the_output_to_log "$exe" $pid "$prefix" {*}[string_pop "$args" "write the output to log"]
  } else {
    fail_unknown "  Then $args"
  }

}


