# encoding: utf-8
module Grid
  CornerTL = "\u250C"
  CornerTR = "\u2510"
  CornerBL = "\u2514"
  CornerBR = "\u2518"
  CrossL = "\u251C"
  CrossR = "\u2524"
  CrossT = "\u252C"
  CrossB = "\u2534"
  CrossM = "\u253C"
  LineV = "\u2502"
  LineH = "\u2500"
  LineHLong = "\u2500"*3
end

class Board
include Grid
#####################################
# The purpose of this class is to handle displaying the gamestate of
# board games to the user. This should be usable with any game played on # an n by m grid of squares. Chess notation is used for the coordinate
# system. gamestate is assumed to be a hash with coordinate keys in chess
# notation and up to three-character text values to be displayed in the
# square.
#####################################

  def initialize(width, height)
    @board = ""
    @left_padding = 4
    @width = width
    @height = height
    @divider = "\e[37m\e[47m"
  end

  def construct(gamestate)
    @board = ""

    #labelling columns a-z
    column_counter = 'a'
    @board << "".center(@left_padding, " ")
    @width.times do
      @board << "  #{column_counter} "
      column_counter.next!
    end
    @board << "\n"

    #top border
    @board << top_border_row

    #board rows and middle borders
    @board << content_row(@height, gamestate)
    row_number = @height - 1
    (@height-1).times do
      @board << middle_border_row
      @board << content_row(row_number, gamestate)
      row_number -= 1
    end

    #bottom border
    @board << bottom_border_row

  end

  def display
    print "\n"
    print @board.encode('utf-8')
    print "\n"
  end

  private

  def top_border_row
    border = ""
    border << "".center(@left_padding, " ")
    border << Grid::CornerTL
    border << Grid::LineHLong

    column = 'b'
    (@width-1).times do
      border << Grid::CrossT
      if column == 'e'
        border << @divider
        border << Grid::LineHLong
        border << "\e[0m"
      else
        border << Grid::LineHLong
      end
      column.next!
    end

    border << Grid::CornerTR
    border << "\n"

    return border

  end

  def middle_border_row
    border = ""
    border << "".center(@left_padding, " ")
    border << Grid::CrossL
    border << Grid::LineHLong
    column = 'b'
    (@width-1).times do
      border << Grid::CrossM
      if column == 'e'
        border << @divider
        border << Grid::LineHLong
        border << "\e[0m"
      else
        border << Grid::LineHLong
      end
      column.next!
    end
    border << Grid::CrossR
    border << "\n"
    return border

  end

  def bottom_border_row
    border = ""
    border << "".center(@left_padding, " ")
    border << Grid::CornerBL
    border << Grid::LineHLong

    column = 'b'
    (@width-1).times do
      border << Grid::CrossB
    if column == 'e'
      border << @divider
      border << Grid::LineHLong
      border << "\e[0m"
    else
      border << Grid::LineHLong
    end
    column.next!
    end
    border << Grid::CornerBR
    return border

  end

  def content_row(row_number, gamestate)
    ###MODIFIED FOR MASTERMIND, EXPECTS ANSI COLOR CODES FOR
    ###GAMESTATE VALUES
    row = ""
    row << "#{row_number} ".rjust(@left_padding, " ")
    row << Grid::LineV
    column = 'a'
    (@width).times do
      element = (column+row_number.to_s).to_sym
      row << "#{gamestate[element]}"
      row << Grid::LineV
      column.next!
    end
    row << "\n"
    return row

  end

end
