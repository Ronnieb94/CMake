function (busy_loop)
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E sleep
            2)
endfunction ()

file(TIMESTAMP "${test_binary_dir}/build.ninja" orig_time "%Y%m%d%H%M%S")

busy_loop()
# Force NINJA_STATUS to be a certain style to not break the regex.
set(ENV{NINJA_STATUS} "[%s/%t] ")
execute_process(
  COMMAND           "${CMAKE_COMMAND}"
                    --build .
  OUTPUT_VARIABLE   out
  ERROR_VARIABLE    err
  WORKING_DIRECTORY "${test_binary_dir}")
message("-->${out}<--")
message("-->${err}<--")

file(TIMESTAMP "${test_binary_dir}/build.ninja" rerun_time "%Y%m%d%H%M%S")

if (NOT rerun_time GREATER orig_time)
  message(FATAL_ERROR "Ninja did not rerun? (old: ${orig_time}; new: ${rerun_time})")
endif ()

busy_loop()
execute_process(
  COMMAND           "${CMAKE_COMMAND}"
                    --build .
  OUTPUT_VARIABLE   out
  ERROR_VARIABLE    err
  WORKING_DIRECTORY "${test_binary_dir}")
message("-->${out}<--")
message("-->${err}<--")

file(TIMESTAMP "${test_binary_dir}/build.ninja" noop_time "%Y%m%d%H%M%S")

if (NOT rerun_time EQUAL noop_time)
  message(FATAL_ERROR "Ninja found something to do? (old: ${rerun_time}; new: ${noop_time})")
endif ()