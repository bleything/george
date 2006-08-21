# yoinked and modified from http://blade.nagaokaut.ac.jp/~sinara/ruby/math/combinatorics/array-comb-inj.rb

def combine(set, n = 2)
  if set.size < n or n <= 0
    return [[]]
  else
    out = []
    
    combine((0...set.size).to_a, n-1).each do |x|
      ((x.empty? ? 0 : x.last + 1)...set.size).each do |i|
        out << set.values_at(*(x + [i]))
      end
    end
  end
  
  return out
end