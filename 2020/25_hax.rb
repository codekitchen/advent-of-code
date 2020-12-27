def transform(subj=7)
    return to_enum(__method__, subj) unless block_given?
    val = 1
    (1..).each do |i|
        val = val * subj
        val = val % 20201227
        yield i, val
    end
end

K1 = 10212254
K2 = 12577395

# K1 = 5764801
# K2 = 17807724

if __FILE__ == $0

k1 = k2 = nil
transform() do |i,v|
    k1 = i if v == K1
    k2 = i if v == K2
    break if k1 && k2
end
puts "#{K1},#{K2} k1 = #{k1} k2 = #{k2}"

puts transform(K1).take(k2).last
puts transform(K2).take(k1).last

end
