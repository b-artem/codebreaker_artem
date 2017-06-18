require 'spec_helper'

RSpec.describe CodebreakerArtem::Game do
  subject(:game) { CodebreakerArtem::Game.new }

  describe '#start' do
    context 'when sets initial values' do
      it 'sets @guess_count = 0' do
        expect(game.instance_variable_get(:@guess_count)).to eq 0
      end
      it 'sets @score = 0' do
        expect(game.instance_variable_get(:@score)).to eq 0
      end
      it 'sets @hint_available = true' do
        expect(game.instance_variable_get(:@hint_available)).to eq true
      end
    end

    context 'when generates secret code' do
      subject { game.instance_variable_get(:@secret_code) }
      before do
        game.start
      end
      it 'saves secret code' do
        expect(subject).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(subject.length).to eq 4
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(Validator.code_valid?(subject)).to be true
      end
    end
  end

  describe '#mark_guess' do
    before do
      game.instance_variable_set(:@secret_code, '1223')
    end

    context 'when secret_code is 1223' do
      it "marks 4556 as ''" do
        expect(game.mark_guess('4556')).to eq ''
      end
      it 'marks 1556 as +' do
        expect(game.mark_guess('1556')).to eq '+'
      end
      it 'marks 1553 as ++' do
        expect(game.mark_guess('1553')).to eq '++'
      end
      it 'marks 1356 as +-' do
        expect(game.mark_guess('1356')).to eq '+-'
      end
      it 'marks 1156 as +' do
        expect(game.mark_guess('1156')).to eq '+'
      end
      it 'marks 1335 as +-' do
        expect(game.mark_guess('1335')).to eq '+-'
      end
      it 'marks 3112 as ---' do
        expect(game.mark_guess('3112')).to eq '---'
      end
      it 'marks 2132 as ----' do
        expect(game.mark_guess('2132')).to eq '----'
      end
      it 'marks 1223 as ++++' do
        expect(game.mark_guess('1223')).to eq '++++'
      end
    end

    context 'when doing additional data testing' do
      it 'passes all tests' do
        TestData.data.each do |item|
          game.instance_variable_set(:@secret_code, item[0])
          expect(game.mark_guess(item[1])).to eq item[2]
        end
      end
    end
  end

  describe '#hint' do
    before do
      game.instance_variable_set(:@secret_code, '1234')
    end
    let(:hint) { game.hint }
    let(:number) { hint[0] }
    let(:position) { hint[1] }
    let(:secret_code) { '1234' }

    it 'reveals one of the numbers in secret code' do
      expect(secret_code.include?(number.to_s)).to be true
    end
    it 'reveals position of the number in secret code' do
      expect(secret_code[position]).to eq number.to_s
    end
  end
end
