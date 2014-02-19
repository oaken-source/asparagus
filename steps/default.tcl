
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

}

proc when_I_run_with_parameters { exe pid prefix parameters args } {

  spawn $exe $parameters

  pass_step "  $prefix I run with parameters `$parameters'"

  dispatch_statement "$exe" $spawn_id "when" {*}"$args"

}

proc when_I_run { exe pid prefix args } {

  spawn $exe

  pass_step "  $prefix I run"

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