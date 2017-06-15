require_relative 'game'
require_relative 'cli'

module CodebreakerArtem
  class Starter
    def self.play
      game = CodebreakerArtem::Game.new
      game.start
      # Can I use game::MAX_Guess_MNUMBER?
      CLI.welcome_msg(CodebreakerArtem::Game::MAX_GUESS_NUMBER)

      loop do
        CLI.guess_prompt(game.guess_count)
        case input = CLI.submit_guess
        when nil then next
        when :hint
          CLI.show_hint(*game.hint)
          next
        else
          mark = game.mark_guess(input)
          return CLI.win(input) if mark == '++++'
          CLI.show_mark(mark)
        end
        return CLI.lose(game.secret_code, CodebreakerArtem::Game::MAX_GUESS_NUMBER) if game.guess_count >= CodebreakerArtem::Game::MAX_GUESS_NUMBER
      end
    end
  end
end

CodebreakerArtem::Starter.play
