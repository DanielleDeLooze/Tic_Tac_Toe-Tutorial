### Tic Tac Toe Tutorial
This tutorial is based of a previously made tutorial for React. The main purpose in creating this was to convert between React
and Hyperloop to highlight their similarities and differences. If you'd like to look at the React tutorial I am basing this off of, you can find it [here](https://facebook.github.io/react/tutorial/tutorial.html)

In this tutorial I used a service called Cloud9 to set up the Hyperloop enviroment. I would recommend using this so that you can see the effect of the changes that you make right next to your code. To learn how to set this up, look in the file titled "Cloud9-setup.md".

### Setting Up the Initial Files

To start this up, we're going to create two new files. The first one is going to be a css stylesheet. Create a new css file /app/assets/stylesheets/index.css. Because css files will not change between React and Hyperloop, we can just copy the [original file](https://codepen.io/gaearon/pen/oWWQNa?editors=0100) and paste it into index.css. This file will provide the style specifications that will be displayed in our game.

The second file is going to be a ruby file. Create a ruby file /app/hyperloop/components/index.rb. Now setting this one up is going to be more involved than the css file because we need to translate from the original Javascript file to Ruby. But first let's make one more change. In the file routes.rb in config/routes.rb you're going to want to change the line 
```ruby
get '/(*other)', to: 'hyperloop#app'
```
to
```ruby
get '/(*other)', to: 'hyperloop#game'
```
This just changes which class is being looked at to render first. It was originally defaulting to a file that was created from the clone-and-go, but we don't want that anymore.

Now that that's been fixed, let's tackle the Javascript! I've put the original Javascript file down below and we'll go through it piece by piece.

```javascript
class Square extends React.Component {
  render() {
    return (
      <button className="square">
        {/* TODO */}
      </button>
    );
  }
}

class Board extends React.Component {
  renderSquare(i) {
    return <Square />;
  }

  render() {
    const status = 'Next player: X';

    return (
      <div>
        <div className="status">{status}</div>
        <div className="board-row">
          {this.renderSquare(0)}
          {this.renderSquare(1)}
          {this.renderSquare(2)}
        </div>
        <div className="board-row">
          {this.renderSquare(3)}
          {this.renderSquare(4)}
          {this.renderSquare(5)}
        </div>
        <div className="board-row">
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
        </div>
      </div>
    );
  }
}

class Game extends React.Component {
  render() {
    return (
      <div className="game">
        <div className="game-board">
          <Board />
        </div>
        <div className="game-info">
          <div>{/* status */}</div>
          <ol>{/* TODO */}</ol>
        </div>
      </div>
    );
  }
}

// ========================================

ReactDOM.render(
  <Game />,
  document.getElementById('root')
);
```

Let's start going through this from the bottom to the top, since that will make it a little easier to understand what is going on. The very last bit of code,
```javascript 
ReactDOM.render(
  <Game />,
  document.getElementById('root')
);
```
is actually accomplished by the small change we made earlier to the routes.rb file! So we can just leave this part out completely from our Ruby file. 

The next part is the Game class. This part is pretty simple. It's rendering the board by calling upon the board class, which in turn calls the square class to return each individual square of the tic tac toe board. It is also setting up the section to display game info (moves, new-game button, etc.). Translating this to ruby will give you this
```ruby
class Game < Hyperloop::Component
  
  render do
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board()
      end
      DIV(class: 'game-info') do
        DIV do
          
        end
        OL do
          
        end
      end
    end
  end
end
```
It's similar to the original Javascript version, but it looks neater doesn't it? We've gotten rid of the return statement completely as this is not necessary in ruby. Ruby will return implicitly.


Let's now look at the Board class. The first method, renderSquare(i) is just calling the Square class to render each individual sqaure. The render method in this class is setting up the squares in a 3x3 format and assigning each square is number. It is going to display "Next Player: X" above the board as well. Again, the translation isn't too different.
```ruby
class Board < Hyperloop::Component
  
  def render_square(i) 
    Square()
  end
  
  render(DIV) do
    DIV(class: 'status') do
      "Next Player: 'X'"
    end
    DIV(class: 'board-row') do
      render_square(0)
      render_square(1)
      render_square(2)
    end
    DIV(class: 'board-row') do
      render_square(3)
      render_square(4)
      render_square(5)
    end
    DIV(class: 'board-row') do
      render_square(6)
      render_square(7)
      render_square(8)
    end
  end
end
```
We no longer need the this in front of all the render_squares because ruby will assume this. I've also gotten rid of the status constant and just added it to the DIV block. 

Finally we have the Square class. All square is going to do is render a button that's following the design specifications of the square section of the css file we copied earlier. This will be a really short class!
```ruby
class Square < Hyperloop::Component
  
  render do
    BUTTON(class: 'square'){}
  end
end
```
Short and simple!

Now you'll want to copy and paste (or type) each of these three classes into your index.rb file. With all of the classes together, your index.rb file be similar to this (the order shouldn't matter)
```ruby
class Square < Hyperloop::Component
  
  render do
    BUTTON(class: 'square'){}
  end
end

class Board < Hyperloop::Component
  
  def render_square(i) 
    Square()
  end
  
  render(DIV) do
    DIV(class: 'status') do
      "Next Player: 'X'"
    end
    DIV(class: 'board-row') do
      render_square(0)
      render_square(1)
      render_square(2)
    end
    DIV(class: 'board-row') do
      render_square(3)
      render_square(4)
      render_square(5)
    end
    DIV(class: 'board-row') do
      render_square(6)
      render_square(7)
      render_square(8)
    end
  end
end

class Game < Hyperloop::Component
  
  render do
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board()
      end
      DIV(class: 'game-info') do
        DIV do
          
        end
        OL do
          
        end
      end
    end
  end
end
```


Make sure to save! If you click 'preview' and select 'preview running application' you should see an empty tic tac toe board. It should look like this

![image of first square](https://user-images.githubusercontent.com/27837941/27690652-f05e8d38-5caf-11e7-88e5-15ec09ee2539.png)

Congratulations! You've now got a working Hyperloop application.

### Passing Data Through Params

Let's mess around with it a little bit to make sure everything is working alright. We're going to display the position/value of each square in it's center. To accomplish this, we're going to introduce params. Params are equivalent to props in React. We will be using params to pass info from one class to another. In this case, we're going to use it to pass the position info from the Board class to the Square class. To do this in React we'd have this code

```javascript
class Square extends React.Component {
  render() {
    return (
      <button className="square">
        {this.props.value}
      </button>
    );
  }
}
class Board extends React.Component {
  renderSquare(i) {
    return <Square value={i} />;
  }
```

In ruby this will be slightly different. We'll need to declare the params directly in the Square class. So we'll add a params declartion to the Square class and then pass in the i value to it from Board. But aside from that, the two are almost identical!

```ruby
class Square < Hyperloop::Component
  param :value
  
  render do
    BUTTON(class: 'square'){"#{params.value}"}
  end
end

class Board < Hyperloop::Component
  
  def render_square(i) 
    Square(value: i)
  end
```

After adding these changes to your file, your board should now have numbers in each of the squares like this
![Squares with Numbers in them](https://user-images.githubusercontent.com/27837941/27692964-0b257ce8-5cb6-11e7-9003-e318b071a0fa.png)

Now that we've got the bare bones of a tic tac toe game and we know we can pass in data using params, it's time to spice this up a little

### Adding Interactive Components
To start slow, let's make it so that when you click on one of the squares you'll get an alert letting you know you've clicked on the button. Using ruby all we need to do is add an event handler called on(:click). I'm just going to show the ruby version here because the javascript version is essentially the same, the syntax just changes slightly.
```ruby
class Square < Hyperloop::Component
  param :value
  
  render do
    BUTTON(class: 'square'){"#{params.value}"}.on(:click) {alert "Button has been clicked!"}
  end
end
```
After adding this short bit of code, this message should now pop up everytime you click one of the squares (obviously with your cloud9 username instead of mine)

![Button Alert Pop-up](https://user-images.githubusercontent.com/27837941/27694319-c4243394-5cb9-11e7-8df6-309b8a996802.png)

Now that we know our board will react to being clicked, we should have it do something more useful when it's pressed. We're going to have the squares display an 'X' when they are pressed. To do this, we'll use a state variable. Hyperloop will rerender the application whenever a state variable changes. This is useful here because we can have the buttons change a state variable when pressed which will cause the board to rerender and show the new 'X'. This is a good spot to highlight some differences between React and Hyperloop. Let's look at the React code to do this

```javascript
class Square extends React.Component {
  constructor() {
    super();
    this.state = {
      value: null,
    };
  }

  render() {
    return (
      <button className="square" onClick={() => this.setState({value: 'X'})}>
        {this.state.value}
      </button>
    );
  }
}
```
In React, as you can see to declare a state you need to explicitly call the constuctor() and super(). However in Hyperloop and ruby this is not necessary. We can just mutate a variable to a set value and it will assume that this new variable is a state. So to accomplish the same thing in Hyperloop all we need add to the Square class is this
```ruby
class Square < Hyperloop::Component
  mutate.value null
  
  render do
    BUTTON(class: 'square'){state.value}.on(:click) {mutate.value 'X'} 
  end
end
```
That seems a lot simplier, right? We just need that one new line of code as opposed to the six new lines added in React. You're also going to want to change the Square call in Board to just `Square()` from the `Square(value: i)` that we set before. This is because i does not need to be assigned to value at the moment. Mutate is used to change the value of state variables. It serves the same purpose as `this.setState` in React. At this point, Square and the first part of Board should look like this
```ruby
class Square < Hyperloop::Component
  mutate.value null
  
  render do
    BUTTON(class: 'square'){state.value}.on(:click) {mutate.value 'X'}
  end
end

class Board < Hyperloop::Component
  
  def render_square(i) 
    Square()
  end
```
With these changes, whenever you press a square a 'X' should be showing up in the middle of it! Keep in mind that if you click the square for a second time, nothing should happen. This is because when you click the square our program is only mutating the value to 'X'. If you clicked all 9 squares it would look like this

![X's in the Board](https://user-images.githubusercontent.com/27837941/27696132-de478690-5cbe-11e7-9caf-e1c47c93ba07.png)

### Moving on Up

This is slowly starting to look more like a tic tac toe game! But before we add more new features we should refactor this. Right now we have the Square class taking care of the X state. But the Square class will only deal with one square at a time. This is a problem because later on we're going to need to compare all 9 squares to each other to determine if there is a winner. To remedy this problem, let's move the state up to the Game class. We're going to move it to Game instead of Board because both Board and Square are only going to be used to render the tic tac toe board. Everything dealing with the game will be taken care of in the Game class

In order to do this, we're going to create a method in the Game class that will handle the action that will take place when a button is pressed. We'll call this handle_click. This method will be passed in from Game to Board as a proc, and it will be passed from Board to Square as well. Since we're moving the data out of Board and Square class, we'll have to pass it back in as params to render it. So let's see what this will look like. Here's the Game class
```ruby 
class Game < Hyperloop::Component
  before_mount :initialize_game
  
  def initialize_game
    mutate.squares Array.new(9)
  end
  
  def handle_click(i)
    squares = state.squares.dup #why do this
    squares[i] = 'X'
    mutate.squares squares
  end

  render do
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: state.squares, on_handle_click: proc {|i| handle_click(i)})
      end
      DIV(class: 'game-info') do
        DIV do
          
        end
        OL do
          
        end
      end
    end
  end
end
```
The before_mount that we've added means that before Hyperloop will render anything, it will run the initialize_game method first. Initialize_game is just creating a new state variable called squares. This variable will be keeping track of the number of 'X's in the board. It will start out as a nil array of length 9. Next you can see our new method handle_click(i). This method duplicates the squares state variable, then changes the entry at the i-th index to 'X', then mutates the squares state to reflect this. The last change we've made to our Game class can be seen in the render method. We now pass in handle_click(i) as a proc to the Board class. 

Now let's look at our new Board class
```ruby
class Board < Hyperloop::Component
  param :squares
  param :on_handle_click, type: Proc
  
  def render_square(i) 
    Square(value: params.squares[i], on_handle_click: proc { params.on_handle_click(i) })
  end
  
  render(DIV) do
    DIV(class: 'status') do
      "Next Player: 'X'"
    end
    DIV(class: 'board-row') do
      render_square(0)
      render_square(1)
      render_square(2)
    end
    DIV(class: 'board-row') do
      render_square(3)
      render_square(4)
      render_square(5)
    end
    DIV(class: 'board-row') do
      render_square(6)
      render_square(7)
      render_square(8)
    end
  end
end
```
Not too much has change here, but we have added two new params. Squares is just the array from Game containing the 'X's while we know on_handle_click is the new method we created. The only other change here that we've made is to render_square(i). The the entry at the i-th postion of squares will be passed on to Square and once again we're going to pass handle_click(i) onto Square.

Finally we have our Square class
```ruby
class Square < Hyperloop::Component
  param :value
  param :on_handle_click, type: Proc
  
  render do
    BUTTON(class: 'square'){params.value}.on(:click) {params.on_handle_click}
  end
end
```
Square now has two params as well. One is out handle_click(i) method, the other is the entry passed in from the Board class. Square will display params.value in the Button. But the biggest change is that now when the Button is clicked, instead of mutating a value directly, Square will make a call to our new handle_click(i) method! 

These changes shouldn't change anything that is displayed. You should still only get 'X's to appear in each square when you click on it. But these changes are essential to the proper functioning of the game. Now that we've gotten that out of the way, let's add a some 'O's!

**Note ** I've differed from the React tutorial at this point. In the React tutorial, they move squares to Board then later on they move it up to Game method. I think it's a little silly to move it to Board so I've opted to skip this step and add it to Game

### Player #2

So to add a player #2 to our game. We just need to add a new state variable that will keep track of who is next. We'll first create this state variable under our initialize_game method. That way it's set automatically when the program is loaded. In this example, we'll call this variable x_is_next. This will be our new initialize_game method

```ruby
def initialize_game
    mutate.squares Array.new(9)
    mutate.x_is_next true
  end
```
Then we'll change our handleclick method so that instead of always entering a value of 'X' into the squares array, it'll first check to determine which player is next. To reduce redundancy, I've created a method that checks whether or not x_is_next is true and returns 'X' or 'O' accordingly. We'll put this method under the game class.

```ruby
def who_is_next
    state.x_is_next ? "X" : "O"
  end
  
  def handle_click(i)
    squares = state.squares.dup
    squares[i] = who_is_next
    
    mutate.squares squares
    mutate.x_is_next !state.x_is_next
  end
```

Now the last thing we need to do is change the status that is displayed based on which player is next. This is going to be very simple using the helper method we just created. We'll just change the render method so that it is set to who_is_next. Your render method should now look like this

```ruby
render do
    
     status = "Next Player: #{who_is_next}"
    
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: state.squares, on_handle_click: proc {|i| handle_click(i)})
      end
      DIV(class: 'game-info') do
        DIV do
          status
        end
        OL do
          
        end
      end
    end
  end
end
```

Hopefully everything has been done correctly so far and your board looks like this!
![X's and O's in the Board](https://user-images.githubusercontent.com/27837941/28335959-3728ea7e-6bce-11e7-9e07-2f65165680d2.png)

This is all well and good...but what's the point of a game if there is no winner?

### Declaring a Winner

Checking if there is a winner can be done simply with an array of the possible winning combinations. We know that the board entries are stored in a array of size 9 with either nil, 'X', or 'O' in each position. To check if we have a winner, we'll just check each winning combination in our board array to see if any of these combinations all have the same entry (except nil). We'll create a new method in the bottom of our Game class called calculate_winner and a constant called WINNING_LINES. calculate_winner will take in our array squares and for each combination in WINNING_LINES it will check if all entries are the same. Here's what that will look like

```ruby
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
      return squares[a] if (squares[a]) && (squares[a] == squares[b]) && (squares[a] == squares[c])
    end
    return false
  end
```
Using this method we have created, we'll change both the render method and our handle_click method. For handle_click we're just going to change it so that it will return if there is a winner or is there is already an entry in the position that has been clicked. This will stop players from rewriting old moves or continuing to play when there is already a winner. Our handle_click method will look like this now

```ruby
 def handle_click(i)
    squares = state.squares.dup
    return if squares[i] || calculate_winner(state.squares)
    
    squares[i] = who_is_next
    
    mutate.squares squares
    mutate.x_is_next !state.x_is_next #clarify why this is need/what is it doing
  end
```
Then for the render method we'll just change the status assignment. Instead of always showing which player is next, we'll now display who is the winner is if there is a winner. So we'll check first if we have a winner, if not then the status will just show the next player. Here's what the status assignment will become

```ruby

    if(winner)
      status = "Winner: #{winner}"
    else
      status = "Next Player: #{who_is_next}"
    end
 ```
 Now when you have a winner, the game should show it!
 
 ![Winning Board](https://user-images.githubusercontent.com/27837941/28337025-3eaee2fe-6bd2-11e7-9ac5-d15e18aaf96a.png) 
 
 Great! Now we have an working game of Tic Tac Toe! But let's make this a little bit more intersting.
 
 ### Storing a History
 
 In order to do some more complicated things later on like going back to previous game states, we need to find a way to store previous game states. To do this we're going to change the main state variable that stores the moves and change the way that handle_click works. The first thing we'll do to accomplish this is create a state variable called history that is an array of the move arrays. In the initialize_game method, change `mutate.squares Array.new(9)` to `mutate.history [Array.new(9)]`. That's the only change we'll make in initialize_game for now. 
 
Next let's change handle_click. We still want this method to do the same thing it was before. But now instead of just changing the old move array to the current moves, we want it to add the current moves onto our history array. We'll do this by appending our new array onto history. We'll still use squares, but now it will just be an intermediate variable. Here's the handle_click method after these changes have been made
 
```ruby
def handle_click(i)
    history = state.history
    current = history.last
    squares = current.dup
    return if squares[i] || calculate_winner(squares)
    
    squares[i] = who_is_next
    
    history << squares
    mutate.history history
    mutate.x_is_next !state.x_is_next
  end
```
The current variable may seem a little useless right now, but I promise we'll need it later! 

Now since our move storing array has changed we need to update our render method accordingly. We're going to add a few variables to help us keep track of things. We'll add a history and current variable.  We'll need to change `winner = calculate_winner(squares)` to `winner = calculate_winner(current)`. We also need to change it so that the param being passed into Board is history.last instead of squares. So we'll change `Board(squares: state.squares, on_handle_click: proc {|i| handle_click(i)})` to `Board(squares: current, on_handle_click: proc {|i| handle_click(i)})`. At this point, your render method should look like this

```ruby

render do
    history = state.history
    current = history[state.step_number]
    winner = calculate_winner(current)
    
    if(winner)
      status = "Winner: #{winner}"
    else
      status = "Next Player: #{who_is_next}"
    end
    
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: current, on_handle_click: proc {|i| handle_click(i)})
      end
      DIV(class: 'game-info') do
        DIV do
          status
        end
        OL do
      
        end
      end
    end
  end
end
```

After all this has been done...you shouldn't notice any change in the display! The game should display in the exact same way as the last step. We just changed how the game works behind the curtains.

### Showing the Moves

To show the previous moves we'll create a new method called moves. This method will show the previous moves right next to the game board. Each move will be a link that will jump back to that previous game state by mutating the step number. So from the 1st move to the last move, we'll create a link that will jump to that move when its clicked. We'll do this by adding the move method into the Game class

```ruby
def moves
    (1...state.history.length).each do |move|
      LI(key: move, class: 'game-info-current') do
        A(href: '#'){ "Move ##{move}" }.on(:click) { jump_to(move) }
      end
    end
  end
```

On click, these links will call upon a method called jump_to in order to change the current move. Obviously we need to create a jump_to method now to make this work. Going back to previous moves will be incredibly simple since we have our history array that has stored all of the previous moves. We just need to mutate the step number to the move number that is clicked! But we'll also need to reevaluate which player is next so that the correct player is displayed. We'll put jump_to under the Game class as well

```ruby
def jump_to(step) 
    mutate.step_number step
    mutate.x_is_next((state.step%2)==0 ? true : false)
  end
```
Now we just need to make sure that these moves are being displayed. In your render method, right below where you use status, there should be an Ordered List block (OL). In this block you want to call `moves`, so just type moves into that block. Now if you start the game, the moves should be shown on the side of the game and if you click on them it should change the board back to that move. This is what you should be seeing

![Moves displayed](https://user-images.githubusercontent.com/27837941/28385483-3b70e8ca-6c96-11e7-9dd8-961fb1d54d5d.png)

Pretty neat, right? You know have a completely functioning game of Tic-Tac-Toe with some extra functionailty built in! In case something isn't working and you need to troubleshoot, I'll post what all of your code should look like at this point.

```ruby
class Square < Hyperloop::Component
  param :value
  param :on_handle_click, type: Proc
  
  render do
    BUTTON(class: 'square'){params.value}.on(:click) {params.on_handle_click}
  end
end

class Board < Hyperloop::Component
  param :squares
  param :on_handle_click, type: Proc
  
  def render_square(i) 
    Square(value: params.squares[i], on_handle_click: proc { params.on_handle_click(i) })
  end
  
  render(DIV) do
    DIV(class: 'game-info') do
      "Tic Tac Toe"
    end
    DIV(class: 'board-row') do
      render_square(0)
      render_square(1)
      render_square(2)
    end
    DIV(class: 'board-row') do
      render_square(3)
      render_square(4)
      render_square(5)
    end
    DIV(class: 'board-row') do
      render_square(6)
      render_square(7)
      render_square(8)
    end
  end
end

class Game < Hyperloop::Component
  before_mount :initialize_game
  
  def initialize_game
    mutate.history [Array.new(9)]
    mutate.x_is_next true
    mutate.step_number 0
    
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
    mutate.x_is_next((state.step%2) ==0 ? false : true)
  end
  
  def moves
    (1...state.history.length).each do |move|
      LI(key: move, class: 'game-info-current') do
        A(href: '#'){ "Move ##{move}" }.on(:click) { jump_to(move) }
      end
    end
  end

  render do
    history = state.history
    current = history[state.step_number]
    winner = calculate_winner(current)
    
    if(winner)
      status = "Winner: #{winner}"
    else
      status = "Next Player: #{who_is_next}"
    end
    
    DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: current, on_handle_click: proc {|i| handle_click(i)})
      end
      DIV(class: 'game-info') do
        DIV do
          status
        end
        OL do
          moves
        end
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
      return squares[a] if squares[a] && squares[a] == squares[b] && squares[a] == squares[c]
    end
    return false
  end
end
```

We've now completed all of the features that were implemented in the React tutorial that this was based off of. But we're not going to stop there. If you'd like to how Hyperloop and Ruby can be used to implement some more features, I've done some of the suggested improvements from the React tutorial and a couple of new additions as well.

### Extra Features

#### Bold the Current Move

It would be nice if the current move selected was highlighted in the move list, because when you select an old move the list does not erase the newer moves until the player clicked a square. This will require us to first edit our css file. You're going to want to open the index.css file we created earlier. It's located under app/assests/stylesheets. At the bottom of the css file, add these four specifications

```css
.game-info-current{
  color: blue;
  font-weight: 900;
}

.game-info-current a:visited{
  color:blue;
}

a:visited { 
  color: black;
}
a:hover { 
  color: blue;
}
```

I'll explain what each of these will do. The first one will be used to distinguish the current move from the other moves. It will make the current move be blue instead of the normal color if we specifcy that the current move will use this class instead of the normal class used. The second specification will just make the words of the current move show as blue as well as the number. The last two are just to make the list look a little nicer. a:visited will make the moves that aren't current be black instead of purple. a:hover will change the move under the mouse to blue.  

We need to now find a way to change the class used in the link rendering of only the current move. The easiest way to accomplish this is to change the moves method. We're going to add a variable under this method called class_name. Then in the link created instead of always using 'game-info', we'll use class_name. When we're assigning class_name, we'll take advantage of Ruby. Here's what moves will look like

```ruby
def moves
    (1...state.history.length).each do |move|
      class_name = (move == state.step_number && 'game-info-current')
      LI(key: move, class: class_name) do
        A(href: '#'){ "Move ##{move}" }.on(:click) { jump_to(move) }
      end
    end
  end
```

This may look a little strange, but it does work and is simplier than using other methods like and if statement. It looks like we're assigning a variable to a boolean expresion. But because Ruby will return the last item evaluated if nothing is specified, this will end up returning 'game-info-current' if the expression is evaluated true. move == state.step_number will return true if we are on the current move and 'game-info-current' will always return true. So if the first part is true, it will just assign class_name to 'game-info-current'. This is what we want! If the expression returns false, the class_name will equal false. This will just cause the default css class to be used. 

After making these changes,  your moves should now change color like this!

![Colored Moves](https://user-images.githubusercontent.com/27837941/28386865-f58313b0-6c9a-11e7-8e44-23d486af0362.png)

#### Rewriting Board to use Two Loops

This improvement is pretty straightforward. We're just going to change our Board class so that instead of iterating through each square individually, we'll use a couple of loops to build it. This will cut down 14 lines of code to 5 lines of code. Currently the render method in our Board class looks like this

```ruby
render(DIV) do
    DIV(class: 'game-info') do
      "Tic Tac Toe"
    end
    DIV(class: 'board-row') do
      render_square(0)
      render_square(1)
      render_square(2)
    end
    DIV(class: 'board-row') do
      render_square(3)
      render_square(4)
      render_square(5)
    end
    DIV(class: 'board-row') do
      render_square(6)
      render_square(7)
      render_square(8)
    end
  end
```

If we think about the shape we want for this Board, it's composed of 3 rows of 3 squares. So we can use 2 iterations to do this same rendering. The first iteration will do the inner one 3 times while the inner one will render_square 3 times. In ruby, that will look like this 

```ruby
render(DIV) do
    DIV(class: 'game-info') do
     "Tic Tac Toe"
    end
    (0..2).each do |x|
      DIV(class: "board-row") do
        (x*3..(x*3)+2).each { |y| render_square(y) }
      end
    end
  end
```

#### Displaying Moves in Ascending/Descending Order

This can be done by utilizing a ruby method .send. This will allow us to assign a variable to the method name we want to use then using send we can call it on the object it's acting upon. We want to do this so that we can avoid making two methods or using an if statement. But first we'll create a state variable to keep track of whether or not we want to display the moves in ascending order or decsending order. In your initialize_game method add `mutate.order true`. If order is true, we'll display the moves in ascending order. If order is false, we'll display the order in descending order. By evaluating order in our moves method, we can change how it iterates through the move list. Like this

```ruby
def moves(ascending)
    method_name = ascending ? :each : :reverse_each
    (1...state.history.length).send(method_name) do |move|
      class_name = (move == state.step_number && 'game-info-current')
      LI(key: move, class: class_name) do
        puts "#{class_name}"
        A(href: '#'){ "Move ##{move}" }.on(:click) { jump_to(move) }
      end
    end
  end
```
Then, in the render method of Game, just change the ordered list to an unordered list and change `moves` to `moves(state.order)`. If you want to get rid of the bullet points as well add `list-style: none;` to index.css under the ol, ul section. 

We're now going to want to add a link that will display that we can click to change the display order. We'll put this under a new DIV block in the Game render method. When the link is clicked, it will mutate order to !state.order. This is what part of your render method should be now

```ruby
DIV(class: 'game')do
      DIV(class: 'game-board') do
        Board(squares: current, on_handle_click: proc {|i| handle_click(i)})
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
        A(href: '#'){state.order ? "Descending" : "Ascending"}.on(:click) {mutate.order !state.order}
      end unless state.history.length == 1
    end
  end
```

Here's what the board should look like in descending order.

![Decsending Order](https://user-images.githubusercontent.com/27837941/28421476-4a4f2490-6d33-11e7-9359-96ea6890ec18.png)

#### New Game Button

Right now, the only way to restart the game completely is to refresh the page. That's not great. So let's add a simple New Game button that will clear the entire game. This will be an easy change. All we need to do is all a link that will call initialize_game when it is clicked! Let's just add that right about the Ascending/Descending button that we just added.

```ruby
DIV(class: 'game-info') do
  DIV do
    A(href: '#'){"New Game"}.on(:click) {initialize_game}
  end unless state.history.length == 1
  DIV do
    A(href: '#'){state.order ? "Descending" : "Ascending"}.on(:click) {mutate.order !state.order}
  end unless state.history.length == 1
end
 ```

Now we have a nice New Game button!

![New Game Button](https://user-images.githubusercontent.com/27837941/28422073-f8ff1d50-6d34-11e7-97b1-907ce1b6b990.png)

#### Cat's Game

When the player's fill up the board without a winner, the status will still say who is next. We're going to fix this so that when it's a draw, the status will reflect that. A cat's game means all of the squares have been filled, but there is no winner. To check this, we'll create a method that checks every entry in the current board and returns false if it encounters a nil entry. Because if we find a nil it can't possibly be a cat's game. I'll call this method check_cats and add it below our calculate_winner method.

```ruby
def check_cats(squares)
    squares.each {|x| return false if x == nil}
  end
```

Now that we have the method, we can use it! Add a new variable to your Game render method. `cats = check_cats(current)`. Then add this elsif under `if(winner)`

```ruby
elsif(cats)
  status = "Cat's Game!"
```
With those two simple changes, you should now see this when you get a cat's game!

![Cat's Game](https://user-images.githubusercontent.com/27837941/28423387-e2bdd082-6d38-11e7-9b05-f25b6094a9e0.png)

#### Highlight Winning Squares

The last optional feature I'm going to add is a highlighting effect. When someone wins a game of Tic-Tac-Toe, the winning squares will be highlighted. This is just a nice visual feature. But it will be a trickier to implement then some of the previous features. If you think about the way this program is rendering the Board it makes it simplier to visualize. The Board class renders each row by calling upon the Square class to render each individual square. If we can get the Board class to send a variable to Square indicating whether it is a winning square or not, we should be able to do this. First thing we need to do is get an array of the winning positions. Let's edit the calculate_winner method to go this

```ruby
def calculate_winner(squares)
    WINNING_LINES.each do |a,b,c|
      return [squares[a], [a,b,c]] if squares[a] && squares[a] == squares[b] && squares[a] == squares[c]
    end
    return nil
  end
```

Now when we call call calculate_winner, it will return two values instead of just one. Because of this we need to make sure to change what the status for a winner is. Change `status = "Winner: #{winner}"` to `status = "Winner: #{winner[0]}"`. Now the status will just focus on the first value returned from the method, which is just 'X' or 'O'. Everything should be working like normal still.

Next we actually want to take the second value returned (the winning positions) and pass it into the Board class. First we'll want to create a new state variable to store this though. In initialize_game, create a new state variable by adding this line `mutate.array [9,9,9]`. I've created a state variable for this because everytime we call Board in the Game class it is going to be passed in a value for the winning array locations. If there is no value or you pass in nil, it will fail. It is initialized to [9,9,9] because there are no squares with these positions so it won't highlight any of the squares by default. 

Let's now update the array variable when there is a winner. In Game's render method, add this list to your list of variables under the assignment of winner: `mutate.array winner[1] unless winner == nil`. So unless there isn't a winner, array will be updated to the array of winning positions. Now let's update our call for Board to pass in this array! Change your Board call so it looks like this now `Board(squares: current, array: state.array, on_handle_click: proc {|i| handle_click(i)})`. The winning positions can now be accessed by the Board class. Let's move down to this level

In Board, we'll first want to add a new param to match the one we've passed in. Add `params :array` to the top of the class. Next we need pass something to the Square class to indicate whether or not the square being rendered is a winning square or not. A simple boolean will suffice. We'll evaluate this boolean in the second loop constructing our Board. If the array contains the value y, our boolean will be true, if not it will be false. That will look like this

```ruby
(0..2).each do |x|
  DIV(class: 'board-row') do
    (x*3..(x*3)+2).each {|y|
      (params.array.include? y) ? match = true : match = false
      render_square(y, match)
    }
  end
end
```
As you can see we're going to pass a new variable into render_square so let's change that method to accomodate this. Here's the new render_square method that we'll have. All we've added is a new param to be passed in.

```ruby
def render_square(i,match) 
    Square(value: params.squares[i], winner: match, on_handle_click: proc { params.on_handle_click(i) })
  end
```
Alright, one more level down! Let's move into the Square class. Once again, we need to add a new param declaration to the class. Add `param :winner` to the top of the class. We're then going to add a new line to evaluate the boolean. In the render block, above the Button, add `class_name = params.winner ? 'bold-square' : 'square'`. This will change which css class we'll use depending on the value of the boolean. We'll add 'bold-square' to our css file after this. The last thing we need to do in the Sqaure class is change the Botton's css class. Change `class: 'square'` to `class: class_name`. Everything that has to be changed in our index.rb file has been changed! Let's move onto our css file. After editing that file, it should work!

Go into your index.css file in app/assests/stylesheets. We need to add just two classes. Copy and paste these two classes into your file

```css
.bold-square {
  background: #fff;
  border: 2px solid #0000ff;
  float: left;
  font-size: 24px;
  font-weight: bold;
  line-height: 34px;
  height: 34px;
  margin-right: -1px;
  margin-top: -1px;
  padding: 0;
  text-align: center;
  width: 34px;
}

.bold-square:focus {
  outline: none;
}
```
The winning squares should be highlighted now! If you save and play a winning game, the winning squares should be highlighted blue now. It should look like this!

![Highlighted Squares](https://user-images.githubusercontent.com/27837941/28468559-5583b122-6e01-11e7-8617-57448e579d5e.png)

## Final Files

I'll put up the entire index.rb file and index.css file after these optional changes have been made under here. If you're running in to problems, check and see if there is any differences between these files and yours.

index.rb
```ruby
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
    mutate.x_is_next((state.step%2) ==0 ? false : true)
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
    mutate.array winner[1] unless winner == nil
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
```
index.css
```css
body {
  font: 14px "Century Gothic", Futura, sans-serif;
  margin: 20px;
}

ol, ul {
  padding-left: 15px;
  list-style: none;
}



.board-row:after {
  clear: both;
  content: "";
  display: table;
}

.status {
  margin-bottom: 10px;
}

.square {
  background: #fff;
  border: 1px solid #999;
  float: left;
  font-size: 24px;
  font-weight: bold;
  line-height: 34px;
  height: 34px;
  margin-right: -1px;
  margin-top: -1px;
  padding: 0;
  text-align: center;
  width: 34px;
}

.bold-square {
  background: #fff;
  border: 2px solid #0000ff;
  float: left;
  font-size: 24px;
  font-weight: bold;
  line-height: 34px;
  height: 34px;
  margin-right: -1px;
  margin-top: -1px;
  padding: 0;
  text-align: center;
  width: 34px;
}

.square:focus {
  outline: none;
}

.bold-square:focus {
  outline: none;
}

.kbd-navigation .square:focus {
  background: #ddd;
}

.game {
  display: flex;
  flex-direction: row;
}

.game-info {
  margin-left: 20px;
}

.game-info-current{
  color: blue;
  font-weight: 900;
}

.game-info-current a:visited{
  color:blue;
}

a:visited { 
  color: black;
}
a:hover { 
  color: blue;
}
```
