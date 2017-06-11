require_relative 'game'

module GameUtils
  include CodebreakerArtem

  def welcome_msg
    print "Welcome to the Codebreaker Game!\n" \
      "New secret code has just been generated\n" \
      "You have #{Game::MAX_GUESS_NUMBER} attempts\n" \
      "Type 'hint' to take a hint\n" \
      "Type 'exit' to exit the game\n\n"
  end

  def guess_prompt
    print "Please enter your guess no. #{@guess_count}: "
  end

  def submit_guess
    guess = $stdin.gets.chomp
    exit?(guess)
    return false if take_hint(guess)
    return wrong_code_length unless guess.length == 4
    return wrong_code_numbers unless guess =~ /[1-6]{4}/
    @guess_count += 1
    guess
  end

  def save_score
    return false unless yes? { 'Do you want to save your score? (y/n): ' }
    begin
      Dir.mkdir('./score') unless File.exist?('./score')
      file = File.new('./score/score.txt', 'a')
    rescue
      puts "Can't create file './score/score.txt'"
      return
    end
    write_score_to_file file
    file.close
  end

  def write_score_to_file(file)
    print 'Please enter your name: '
    name = $stdin.gets.chomp
    file << "Name: #{name}\n"
    file << "Time: #{Time.now}\n"
    file << "Score: #{@score}\n\n"
    puts "Your data was added to a file #{file.path}"
  end

  def take_hint(input = nil)
    return false unless input =~ /hint/i
    return false unless hint_available?
    position = @numbers_guess_count.index(@numbers_guess_count.min)
    secret_number = @secret_code[position]
    puts "HINT: Number #{secret_number} is in position #{position + 1}"
    @hint_available = false
    secret_number
  end

  def one_hint_only
    puts 'You have only one hint'
  end

  def play_again
    exit unless yes? { 'Would you like to play one more time? (y/n): ' }
    start
  end

  def exit?(input)
    exit if input =~ /exit/
    false
  end

  def yes?
    print yield if block_given?
    loop do
      answer = $stdin.gets.chomp
      exit?(answer)
      return false if answer =~ /^n/i
      return true if answer =~ /^y/i
      puts "Please enter 'y' or 'n': "
    end
  end

  def wrong_code_length
    puts 'Code contains 4 numbers, please try again'
    false
  end

  def wrong_code_numbers
    puts 'All numbers are between 1 and 6, please try again'
    false
  end

  def win_msg
    puts "\nCONGRATULATIONS! You've won the Codebreaker game!"
  end

  def lose_msg
    puts "You've used all your attempts (#{Game::MAX_GUESS_NUMBER})" \
          " and LOST THE GAME\n"
  end

  def reveal_code
    puts "The secret code was #{@secret_code}\n"
  end
end
