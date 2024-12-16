#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

Actor = Struct.new(:hp, :damage, :armor)
Item = Data.define(:name, :cost, :damage, :armor)

Weapons = [
  Item["Dagger",     8,  4, 0],
  Item["Shortsword", 10, 5, 0],
  Item["Warhammer",  25, 6, 0],
  Item["Longsword",  40, 7, 0],
  Item["Greataxe",   74, 8, 0],
]

Armor = [
  Item["None",          0, 0, 0],
  Item["Leather",      13, 0, 1],
  Item["Chainmail",    31, 0, 2],
  Item["Splintmail",   53, 0, 3],
  Item["Bandedmail",   75, 0, 4],
  Item["Platemail",   102, 0, 5],
]

Rings = [
  Item["Damage +1",    25, 1, 0],
  Item["Damage +2",    50, 2, 0],
  Item["Damage +3",   100, 3, 0],
  Item["Defense +1",   20, 0, 1],
  Item["Defense +2",   40, 0, 2],
  Item["Defense +3",   80, 0, 3],
]

def run(input, results)
  player = Actor.new 100, 0, 0
  boss = Actor.new(*input.read.scan(/\d+/).map(&:to_i))

  # I'm guessing pt2 won't be brute forceable, but...
  # edit: nope! I was wrong it's fine.
  best = Float::INFINITY
  Weapons.each do |weap|
    Armor.each do |arm|
      ([[]] + Rings.map { [_1] } + Rings.combination(2).to_a).each do |rings|
        equip = rings+[weap, arm]
        cost = equip.sum { _1.cost }
        next if cost >= best
        best = cost if simulate(player.dup, equip, boss.dup)
      end
    end
  end
  results.part1 best

  worst = 0
  Weapons.each do |weap|
    Armor.each do |arm|
      ([[]] + Rings.map { [_1] } + Rings.combination(2).to_a).each do |rings|
        equip = rings+[weap, arm]
        cost = equip.sum { _1.cost }
        next if cost < worst
        worst = cost unless simulate(player.dup, equip, boss.dup)
      end
    end
  end
  results.partw worst
end

def simulate(player, equipment, boss)
  equipment.each do |item|
    player.damage += item.damage
    player.armor += item.armor
  end

  while player.hp > 0 && boss.hp > 0
    dmg = [1, player.damage - boss.armor].max
    boss.hp -= dmg
    break if boss.hp <= 0

    dmg = [1, boss.damage - player.armor].max
    player.hp -= dmg
  end
  player.hp > 0
end
