# Guide for fish shell
#
# The fish shell has a different structure and syntax than its more primitive
# forebears.  It provides advanced syntax highlighting, better function
# definition, and a more customizeable experience in exchange for greater
# complexity.

# Lifecycle
# When a fish shell is entered, it begins by executing code located in
# ~/.config/fish/config.fish.  This file behaves like an init script, and
# should contain all customizations.  Furthermore, fish foregoes aliasing and
# instead allows the user to define functions, via
#   function <name
#       <internals>
#       .
#       .
#       ,
#   end
# with arguments passed via the $argv list.  All functions can be listed via
# the "functions" command, and the definition of a function can be viewed via
# "functions <name>".  To define the function <name>, place its definition in
# ~/.config/fish/functions/<name>.fish.  When the shell encounters a command it
# doesn't recognize, it looks in this file.
# The 'man' command gets general fish help.  'man <command>' displays any
# help available about a given command.

# Usage
# Commands in fish are run the same way as any other shell.  The format
#   $> <command> <arg1> <arg2> ...
# first checks the function list (described above) to see if the command has
# been defined as a fish subroutine, and if not, looks for a corresponding
# binary in all locations within the $PATH list, then runs it.  Note that the
# output from one command can be routed into another using the standard
# symbols, e.g |, <, >, >2 as usual.
# In addition to the standard wildcard (*), fish offers both multiple wildcards
# in one line, as well as a special wildcard (**), which recursively checks
# through all directories as long as the final path fits the definition.  This
# expansion returns a list of all values which fit.
# Fish also provides a very sophisticated autocompletion mechanism, suggesting
# previously run commands and command line options in addition to the standard
# next directory layer.  Pressing tab cycles through possible options for the
# next argument, whether these be command line flags or directories.  Pressing
# the right arrow accepts the suggested command, where alt+right arrow only
# accepts the next word of it.

# Variables
# Fish variables have three classes and two types.  The classes are local,
# global, and universal - local specific to one command block, global specific
# to a fish session, and universal persisting across all fish sessions on a
# given machine (they are placed in ~/.config/fish/fish_variables). We set the
# different classes via
#   $> set -l <var> <val>       local
#   $> set -g <var> <val>       global
#   $> set -U <var> <val>       universal
# and unset them via
#   $> set -e <var>
# Note that if a variable has been previously defined, its classification will
# be honored.  Otherwise, setting it without a flag defaults to local.
# Finally, note that fish variables can be specifically set as environment
# (exported) or non-environment via the -x and -u flags, with default being
# non-environment.  Thus exporting a local variable looks like:
#  $> set -x <var> <val>
# though as it is local, any changes made to it after the export will not
# follow.  Global variables, on the other hand, are always accessible to
# functions whether they are exported or not.
# Variables may be of two types - strings and lists.  A string is created by
# placing an item inside quotes - double quotes if we want variables inside to
# be expanded, single quotes otherwise.
#  $> set var "This and $that"          expands $that
#  $> set var 'This and $that'          doesn't expand $that
# Lists are created by placing multiple variables together separated by spaces
# but without quotes.
#  $> set var This and $that            List with three items, including $that
# or via brackets
#  $> {$item1, $item2, "constant"}
# Lists can only go one layer deep, so items can be appended to one via
#  $> set $list $list <item>
# When lists are placed adjacent without a space, their cartesian product
# results
#  $> $l1$l2                expands to $l1[1]$l2[1] $l1[1]$l2[2] etc...
# And placing one beside a string yields the scalar product
#  $> $l1"string"           expands to "$l1[1]string" "$l1[2]string" etc...
# Note that individual list items can be erased via 'set -e <item>'
# Strings can be split into arrays via 'string split $<var>', and the syntax
# '$<list> $<value>' is equivalent to a new list with $<value> appended.
# Taking values from lists follows the python model, with $list[<i>..<j>]
# representing a range and $list[-1] retrieving the last item in a list.  Note'
# however than indices begin at 1, so $list[1..-1] represents the whole list.
# Conversely, a sequence of numbers can be made into a list via seq <x>, which
# creates a list of all numbers 1 through <x> inclusive.
# To create multiple layers of list, use multiple $ operators, a la
# $> $$list[1][2]
# Several fish variables have special status.  The $status variable contains
# the exit status of the previous command.  In addition, $PATH, $CDPATH, and
# $MANPATH are all represented as lists rather than colon-separated strings.

# Control flow
# Fish control flow looks like a blend of bash and python.  It delineates
# blocks via indentation, but allows chaining of command via ';'.  It provides
# &&. ||, and ! as high precedence boolean operators, but 'and', 'or', and
# 'not' as lower precedence ones, with the 'true' and 'false' macros both
# providing the expected functionality and leaving their values in the $status
# variable.  Finally, it uses parentheses rather than backticks to represent
the evaluation of a command, though this sytax does not apply within strings.
# The most basic control operator is the boolean:
#   if <condition>
#       <do something>
#   else if <condition>
#       <do something else>
#   else
#       <do the default thing>
#   end
# Note that the condition can use any of the boolean operators described above,
# though comparisons require
#   test $<v1> <operator> $<v2>
# where the operator is one of '=', '-gt', or '-lt'.  As an alternative to the
# if syntax, the switch statement
#   switch (<command>)
#   case <val1>
#       <do this>
#   case <val2> <val3>
#       <do that>
#   end
# allows specification of options for several groups of values.  Note that
# unlike many languages, this switch does not fall through, and taking lists
# as arguments allows the usage of any combination of wildcards
# Finally, iterations are performed either via for loop:
#   for val in $list:
#       <something with $val>
#   end
# or while loops:
#   while <condition>
#       <do something>
#   end

# Built-in Functions
# set_color <value>            Sets the current print color
#   set_color purple
#   set_color FF0
#   set_color normal
# date <format>                 Returns/prints the formatted date
#   date "+%m/%d/%y"

# Prompt
# The user can customize the fish prompt by defining the 'fish_prompt
# function.
