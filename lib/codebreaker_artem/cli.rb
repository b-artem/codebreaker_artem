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
        print "Please enter your guess no. #{guess_count + 1}: "
      end

      def submit_guess
        guess = $stdin.gets.chomp
        exit?(guess)
        return :hint if guess =~ /^hint$/i
        return wrong_code_pattern unless guess =~ /^[1-6]{4}$/
        guess
      end

      def show_hint(number = nil, position = nil)
        return one_hint_only unless number && position
        puts "HINT: Number #{number} is in position #{position + 1}"
      end

      def show_mark(mark)
        puts mark
      end

      def win(code, score)
        win_msg
        finish_game(code, score)
      end

      def lose(code, score, max_guess_number)
        lose_msg(max_guess_number)
        finish_game(code, score)
      end

      def win_msg
        puts "\nCONGRATULATIONS! You've won the Codebreaker game!\n"
      end

      def lose_msg(max_guess_number)
        puts "You've used all your attempts (#{max_guess_number})" \
              " and LOST THE GAME\n"
      end

      def finish_game(code, score)
        reveal_code(code)
        save_score(score)
      end

      def reveal_code(code)
        puts "The secret code was #{code}\n"
      end

      def one_hint_only
        puts 'You have only one hint'
      end

      def wrong_code_pattern
        puts 'Code must contain 4 numbers from 1 to 6, please try again'
      end

      def exit?(input)
        exit if input =~ /^exit$/i
      end

      def save_score(score)
        return false unless yes? { 'Do you want to save your score? [y/n]: ' }
        begin
          Dir.mkdir('./score') unless File.exist?('./score')
          file = File.new('./score/score.txt', 'a')
        rescue
          puts "Can't create file './score/score.txt'"
          return
        end
        write_score_to_file(file, score)
        file.close
      end

      def write_score_to_file(file, score)
        print 'Please enter your name: '
        name = $stdin.gets.chomp
        file << "Name: #{name}\n"
        file << "Time: #{Time.now}\n"
        file << "Score: #{score}\n\n"
        puts "Your data was added to a file #{file.path}"
      end

      def play_again
        exit unless yes? { 'Would you like to play one more time? [y/n]: ' }
        true
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
    end
  end
end
