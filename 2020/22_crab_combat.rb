SMALL = ["9 2 6 3 1", "5 8 4 7 10"]

FULL = ["19 5 35 6 12 22 45 39 14 42 47 38 2 26 13 30 4 34 43 40 16 8 23 50 36",
"1 21 29 41 32 28 9 37 49 20 17 27 24 3 33 44 48 31 15 25 18 46 7 10 11"]

input = FULL

p1, p2 = input.map { |p| p.split.map(&:to_i) }

def play(p1, p2, game=1)
    rounds = []
    winner = nil

    until p1.empty? || p2.empty?
        # puts("\nRound #{rounds.size+1} (Game #{game})\nP1: #{p1.inspect}\nP2: #{p2.inspect}")
        if rounds.include?([p1, p2])
            winner = :p1
            break
        end
        rounds << [p1.dup, p2.dup]

        a = p1.shift
        b = p2.shift
        # puts("P1 plays: #{a}\nP2 plays: #{b}")
        # If both players have at least as many cards remaining in their deck as the value of the card they just drew
        if p1.size >= a && p2.size >= b
            round_winner = play(p1[0...a], p2[0...b], game+1)
        else
            round_winner = a > b ? :p1 : :p2
        end

        # puts("#{round_winner} wins round #{rounds.size} of game #{game}")

        winner_cards = round_winner == :p1 ? p1 : p2
        winner_cards.concat(round_winner == :p1 ? [a,b] : [b,a])
    end

    winner ||= p1.empty? ? :p2 : :p1
    winner
end

winner = play(p1, p2)
winner_cards = winner == :p1 ? p1 : p2

score = winner_cards.reverse.zip(1..).map { |x,y| x*y }.sum
puts "score: #{score}"
