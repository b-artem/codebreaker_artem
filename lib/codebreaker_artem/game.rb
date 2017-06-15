module CodebreakerArtem
  class Game
    MAX_GUESS_NUMBER = 10

    attr_reader :secret_code, :guess_count

    def initialize
      initial_values_set
    end

    def start
      initial_values_set
      generate_secret_code
    end

    def mark_guess(guess)
      return false unless guess
      # Need some validation?
      @guess_count += 1
      counts = plus_minus_count(guess)
      # Do I really need to set score each round?
      score_set(counts[0], counts[1])
      '' << ('+' * counts[0]) << ('-' * counts[1])
    end

    def hint
      return unless hint_available? # Check if hint is available
      @hint_available = false
      position = @numbers_guess_count.index(@numbers_guess_count.min)
      secret_number = @secret_code[position]
      [secret_number, position]
    end

    private

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
      @hint_available
    end
  end
end
