require 'spec_helper'

RSpec.describe CodebreakerArtem::Game do
  let(:game) { CodebreakerArtem::Game.new }

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

    it 'calls GameUtils.welcome_msg' do
      expect(game).to receive(:welcome_msg)
      game.send(:start)
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
    it 'calls GameUtils.win_msg' do
      expect(game).to receive(:win_msg)
      allow(game).to receive(:finish_game).and_return(nil)
      game.send(:win)
    end
    it 'calls #finish_game' do
      expect(game).to receive(:finish_game)
      allow(game).to receive(:finish_game).and_return(nil)
      game.send(:win)
    end
  end

  describe '#lose' do
    it 'calls GameUtils.lose_msg' do
      expect(game).to receive(:lose_msg)
      allow(game).to receive(:finish_game).and_return(nil)
      game.send(:lose)
    end
    it 'calls #finish_game' do
      expect(game).to receive(:finish_game)
      allow(game).to receive(:finish_game).and_return(nil)
      game.send(:lose)
    end
  end

  describe '#finish_game' do
    it 'calls GameUtils.reveal_code' do
      expect(game).to receive(:reveal_code)
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.send(:finish_game)
    end
    it 'calls GameUtils.save_score' do
      expect(game).to receive(:save_score)
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.send(:finish_game)
    end
    it 'calls GameUtils.play_again' do
      expect(game).to receive(:play_again)
      allow(game).to receive(:save_score).and_return(nil)
      allow(game).to receive(:play_again).and_return(nil)
      game.send(:finish_game)
    end
  end
end
