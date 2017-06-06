module CodebreakerArtem
  class Game
    MAX_GUESS_NUMBER = 10

    def initialize
      initial_values_set
    end

    def play
      start
      loop do
        print "Please enter your guess no. #{@guess_count}: "
        mark_guess(submit_guess)
        return lose if @guess_count >= MAX_GUESS_NUMBER
      end
    end

    private

    def start
      initial_values_set
      generate_secret_code
      welcome_msg
    end

    def initial_values_set
      @guess_count = 0
      @score = 0
      @numbers_guess_count = [0, 0, 0, 0]
      @hint_available = true
    end

    def generate_secret_code
      @secret_code = ''
      4.times { @secret_code << rand(1..6).to_s }
    end

    def welcome_msg
      print "Welcome to the Codebreaker Game!\n" \
        "New secret code has just been generated\n" \
        "You have #{MAX_GUESS_NUMBER} attempts\n" \
        "Type 'hint' to take a hint\n" \
        "Type 'exit' to exit the game\n\n"
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

    def mark_guess(guess)
      return false unless guess
      counts = plus_minus_count(guess)
      score_set(counts[0], counts[1])
      puts mark = '' << ('+' * counts[0]) << ('-' * counts[1])
      return win if mark == '++++'
      mark
    end

    def plus_minus_count(guess)
      plus_count = 0
      minus_count = 0
      guess.each_char.with_index do |number, index|
        if number == @secret_code[index]
          plus_count += 1
          @numbers_guess_count[index] += 1
        elsif @secret_code.include? number
          minus_count += 1
        end
      end
      [plus_count, minus_count]
    end

    def score_set(plus_count, minus_count)
      @score = (plus_count * 3) + (minus_count * 1) +
               (MAX_GUESS_NUMBER - @guess_count + 1)
    end

    def win
      puts "\nCONGRATULATIONS! You've won the Codebreaker game!"
      finish_game
    end

    def lose
      puts "You've used all your attempts (#{MAX_GUESS_NUMBER})" \
            " and LOST THE GAME\n"
      finish_game
    end

    def finish_game
      puts "The secret code was #{@secret_code}\n"
      save_score
      play_again
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

    def hint_available?
      return puts 'You have only one hint' unless @hint_available
      true
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
  end
end
