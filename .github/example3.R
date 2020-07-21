options(error = winch::winch_entrace)
#options(error = rlang::entrace)

try(vctrs::vec_as_location(quote, 2))
rlang::last_trace()
