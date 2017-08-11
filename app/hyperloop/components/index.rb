class Square < Hyperloop::Component
  param :value
  param :on_handle_click, type: Proc
  param :winner
  
  render do
    class_name = params.winner ? 'bold-square' : 'square'
    BUTTON(class: class_name){params.value}.on(:click) {params.on_handle_click}
  end
end

class Board < Hyperloop::Component
  param :squares
  param :array
  param :on_handle_click, type: Proc
  
  def render_square(i,match) 
    Square(value: params.squares[i], winner: match, on_handle_click: proc { params.on_handle_click(i) })
  end

  render(DIV) do
    DIV(class: 'game-info') do
      "Tic Tac Toe"
    end
    (0..2).each do |x|
      DIV(class: 'board-row') do
        (x*3..(x*3)+2).each {|y|
          (params.array.include? y) ? match = true : match = false
          render_square(y, match)
        }
      end
    end
  end
end

class Game < Hyperloop::Component
  before_mount :initialize_game
  
  def initialize_game
    mutate.history [Array.new(9)]
    mutate.x_is_next true
    mutate.step_number 0
    mutate.order true
    mutate.array [9,9,9]
  end
  
  def who_is_next
    state.x_is_next ? "X" : "O"
  end
  
  def handle_click(i)
    history = state.history[0..state.step_number]
    current = history.last
    squares = current.dup
    return if squares[i] || calculate_winner(squares)
    
    squares[i] = who_is_next
    
    history << squares
    mutate.history history
    mutate.step_number history.length - 1
    mutate.x_is_next !state.x_is_next
  end
  
  def jump_to(step) 
    mutate.step_number step
    mutate.x_is_next((state.step%2) ==0 ? true : false)
  end
  
  def moves(ascending)
    method_name = ascending ? :each : :reverse_each
    (1...state.history.length).send(method_name) do |move|
      class_name = (move == state.step_number && 'game-info-current')
      LI(key: move, class: class_name) do
        A(href: '#'){ "Move ##{move}" }.on(:click) { jump_to(move) }
      end
    end
  end

  render do
    history = state.history
    current = history[state.step_number]
    winner = calculate_winner(current)
    #(winner == nil) ? mutate.array [9,9,9] : mutate.array winner[1]
    mutate.array winner[1] unless winner == nil
    mutate.array [9,9,9] unless winner != nil
    cats = check_cats(current)
    
    if(winner)
      status = "Winner: #{winner[0]}"
    elsif(cats)
      status = "Cat's Game!"
    else
      status = "Next Player: #{who_is_next}"
    end
    
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: current, array: state.array, on_handle_click: proc {|i| handle_click(i)})
      end
      DIV(class: 'game-info') do
        DIV do
          status
        end
        UL do
          moves(state.order)
        end
      end
      DIV(class: 'game-info') do
        DIV do
          A(href: '#'){"New Game"}.on(:click) {initialize_game}
        end unless state.history.length == 1
        DIV do
          A(href: '#'){state.order ? "Descending" : "Ascending"}.on(:click) {mutate.order !state.order}
        end unless state.history.length == 1
      end
    end
  end


WINNING_LINES = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
  ]
  
  def calculate_winner(squares)
    WINNING_LINES.each do |a,b,c|
      return [squares[a], [a,b,c]] if squares[a] && squares[a] == squares[b] && squares[a] == squares[c]
    end
    return nil
  end
  
  def check_cats(squares)
    squares.each {|x| return false if x == nil}
  end
end
