require 'spec_helper'

RSpec.describe CodebreakerArtem::CLI do
  let(:game) { CodebreakerArtem::Game.new }
  let(:game_utils) { Class.new { include GameUtils }.new }

  describe '#welcome_msg' do
    it 'prints welcome message' do
      expect { game_utils.welcome_msg(10) }.to output(/Welcome.+10/m).to_stdout
    end
  end

  describe '#submit_guess' do
    it 'accepts proper guess' do
      allow($stdin).to receive(:gets).and_return("1234\n")
      expect(game.submit_guess).to eq '1234'
    end
    it "doesn't accept too long guess" do
      allow($stdin).to receive(:gets).and_return("12345\n")
      expect(game_utils.submit_guess).to be false
    end
    it "doesn't accept too short guess" do
      allow($stdin).to receive(:gets).and_return("123\n")
      expect(game_utils.submit_guess).to be false
    end
    it "doesn't accept not matching guess" do
      allow($stdin).to receive(:gets).and_return("1237\n")
      expect(game_utils.submit_guess).to be false
    end
  end

  describe '#win_msg' do
    it 'prints congrats message' do
      expect { game_utils.win_msg }.to output(/Congratulations!/i).to_stdout
    end
  end

  describe '#lose_msg' do
    it 'prints lose message' do
      expect { game_utils.lose_msg }.to output(/lost.+game/i).to_stdout
    end
  end

  describe '#reveal_code' do
    it 'reveals secret code' do
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.instance_variable_set(:@secret_code, 5555)
      expect { game.send(:finish_game) }.to output(/5555/i).to_stdout
    end
  end

  describe '#play_again' do
    it 'proposes to play again' do
      allow(game).to receive(:start).and_return(nil)
      allow($stdin).to receive(:gets).and_return('y')
      expect { game.send(:finish_game) }.to output(/play.+more.+time?/i).to_stdout
    end

    context 'when answer is known' do
      before do
        allow(game).to receive(:start).and_return(nil)
      end
      after do
        game.send(:play_again)
      end
      it 'calls #start if positive answer' do
        allow($stdin).to receive(:gets).and_return('y')
        expect(game).to receive(:start)
      end
    end
  end

  describe '#yes?' do
    context 'when correct input' do
      it "returns false if 'n'" do
        allow($stdin).to receive(:gets).and_return('n')
        expect(game_utils.yes?).to be false
      end
      it "returns true if 'y" do
        allow($stdin).to receive(:gets).and_return('y')
        expect(game_utils.yes?).to be true
      end
    end

    context 'when incorrect input' do
      it "prints prompt to enter 'y' or 'n'" do
        allow($stdin).to receive(:gets).and_return('r', 'n')
        expect { game_utils.yes? }.to output(/enter.+y.+or.+n/i).to_stdout
      end
    end
  end

  describe '#save_score' do
    it 'proposes to save score' do
      allow($stdin).to receive(:gets).and_return('y')
      expect { game_utils.save_score }.to output(/Do.+want.+save.+score/i).to_stdout
    end

    context 'when saving to file' do
      let(:file) { File.open('./score/score.txt') }
      it 'saves score to file' do
        allow($stdin).to receive(:gets).and_return('y')
        game.instance_variable_set(:@score, 777)
        game.send(:save_score)
        expect(file.readlines[-2]).to eq "Score: 777\n"
      end
      it 'saves name to file' do
        allow(game).to receive(:yes?).and_return(true)
        allow($stdin).to receive(:gets).and_return('Elon Musk')
        game.send(:save_score)
        expect(file.readlines[-4]).to eq "Name: Elon Musk\n"
      end
    end
  end

  describe '#show_hint' do
    before do
      game.instance_variable_set(:@secret_code, '1234')
    end
    let(:number) { game.send(:take_hint, 'hint') }

    it 'reveals one of the numbers in secret code' do
      secret_code = '1234'
      expect(secret_code.include?(number.to_s)).to be true
    end
    it 'reveals number with minimum guesses' do
      game.instance_variable_set(:@numbers_guess_count, [1, 0, 3, 2])
      expect(number).to eq '2'
    end
  end
end
