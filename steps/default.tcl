
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

 # This is the list of default steps provided by asparagus.
 ##############################################################################


### given an executable ?exe?
#
# sets the global `asparagus_executable_path` to the given path and passes.
proc given_an_executable { exe } {

  global asparagus_executable_path

  set asparagus_executable_path "$exe"

  pass_step

}
asparagus_register_step given_an_executable "given an executable"

### when I run with parameters ?parameters?
#
# spawns the executable stored in `asparagus_executable_path`, which should be
# set by `given an executable`, with the given cli parameters and stores the
# spawn id in the global variable `asparagus_spawn_id`.
#
# If the spawn command throws an error, the step fails, otherwise is passes
proc when_I_run_with_parameters { parameters } {

  global asparagus_executable_path
  global asparagus_spawn_id

  set asparagus_spawn_id ""

  if { [ catch { spawn $asparagus_executable_path {*}$parameters } msg ] } {
    fail_step "$msg"
    return
  }

  # give the program a bit of time
  after 10

  set asparagus_spawn_id "$spawn_id"

  pass_step

}
asparagus_register_step when_I_run_with_parameters "when I run with parameters"

### when I run
#
# spawns the executable stored in `asparagus_executable_path`, which should be
# set by `given an executable`, and stores the spawn id in the global variable
# `asparagus_spawn_id`.
#
# If the spawn command throws an error, the step fails, otherwise it passes
proc when_I_run { } {

  global asparagus_executable_path
  global asparagus_spawn_id

  set asparagus_spawn_id ""

  if { [ catch { spawn $asparagus_executable_path } msg ] } {
    fail_step "$msg"
    return
  }

  # give the program a bit of time
  after 10

  set asparagus_spawn_id "$spawn_id"

  pass_step

}
asparagus_register_step when_I_run "when I run"

### when I send ?string?
#
# send input to stdin of the process identified by the global variable
# `asparagus_spawn_id`, which should be set by the `when I run` step family.
#
# If the send throws an error, the step fails, otherwise it passes
proc when_I_send { str } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id "$asparagus_spawn_id"

  if { [ catch { send "$str" } msg ] } {
    fail_step "$msg"
    return
  }

  pass_step

}
asparagus_register_step when_I_send "when I send"

### then I should see ?string?
#
# expect output from the process identified by the global variable
# `asparagus_spawn_id`, which should by set by the `when I run` step family.
#
# If the expect throws an error or the string is not seen, the step fails,
# otherwise it passes.
proc then_I_should_see { str } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id "$asparagus_spawn_id"

  if { [ catch { expect {

    "$str" { }
    default {
      fail_step "not seen"
      return
    }

  } } msg ] } {
    fail_step "$msg"
    return
  }

  pass_step

}
asparagus_register_step then_I_should_see "then I should see"

### then I should not see ?string?
#
# expect output from the process identified by the global variable
# `asparagus_spawn_id`, which should be set by the `when I run` step family.
#
# If the expect throws an error, or the string is seen, the step fails,
# otherwise it passes.
proc then_I_should_not_see { str } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id "$asparagus_spawn_id"

  if { [ catch { expect {

    "$str" {
      fail_step "seen"
      return
    }
    default { }

  } } msg ] } {
    fail_step "$msg"
    return
  }

  pass_step

}
asparagus_register_step then_I_should_not_see "then I should not see"

### then it should return ?code?
#
# expect the program identified by `asparagus_spawn_id` to terminate and
# return the given return code.
#
# If the program does not terminate within a set time, or returns a code that
# is not the given one, the step fails, otherwise it passes.
proc then_it_should_return { code } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id "$asparagus_spawn_id"

  # consume input until eof, if any
  if [ catch { expect {
    eof { }
    timeout {
      fail_step "timed out"
      return
    }
  } } ] { }

  # wait for spawned process
  lassign [wait $asparagus_spawn_id] wait_pid spawnid os_error_flag value

  if { $os_error_flag != 0 || $value != $code } {
    fail_step "returned $os_error_flag : $value"
    return
  }

  pass_step

}
asparagus_register_step then_it_should_return "then it should return"

### then it should not return ?code?
#
# expect the program identified by `asparagus_spawn_id` to terminate and
# return the given return code.
#
# If the program does not terminate within a set time, or returns a code that
# is equal to the given one, the step fails, otherwise it passes.
proc then_it_should_not_return { code } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id $asparagus_spawn_id

  # consume input until eof, if any
  if [catch { expect {
    eof { }
    timeout {
      fail_step "timed out"
      return
    }
  } } ] { }

  # wait for spawned process
  lassign [wait $asparagus_spawn_id] wait_pid spawnid os_error_flag value

  if { $os_error_flag != 0 || $value == $code } {
    fail_step "returned $os_error_flag : $value"
    return
  }

  pass_step

}
asparagus_register_step then_it_should_not_return "then it should not return"

### then write the output to log
#
# capture all output produced by the spawned process identified by
# `asparagus_spawn_id` and send it to the log file and pass.
proc then_write_the_output_to_log { } {

  global asparagus_spawn_id

  if { ! [ string length $asparagus_spawn_id ] } {
    fail_step "not open"
    return
  }

  set spawn_id $asparagus_spawn_id

  while 1 {

    expect {
      -re "(\[^\r]*\)\r\n"  { }
      eof                   { break }
      timeout               { break }
    }

  }

  pass_step

}
asparagus_register_step then_write_the_output_to_log "then write the output to log"
