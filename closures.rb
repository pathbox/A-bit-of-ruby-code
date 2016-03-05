def run_proc(p)
  p.call
end

name = "Frank"
print_a_name = proc { puts name}
run_proc print_a_name