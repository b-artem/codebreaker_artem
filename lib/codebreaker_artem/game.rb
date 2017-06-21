require_relative 'validator'

module CodebreakerArtem
  class Game
    MAX_GUESS_NUMBER = 10

    attr_reader :secret_code, :guess_count, :score

    def initialize
      @guess_count = 0
      @score = 0
      @hint_available = true
    end

    def start
      generate_secret_code
    end

    def mark_guess(guess)
      return false unless Validator.code_valid? guess
      @guess_count += 1
      counts = plus_minus_count(guess)
      score_set(counts[:pluses], counts[:minuses])
      '' << ('+' * counts[:pluses]) << ('-' * counts[:minuses])
    end

    def hint
      return unless hint_available?
      @hint_available = false
      position = rand(0..3)
      [@secret_code[position], position]
    end

    private

    def generate_secret_code
      @secret_code = Array.new(4) { rand(1..6) }.join
    end

    def plus_minus_count(guess)
      return { pluses: 4, minuses: 0 } if @secret_code == guess
      zipped = @secret_code.split('').zip(guess.split(''))
      not_plus = zipped.delete_if { |item| item.uniq.one? }
      plus_count = 4 - not_plus.count
      { pluses: plus_count, minuses: minus_count(not_plus) }
    end

    def minus_count(not_plus)
      code = not_plus.transpose[0]
      guess = not_plus.transpose[1]
      guess.each { |item| code.delete_at(code.index(item) || code.length) }
      not_plus.count - code.size
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
