#pseudocode
#clue string, guess string
#randomly generate code array
#guess = gets.chomp
#test if win
#generate clues
  #clear past clues
  #split guess string to array
  #clues == guess ? p 'You Won!'

MAX_GUESSES = 4
COLORS = [ '1', '2', '3', '4', '5', '6' ]

module Game
  class << self
    attr_accessor :clue, :guess, :clues, :guesses, :code, :name, :cpu, :user
  end  
end

class Player
  attr_accessor :name
  def initialize(name)
    @name = name
    @wins = 0
    @points = 0
  end
  def name
    name = @name
  end
  def score
    @wins += 1
  end
  def wins
    @wins
  end
  def points
    @points
  end
  def tally(guesses)
    @points = guesses
  end
end

def clear_turn
  Game.clue = []
  Game.clues = []
  Game.guess = []
  Game.guesses = []
  return
end

def win_turn
  p "Code broken! End of turn."
  Game.cpu.tally(Game.guesses.length)
  p "Codemaker score: #{Game.cpu.points}"
  Game.user.score
  p "Codebreaker wins: #{Game.user.wins}"
  return
end

def lose_turn
  p "No guesses left. End of turn"
  Game.cpu.tally(Game.guesses.length)
  p "Codemaker score: #{Game.cpu.points}"
  p "Codebreaker wins: #{Game.user.wins}"
end

def get_clue
  Game.clue = []
  codeClone = Game.code.clone
  guessAry = Game.guess.split('')
  guessAry.each_index { |i|
    if guessAry[i] == codeClone[i]
      Game.clue << 'X'
      guessAry[i] = 'V'
      codeClone[i] = 'W'
    end
  }
  guessAry.each_index { | i |
    p guessAry
    codeClone.each_index { | j |
      if guessAry[i] == codeClone[j]
        guessAry[i] = 'Y'
        codeClone[j] = 'Z'
        Game.clue << 'Z'
      end
    } 
  }  
  Game.clues << Game.clue.join
  return 
end

def wrong_guess
  p Game.guesses
  p Game.clues
  p 'X for a peg with color and spot match.  Z for color only match.'
  p " #{Game.guesses.length} past:"
  Game.guesses.each_index { |i| 
    p "Guess  #{Game.guesses[i]}  Clue #{Game.clues[i]}"
    return
  }
  return
end


def play_codebreaker
  p "Guess the 4-number code.  Possible numbers '1', '2', '3', '4', '5', '6'."
  p "Guess Example: 4122"
  Game.guess = gets.chomp
  if Game.guess.length != 4
    return play_codebreaker
  end
  Game.guesses.push(Game.guess)
  if Game.guess == Game.code.join
    win_turn
  else
    get_clue
    wrong_guess
    if Game.guesses.length >= (MAX_GUESSES)
      lose_turn
    else
      play_codebreaker
    end
  end
  return
end

def cpu_wrong
  if Game.guesses.length == MAX_GUESSES
    p "No guesses left. End of turn"
    Game.user.tally(Game.guesses.length)
    p "Codemaker score: #{Game.user.points}"
    p "Codebreaker wins: #{Game.cpu.wins}"
    return
  end
  Game.guess = Game.guess.join
  get_clue
  p "Provide the clue. 4 letters max. Example: XXZ"
  p "Type an X for each number that matches correct color to location."
  p "Type Z for each number that matches a remaining color to the wrong location."
  p "Enter the Correct clue starting with all of the X's:"
  clue = gets.chomp
  if clue == Game.clue.join
    p "That's Right!"
  else
    p "The clue is #{Game.clue.join}."
  end
  Game.user.tally(Game.guesses.length)
  p "Codemaker score: #{Game.user.points}"
  p "Codebreaker wins: #{Game.cpu.wins}"
  cpu_guess
end

def cpu_guess
  Game.guess = []
  p "#{Game.cpu.name} is guessing..."
  p "~press enter~"
  a = gets.chomp
  guessCount = Game.guesses.length
  if guessCount == 0
    Game.guess = [ COLORS[0], COLORS[0], COLORS[1], COLORS[1] ]
  else
    Game.guesses[ Game.guesses.length - 1 ].split('').each_index {|i|
      if Game.guesses[ Game.guesses.length - 1 ].split('')[i] == Game.code[i]
        Game.guess[i] = Game.guesses[ Game.guesses.length - 1 ].split('')[i]
      else
        Game.guess[i] = COLORS[ rand(6) ]
      end
    }
  end
  Game.guesses << Game.guess.join
  p "Computer guess number #{Game.guesses.length} is #{Game.guess.join}."

  if Game.guess != Game.code
    cpu_wrong
  else
    p "Code broken! End of turn."
    Game.user.tally(Game.guesses.length)
    p "Codemaker score: #{Game.user.points}"
    Game.cpu.score
    p "Codebreaker wins: #{Game.cpu.wins}"
    return
  end
  return
end

def play_codemaker
  p "Enter the 4-number code.  Possible numbers '1', '2', '3', '4', '5', '6'."
  p "Code Example: 2142"
  Game.code = gets.chomp.split('')
  if Game.code.length != 4 
    p "The code is the wrong length."
    play_codemaker
  end
  Game.code.each { |e| 
    if COLORS.include?(e) == false  
      p "Only the possible numbers listed may be used."
      play_codemaker
    end
  }
  cpu_guess
  return
end

def pick_role
  p 'Enter 1 to play as codebreaker, or enter 2 to play as codemaker.'
  choice = gets.chomp
  if choice == '1'
    clear_turn
    Game.code =  [ COLORS[rand(6)], COLORS[rand(6)], COLORS[rand(6)], COLORS[rand(6)] ]
    play_codebreaker
    return
  elsif choice == '2'
    play_codemaker
    return
  else
    pick_role
    return
  end
  return
end

def play_game
  clear_turn
  p "Enter user name"
  name = gets.chomp
  Game.user = Player.new(name)
  p "Welcome #{Game.user.name}"
  p "Enter computer/device name"
  name = gets.chomp
  Game.cpu = Player.new(name)
  p "Codebreaker guesses up to #{MAX_GUESSES} times. Number repeats allowed. No blanks."
  pick_role
  return
end

play_game