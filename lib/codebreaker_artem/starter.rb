require_relative 'game'
require_relative 'cli'

module CodebreakerArtem
  class Starter
    MAX = CodebreakerArtem::Game::MAX_GUESS_NUMBER

    def self.start
      game = CodebreakerArtem::Game.new
      game.start
      CLI.welcome_msg(MAX)
      play(game)
      start if CLI.play_again
    end

    def self.play(game)
      loop do
        CLI.guess_prompt(game.guess_count)
        case input = CLI.submit_guess
        when nil then next
        when :hint then CLI.show_hint(*game.hint)
        else
          mark = game.mark_guess(input)
          return CLI.win(input, game.score) if mark == '++++'
          CLI.show_mark(mark)
        end
        return CLI.lose(game.secret_code, game.score, MAX) if game.guess_count >= MAX
      end
    end
  end
end

CodebreakerArtem::Starter.start
