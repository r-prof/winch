# traceback changed if native code

    Code
      foo_baz
    Output
          x
       1. \-winch (local) foo(baz) at test-add_trace_back.R:26:2
       2.   +-winch::winch_call(fun) at test-add_trace_back.R:14:4
       3.   \-winch (local) `<fn>`()
       4.     \-`/winch.so`::winch_call()
    Code
      as.data.frame(foo_baz)
    Output
                   call parent visible namespace scope
      1        foo(baz)      0    TRUE     winch local
      2 winch_call(fun)      1    TRUE     winch    ::
      3        `<fn>`()      1    TRUE     winch local
      4    winch_call()      3    TRUE /winch.so    ::

