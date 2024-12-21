#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

Room = Data.define(:name, :sector, :checksum) do
  def initialize(sector:, **ks) = super(sector: sector.to_i, **ks)
  def self.parse(str) = Room[*%r{([-a-z]+)-(\d+)\[([a-z]{5})\]}.match(str)[1..]]
  def valid? = checksum == calc_checksum

  def calc_checksum
    counts = name.gsub('-', '').chars.tally
    # sort by count desc, and then character asc
    counts = counts.sort { |(ch1,n1),(ch2,n2)| n1 == n2 ? ch1 <=> ch2 : n2 <=> n1 }
    counts[0,5].map(&:first).join
  end

  A_ORD = 'a'.ord
  def decrypt
    name.chars.map { |ch|
      next(' ') if ch == '-'
      ((((ch.ord - A_ORD) + sector) % 26) + A_ORD).chr
    }.join
  end
end

def run(input, aoc)
  rooms = input.readlines.map { Room.parse it }
  aoc.part1 rooms.select(&:valid?).sum(&:sector)
  aoc.part2 rooms.map { [it.decrypt, it.sector] }.select { |nm,_| nm =~ /north/i }
end
