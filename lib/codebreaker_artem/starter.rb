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
          mark_guess(input)
        end
        return lose if @guess_count >= MAX_GUESS_NUMBER
      end

    end
  end
end

CodebreakerArtem::Starter.play
