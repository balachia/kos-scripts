// This file is distributed under the terms of the MIT license, (c) the KSLib team
// Originally developed by abenkovskii

@LAZYGLOBAL OFF.

log "" to _execute.internal.
delete _execute.internal.
log "" to _execute.tmp.
delete _execute.tmp.
log "" to _execute.init.
delete _execute.init.

log "{}" to _execute.tmp.
log "run _execute.tmp." to _execute.internal.

global _execute__empty_string is "".

log
  "run _execute.internal. " +
  "function execute" +
  "{" +
    "parameter command. " +
    "log _execute__empty_string to _execute.tmp. " +
    "delete _execute.tmp. " +
    "log command to _execute.tmp. " +
    "run _execute.internal. " +
    "log _execute__empty_string to _execute.tmp. " +
    "delete _execute.tmp. " +
  "}"
to _execute.init.
run _execute.init.

delete _execute.init.
delete _execute.internal.
delete _execute.tmp.
