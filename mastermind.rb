# encoding: utf-8
require "./board.rb"
class Mastermind


  def initialize
    @Peg = "\u25C9"
    @EndColor = "\e[0m"
    @gamestate = Hash.new
    @colors = {red: "\e[31;1m", blue: "\e[34;1m",
              green: "\e[32;1m", yellow: "\e[33;1m",
               white: "\e[37;1m", cyan: "\e[36;1m"}
    @width = 9
    @height = 12
    @board = Board.new(@width, @height)
    @turn = 1
    @current_answer = []
    @code_board = Board.new(4, 1)
    @code_board_state = Hash.new
    board_setup
    @code = generate_code
    p @code
    self.play
  end

  def board_setup
    column = 'a'
    @width.times do
      row = '1'
      @height.times do
        element = (column+row).to_sym
        if column == 'e'
          @gamestate[element] = "\e[47m   \e[0m"
        else
          @gamestate[element] = "   "
          @code_board_state[element] = "   "
        end
        row.next!
      end
      column.next!
    end
  end

  def place_peg(square, color)
    content = @colors[color] + @Peg + @EndColor
    @gamestate[square] = " #{content} "
  end

  def player_input
    puts "Select a peg colour!"
    puts "    1 - Red"
    puts "    2 - Blue"
    puts "    3 - Yellow"
    puts "    4 - Green"
    puts "    5 - White"
    puts "    6 - Cyan"

    valid = false

    until valid == true
      valid = true
      choice = gets.chomp.to_i
      if choice.between?(1, 6)
        return num_to_col(choice)
      else
        puts "Try again!"
        valid = false
      end
    end
  end

  def generate_code
    code = []
    column = 'a'
    peg = 0
    4.times do
      code[peg] = num_to_col(rand(1..6))
      square = (column + 1.to_s).to_sym
      @code_board_state[square] = " #{@colors[code[peg]] + @Peg + @EndColor} "
      column.next!
      peg +=1
    end
    return code
  end

  def num_to_col(num)
    case num
    when 1
      return :red
    when 2
      return :blue
    when 3
      return :yellow
    when 4
      return :green
    when 5
      return :white
    when 6
      return :cyan
    end
  end

  def update_board(peg, choice)
    column = ''
    case peg
    when 1
      column = 'a'
    when 2
      column = 'b'
    when 3
      column = 'c'
    when 4
      column = 'd'
    end

    square = (column + @turn.to_s).to_sym
    place_peg(square, choice)

  end

  def check_code
    answer_column = 'f'
    peg = 0
    remaining_code = []
    remaining_answer = []

    4.times do
      answer_square = (answer_column + @turn.to_s).to_sym
      if @current_answer[peg] == @code[peg]
        place_peg(answer_square, :red)
        answer_column.next!
      else
        remaining_code << @code[peg]
        remaining_answer << @current_answer[peg]
      end
      peg += 1
    end

    remaining_answer.each do |answer_peg|
      answer_square = (answer_column + @turn.to_s).to_sym
      if remaining_code.include?(answer_peg)
        place_peg(answer_square, :white)
        index = remaining_code.find_index(answer_peg)
        remaining_code.delete_at(index)
        answer_column.next!
      end
    end
  end

  def victory_check
    if @current_answer == @code
      return true
    else
      return false
    end
  end

  def play
    victory_state = false
    @board.construct(@gamestate)
    @board.display
    until @turn == 13 || victory_state == true
      peg = 0
      4.times do
        choice = player_input
        @current_answer[peg] = choice
        update_board(peg + 1, choice)
        peg += 1
      end
      victory_state = victory_check
      check_code
      @board.construct(@gamestate)
      @board.display
      @turn += 1
    end

    if victory_state == true
      puts "You won!"
    else
      puts "You lost!"
    end
    puts "The code was: "
    @code_board.construct(@code_board_state)
    @code_board.display
  end

end


test = Mastermind.new
