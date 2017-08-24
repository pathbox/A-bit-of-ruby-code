SU_TOKEN = 12345

def id2code(id)
  (id * SU_TOKEN).to_s(21)
end
#根据code得到id
def code2_id(code)
  i = code.to_i(21)
  return nil if (i % SU_TOKEN) != 0
  i / SU_TOKEN
end
