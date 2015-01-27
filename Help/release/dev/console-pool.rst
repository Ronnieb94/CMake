console-pool
------------

* The :command:`add_custom_command` and :command:`add_custom_target`
  commands learned a new ``USES_TERMINAL`` option to request that
  the command be given direct access to the terminal if possible.
  The :generator:`Ninja` generator will places such commands in the
  ``console`` pool.  Build targets provided by CMake that are meant
  for individual interactive use, such as ``install``, are now
  placed in this pool.
