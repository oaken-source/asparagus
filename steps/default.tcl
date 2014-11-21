
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


proc given_an_executable { exe args } {

  global asparagus_executable_path

  set asparagus_executable_path "$exe"

  pass_step

}

proc when_I_run_with_parameters { parameters args } {

  global asparagus_executable_path
  global asparagus_spawn_id

  if { [ catch { spawn $asparagus_executable_path {*}$parameters } msg ] } {
    fail_step "$msg"
    return
  } else {
    pass_step
  }

  # give the program a bit of time
  after 10

  set asparagus_spawn_id "$spawn_id"

}

proc when_I_run { args } {

  global asparagus_executable_path
  global asparagus_spawn_id

  if { [ catch { spawn $asparagus_executable_path } msg ] } {
    fail_step "$msg"
    return
  } else {
    pass_step
  }

  # give the program a bit of time
  after 10

  set asparagus_spawn_id "$spawn_id"

}

proc when_I_send { str args } {

  global asparagus_spawn_id

  set spawn_id "$asparagus_spawn_id"

  if { [ catch { send "$str" } msg ] } {
    fail_step "$msg"
    return
  } else {
    pass_step
  }

}

proc then_I_should_see { str args } {

  global asparagus_spawn_id

  set spawn_id "$asparagus_spawn_id"

  expect {

    "$str" {
      pass_step
    }

    default {
      fail_step
      return
    }

  }

}

proc then_I_should_not_see { str args } {

  global asparagus_spawn_id

  set spawn_id "$asparagus_spawn_id"

  expect {

    "$str" {
      fail_step
      return
    }

    default {
      pass_step
    }

  }

}

proc then_it_should_return { code args } {

  global asparagus_spawn_id

  set spawn_id "$asparagus_spawn_id"

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

  if { $os_error_flag == 0 && $value == $code } {
    pass_step
  } else {
    fail_step "returned $os_error_flag : $value"
    return
  }

}

proc then_it_should_not_return { code args } {

  global asparagus_spawn_id

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

  if { $os_error_flag == 0 && $value != $code } {
    pass_step
  } else {
    fail_step "returned $os_error_flag : $value"
    return
  }

}

proc then_write_the_output_to_log { args } {

  global asparagus_spawn_id

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
