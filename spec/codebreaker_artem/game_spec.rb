require 'spec_helper'

RSpec.describe CodebreakerArtem::Game do
  let(:game) { CodebreakerArtem::Game.new }

  describe '#play' do
    it 'calls #start' do
      # expect(game).to receive(:start)
      # allow(game).to receive(:start).and_return(return)
      # game.play
    end
    it 'calls #guess_input'
    it 'calls #submit_guess'
    it 'calls #mark_guess'
  end

  describe '#start' do
    context 'when sets initial values' do
      it 'sets @guess_count = 0' do
        expect(game.instance_variable_get(:@guess_count)).to eq 0
      end
      it 'sets @score = 0' do
        expect(game.instance_variable_get(:@score)).to eq 0
      end
      it 'sets @numbers_guess_count = [0, 0, 0, 0]' do
        ary = [0, 0, 0, 0]
        expect(game.instance_variable_get(:@numbers_guess_count)).to eq ary
      end
      it 'sets @hint_available = true' do
        expect(game.instance_variable_get(:@hint_available)).to eq true
      end
    end

    context 'when generates secret code' do
      before do
        game.send(:start)
      end
      it 'saves secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq 4
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]{4}/)
      end
    end

    it 'calls #welcome_msg' do
      expect(game).to receive(:welcome_msg)
      game.send(:start)
    end
  end

  describe '#submit_guess' do
    it 'accepts proper guess' do
      allow($stdin).to receive(:gets).and_return("1234\n")
      expect(game.send(:submit_guess)).to eq '1234'
    end
    it "doesn't accept too long guess" do
      allow($stdin).to receive(:gets).and_return("12345\n")
      expect(game.send(:submit_guess)).to be false
    end
    it "doesn't accept too short guess" do
      allow($stdin).to receive(:gets).and_return("123\n")
      expect(game.send(:submit_guess)).to be false
    end
    it "doesn't accept not matching guess" do
      allow($stdin).to receive(:gets).and_return("1237\n")
      expect(game.send(:submit_guess)).to be false
    end
  end

  describe '#mark_guess' do
    before do
      game.instance_variable_set(:@secret_code, '1223')
    end

    context 'when secret_code is 1223' do
      it "marks 4556 as ''" do
        expect(game.send(:mark_guess, '4556')).to eq ''
      end
      it 'marks 1556 as +' do
        expect(game.send(:mark_guess, '1556')).to eq '+'
      end
      it 'marks 1553 as ++' do
        expect(game.send(:mark_guess, '1553')).to eq '++'
      end
      it 'marks 1356 as +-' do
        expect(game.send(:mark_guess, '1356')).to eq '+-'
      end
      it 'marks 1156 as +-' do
        expect(game.send(:mark_guess, '1156')).to eq '+-'
      end
      it 'marks 1335 as +--' do
        expect(game.send(:mark_guess, '1335')).to eq '+--'
      end
      it 'marks 3112 as ----' do
        expect(game.send(:mark_guess, '3112')).to eq '----'
      end
      it '1223 leads to #win' do
        allow(game).to receive(:win).and_return('win')
        expect(game.send(:mark_guess, '1223')).to eq 'win'
      end
    end
  end

  describe '#win' do
    it 'prints congrats message' do
      allow(game).to receive(:finish_game).and_return(nil)
      expect { game.send(:win) }.to output(/Congratulations!/i).to_stdout
    end
    it 'prints secret code' do
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.instance_variable_set(:@secret_code, 5555)
      expect { game.send(:win) }.to output(/5555/).to_stdout
    end
    it 'proposes to play again' do
      allow(game).to receive(:save_score).and_return(nil)
      allow($stdin).to receive(:gets).and_return('y')
      expect { game.send(:win) }.to output(/play.+more.+time?/i).to_stdout
    end
  end

  describe '#lose' do
    it 'prints lost msg' do
      allow(game).to receive(:finish_game).and_return(nil)
      expect { game.send(:lose) }.to output(/lost.+game/i).to_stdout
    end
    it 'reveals secret code' do
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.instance_variable_set(:@secret_code, 5555)
      expect { game.send(:lose) }.to output(/5555/i).to_stdout
    end
    it 'proposes to play again' do
      allow(game).to receive(:save_score).and_return(nil)
      allow($stdin).to receive(:gets).and_return('y')
      expect { game.send(:lose) }.to output(/play.+more.+time?/i).to_stdout
    end
  end

  describe '#yes?' do
    context 'when correct input' do
      it "returns false if 'n'" do
        allow($stdin).to receive(:gets).and_return('n')
        expect(game.send(:yes?)).to be false
      end
      it "returns true if 'y" do
        allow($stdin).to receive(:gets).and_return('y')
        expect(game.send(:yes?)).to be true
      end
    end

    context 'when incorrect input' do
      it "prints prompt to enter 'y' or 'n'" do
        allow($stdin).to receive(:gets).and_return('r', 'n')
        expect { game.send(:yes?) }.to output(/enter.+y.+or.+n/i).to_stdout
      end
    end
  end

  describe '#save_score' do
    it 'proposes to save score' do
      allow($stdin).to receive(:gets).and_return('y')
      expect { game.send(:save_score) }.to output(/Do.+want.+save.+score/i).to_stdout
    end
    it 'saves score to file' do
      allow($stdin).to receive(:gets).and_return('y')
      game.instance_variable_set(:@score, 777)
      game.send(:save_score)
      file = File.open('./score/score.txt')
      expect(file.readlines[-2]).to eq "Score: 777\n"
    end
    it 'saves name to file' do
      allow(game).to receive(:yes?).and_return(true)
      allow($stdin).to receive(:gets).and_return('Elon Musk')
      game.send(:save_score)
      file = File.open('./score/score.txt')
      expect(file.readlines[-4]).to eq "Name: Elon Musk\n"
    end
  end

  describe '#take_hint' do
    it 'reveals one of the numbers in secret code' do
      secret_code = game.instance_variable_set(:@secret_code, '1223')
      number = game.send(:take_hint, 'hint')
      expect(secret_code.include?(number.to_s)).to be true
    end
    it 'reveals number with minimum guesses' do
      game.instance_variable_set(:@secret_code, '1234')
      game.instance_variable_set(:@numbers_guess_count, [1, 0, 3, 2])
      number = game.send(:take_hint, 'hint')
      expect(number).to eq '2'
    end
  end
end
