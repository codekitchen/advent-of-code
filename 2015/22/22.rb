#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../pathfinding'

Boss = Data.define(:hp, :attack) do
  def damage(amt) = self.with(hp: hp-amt)
end
Player = Data.define(:hp, :mana, :effects) do
  def damage(amt) = self.with(hp: hp-amt)
  def armor
    effects.find { it.name == :shield } ? 7 : 0
  end
  def cast(cost, effect=nil)
    self.with(mana: mana-cost, effects: effect ? effects+[effect] : effects)
  end
  def has(eff)
    effects.find { it.name == eff }
  end
end
Effect = Data.define(:name, :timer) do
  def tick
    return nil if timer <= 1
    self.with(timer: timer-1)
  end
end

def run(input, aoc)
  boss = Boss.new(*input.read.scan(/\d+/).map(&:to_i))
  player = Player.new(50, 500, [])
  pdamage = false

  neighbors = ->((p,b,turn),&cb) do
    p = p.damage(1) if turn == :player && pdamage
    next if p.hp <= 0
    nextturn = turn == :player ? :boss : :player

    if p.effects.find { it.name == :poison }
      b = b.damage(3)
    end
    if p.effects.find { it.name == :recharge }
      p = p.with(mana: p.mana+101)
    end

    p = p.with(effects: p.effects.map(&:tick).compact)

    if turn == :boss
      dmg = [1, b.attack-p.armor].max
      cb.([[p.damage(dmg), b, nextturn],0,:boss])
      next
    end
    if p.mana >= 53 # magic missile
      cb.([[p.cast(53), b.damage(4), nextturn],53,:magic_missile])
    end
    if p.mana >= 73 # drain
      cb.([[p.cast(73).with(hp: p.hp+2), b.damage(2), nextturn],73,:drain])
    end
    if p.mana >= 113 && !p.has(:shield) # shield
      cb.([[p.cast(113, Effect[:shield, 6]), b, nextturn],113,:shield])
    end
    if p.mana >= 173 && !p.has(:poison) # poison
      cb.([[p.cast(173, Effect[:poison, 6]), b, nextturn],173,:poison])
    end
    if p.mana >= 229 && !p.has(:recharge) # recharge
      cb.([[p.cast(229, Effect[:recharge, 5]), b, nextturn],229,:recharge])
    end
  end

  results = pathfind(
    starts: [[player, boss, :player]],
    neighbors:,
    solved: ->((_,b,_)) { b.hp <= 0 },
  )

  win, winh = results.find { |(_,b),_| b.hp <= 0 }
  cur, curh = win, winh
  history = []
  while cur
    history.unshift([cur, curh])
    history.unshift([curh.edge])
    cur, curh = curh.prev, results[curh.prev]
  end
  pp(history.map(&:first))

  aoc.part1 winh.cost

  pdamage = true
  results = pathfind(
    starts: [[player, boss, :player]],
    neighbors:,
    solved: ->((_,b,_)) { b.hp <= 0 },
  )

  win, winh = results.find { |(_,b),_| b.hp <= 0 }
  aoc.part2 winh.cost
end
