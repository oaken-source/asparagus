
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

 # This file contains the step pretty print methods of asparagus.
 ############################################################################## 

# print a passed step to the output stream, cucumber style, and call `pass'
#   if in verbose mode, print the complete step message, else only '.'
proc pass_step { str } {

  if { [ info exists ::env(VERBOSE) ] } {
    send_user "$str\n"
    pass "$str"
  } else {
    send_user "."
    pass "."
  }

}

# print a failed step to the output stream, and call `fail'
proc fail_step { str } {

  global test_name

  if { [ info exists ::env(VERBOSE) ] } {
    fail "$test_name : $str"
  } else {
    send_user "\n"
    fail "$test_name : $str"
  }

}

# this is used when something is wrong - syntax errors and the likes.
#   print the message to the output stream and exit the test
proc fail_fatal { str } {

  global test_name

  send_user " !!!! FATAL : $test_name : [string range \"$str\" 0 60]...'\n"
  exit 1

}


