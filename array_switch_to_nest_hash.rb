# a way to switch array to nest hash
def array_switch_to_nest_hash(ary, h)
 len = ary.size
 i = 0
 t = h[ary[0]]
  while i < len -2
    t = t[ary[i]] if i != 0
    if i+2 == len - 1
      t[ary[i+1]] = {ary[i+2] => "value"}
    else
      t[ary[i+1]] = {ary[i+2] => {}}
    end
    i = i+1
    if i == len
      break
    end
  end
  h
end

 # ary = ['b1','b2','b3', 'b4','b5', 'b6', 'b7']
 ary = "home.dash.menu.name.age".split(".")
 h = {ary[0] => {ary[1]=>{}}}
 hash = array_switch_to_hash(ary, h)
 p hash # {"home"=>{"dash"=>{"menu"=>{"name"=>{"age"=>"value"}}}}}
