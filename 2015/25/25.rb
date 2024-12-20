#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  # first = 20151125
  r, c = input.read.scan(/\d+/).map(&:to_i)
  x, y = c, r

  cn = c * (c+1) / 2
  rn = cn + (r-1)*c + (r-2)*(r-1)/2
  pp rn

  pp((x*(x+1)+2*x*(y-1)+(y-2)*(y-1)) / 2)

  pp((x**2 + y**2 - x + 2*x*y - 3*y + 2)/2)

  pp(x + ((y+x-1) * (y+x-1-1))/2)

  val = 20151125
  (rn-1).times { val = (val * 252533) % 33554393 }

  require 'openssl'
  val2 = OpenSSL::BN.new(252533).mod_exp(rn-1, 33554393)

  results.part1 val
  results.val2 (val2.to_i * 20151125) % 33554393
end
