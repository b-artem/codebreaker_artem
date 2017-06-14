module CodebreakerArtem
  class CLI
    class << self

      def welcome_msg(max_guess_number)
        puts %(
          Welcome to the Codebreaker Game!
          New secret code has just been generated
          You have #{max_guess_number} attempts
          Type 'hint' to take a hint
          Type 'exit' to exit the game
        )
      end

      def guess_prompt(guess_count)
        print "Please enter your guess no. #{guess_count}: "
      end

      def submit_guess
        guess = $stdin.gets.chomp
        exit?(guess)
        return :hint if hint?(guess)
        return wrong_code_pattern unless guess =~ /^[1-6]{4}$/
        guess
      end

      def hint?(input = nil)
        return false unless input =~ /^hint$/i
        return false unless hint_available?
        puts "HINT: Number #{secret_number} is in position #{position + 1}"
      end

      def show_hint(number = nil, position = nil)
        return one_hint_only unless number && position
        puts "HINT: Number #{secret_number} is in position #{position + 1}"
      end

      def wrong_code_pattern
        puts 'Code must contain 4 numbers from 1 to 6, please try again'
      end

      def exit?(input)
        exit if input =~ /^exit$/i
      end





    end
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



  def one_hint_only
    puts 'You have only one hint'
  end

  def play_again
    exit unless yes? { 'Would you like to play one more time? (y/n): ' }
    start
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
