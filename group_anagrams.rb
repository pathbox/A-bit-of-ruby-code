# Given an array of string, group anagrams together
# For example ["eat","tea","tan","ate","nat","bat"]
# Return:
# [
#  ["ate","eat","tea"],
#  ["nat","tan"],
#  ["bat"]
# ]
strs = %( eat tea tan ate nat bat)
def group_anagrams(strs)
  strs.inject(Hahs.new([])) do |sum, item|
    h[item.chars.sort.join] += [s]  # "eat".chars => 'e','a','t' => .sort => "aet".join => "aet"(the key)
    h  # {"aet"=>["eat", "tea", "ate"], "ant"=>["tan", "nat"], "abt"=>["bat"]}
  end.map{ |k,v| v.sort}
end

# use a hash store the array