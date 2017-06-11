require_relative 'game_utils'

module CodebreakerArtem
  class Game
    include GameUtils
    MAX_GUESS_NUMBER = 10

    attr_reader :secret_code

    def initialize
      initial_values_set
    end

    def play
      start
      loop do
        guess_prompt
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

    def hint_available?
      return one_hint_only unless @hint_available
      true
    end

    def win
      win_msg
      finish_game
    end

    def lose
      lose_msg
      finish_game
    end

    def finish_game
      reveal_code
      save_score
      play_again
    end
  end
end
