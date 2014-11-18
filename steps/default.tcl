
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

  pass_step "Given an executable `$exe'"

  dispatch_statement "$exe" 0 "given" {*}"$args"

  send_user "\n"

}

proc when_I_run_with_parameters { exe pid prefix parameters args } {

  if { [ catch { spawn $exe {*}$parameters } ] } {
    fail_step "  $prefix I run with parameters `$parameters'"
    return
  } else {
    pass_step "  $prefix I run with parameters `$parameters'"
  }

  # give the program a bit of time
  after 10

  dispatch_statement "$exe" $spawn_id "when" {*}"$args"

}

proc when_I_run { exe pid prefix args } {

  if { [ catch { spawn $exe } ] } {
    fail_step "  $prefix I run"
    return
  } else {
    pass_step "  $prefix I run"
  }

  # give the program a bit of time
  after 10

  dispatch_statement "$exe" $spawn_id "when" {*}"$args"

}

proc when_I_send { exe pid prefix str args } {

  set spawn_id $pid

  send "$str"

  pass_step "  $prefix I send `[ string trim $str ]'"

  dispatch_statement "$exe" $pid "when" {*}"$args"

}

proc then_I_should_see { exe pid prefix str args } {

  set spawn_id $pid
  expect {

    "$str" {
      pass_step "  $prefix I should see `$str'"
    }

    default {
      fail_step "  $prefix I should see `$str'"
      return
    }

  }

  dispatch_statement "$exe" $pid "then" {*}"$args"

}

proc then_I_should_not_see { exe pid prefix str args } {

  set spawn_id $pid
  expect {

    "$str" {
      fail_step "  $prefix I should not see `$str'"
      return
    }

    default {
      pass_step "  $prefix I should not see `$str'"
    }

  }

  dispatch_statement "$exe" $pid "then" {*}"$args"

}

proc then_it_should_return { exe pid prefix code args } {

  set spawn_id $pid

  # consume input until eof, if any
  if [catch { expect {
    eof { }
    timeout {
      fail_step "  $prefix it should return $code"
      return
    }
  } } ] { return }

  # wait for spawned process
  lassign [wait $pid] wait_pid spawnid os_error_flag value

  if { $os_error_flag == 0 && $value == $code } {
    pass_step "  $prefix it should return $code"
  } else {
    fail_step "  $prefix it should return $code"
    return
  }

  dispatch_statement "$exe" $pid "then" {*}"$args"

}

proc then_it_should_not_return { exe pid prefix code args } {

  set spawn_id $pid

  # consume input until eof, if any
  if [catch { expect {
    eof { }
    timeout {
      fail_step "  $prefix it should return $code"
      return
    }
  } } ] { return }

  # wait for spawned process
  lassign [wait $pid] wait_pid spawnid os_error_flag value

  if { $os_error_flag == 0 && $value != $code } {
    pass_step "  $prefix it should not return $code"
  } else {
    fail_step "  $prefix it should not return $code"
    return
  }

  dispatch_statement "$exe" $pid "then" {*}"$args"

}

proc then_write_output_to_log { exe pid prefix args } {

  set spawn_id $pid

  while 1 {

    expect {
      -re "(\[^\r]*\)\r\n"  { }
      eof                   { break }
      timeout               { break }
    }

  }

  pass_step "  $prefix write output to log"

  dispatch_statement "$exe" $pid "then" {*}"$args"

}
