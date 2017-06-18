require_relative 'validator'

module CodebreakerArtem
  class Game
    MAX_GUESS_NUMBER = 10

    attr_reader :secret_code, :guess_count, :score

    def initialize
      initial_values_set
    end

    def start
      initial_values_set
      generate_secret_code
    end

    def mark_guess(guess)
      return false unless Validator.code_valid? guess
      @guess_count += 1
      counts = plus_minus_count(guess)
      score_set(counts[0], counts[1])
      '' << ('+' * counts[0]) << ('-' * counts[1])
    end

    def hint
      return unless hint_available?
      @hint_available = false
      position = rand(0..3)
      secret_number = @secret_code[position]
      [secret_number, position]
    end

    private

    def initial_values_set
      @guess_count = 0
      @score = 0
      @hint_available = true
    end

    def generate_secret_code
      @secret_code = ''
      4.times { @secret_code << rand(1..6).to_s }
    end

    def plus_minus_count(guess)
      zipped = @secret_code.split('').zip(guess.split(''))
      not_plus = zipped.delete_if { |item| item.uniq.count == 1 }
      return [4, 0] if not_plus.empty?
      plus_count = 4 - not_plus.count
      code = not_plus.transpose[0]
      guesses = not_plus.transpose[1]
      guesses.each { |item| code.delete_at(code.index(item) || code.length) }
      minus_count = 4 - plus_count - code.size
      [plus_count, minus_count]
    end

    def score_set(plus_count, minus_count)
      @score = (plus_count * 3) + (minus_count * 1) +
               (MAX_GUESS_NUMBER - @guess_count)
    end

    def hint_available?
      @hint_available
    end
  end
end
