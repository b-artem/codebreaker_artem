require 'spec_helper'

RSpec.describe CodebreakerArtem::CLI do
  CLI = CodebreakerArtem::CLI
  let(:game) { CodebreakerArtem::Game.new }

  describe '#welcome_msg' do
    it 'prints welcome message' do
      expect { CLI.welcome_msg(10) }.to output(/Welcome.+10/m).to_stdout
    end
  end

  describe '#submit_guess' do
    subject { CLI.submit_guess }
    it 'accepts proper guess' do
      allow($stdin).to receive(:gets).and_return("1234\n")
      expect(subject).to eq '1234'
    end
    it "doesn't accept too long guess" do
      allow($stdin).to receive(:gets).and_return("12345\n")
      expect(subject).to be_falsey
    end
    it "doesn't accept too short guess" do
      allow($stdin).to receive(:gets).and_return("123\n")
      expect(subject).to be_falsey
    end
    it "doesn't accept not matching guess" do
      allow($stdin).to receive(:gets).and_return("1237\n")
      expect(subject).to be_falsey
    end
  end

  describe '#win_msg' do
    it 'prints congrats message' do
      expect { CLI.win_msg }.to output(/Congratulations!/i).to_stdout
    end
  end

  describe '#lose_msg' do
    it 'prints lose message' do
      expect { CLI.lose_msg(10) }.to output(/GAME.+OVER.+10/i).to_stdout
    end
  end

  describe '#reveal_code' do
    it 'reveals secret code' do
      expect { CLI.reveal_code('1223') }.to output(/1223/i).to_stdout
    end
  end

  describe '#play_again' do
    it 'proposes to play again' do
      allow($stdin).to receive(:gets).and_return('y')
      expect { CLI.play_again }.to output(/play.+more.+time?/i).to_stdout
    end
  end

  describe '#yes?' do
    subject { CLI.yes? }
    context 'when correct input' do
      it "returns false if 'n'" do
        allow($stdin).to receive(:gets).and_return('n')
        expect(subject).to be false
      end
      it "returns true if 'y" do
        allow($stdin).to receive(:gets).and_return('y')
        expect(subject).to be true
      end
    end
    context 'when incorrect input' do
      it "prints prompt to enter 'y' or 'n'" do
        allow($stdin).to receive(:gets).and_return('r', 'n')
        expect { subject }.to output(/enter.+y.+or.+n/i).to_stdout
      end
    end
  end

  describe '#save_score' do
    it 'proposes to save score' do
      allow($stdin).to receive(:gets).and_return('y')
      expect { CLI.save_score(777) }.to output(/Do.+want.+save.+score/i).to_stdout
    end

    context 'when saving to file' do
      let(:file) { File.open('./score/score.txt') }
      it 'saves score to file' do
        allow($stdin).to receive(:gets).and_return('y')
        game.instance_variable_set(:@score, 777)
        CLI.save_score(game.instance_variable_get(:@score))
        expect(file.readlines[-2]).to eq "Score: 777\n"
      end
      it 'saves name to file' do
        allow(CLI).to receive(:yes?).and_return(true)
        allow($stdin).to receive(:gets).and_return('Elon Musk')
        CLI.save_score('777')
        expect(file.readlines[-4]).to eq "Name: Elon Musk\n"
      end
    end
  end

  describe '#show_hint' do
    context 'when hint is available' do
      it 'prints hint' do
        expect { CLI.show_hint(3, 0) }.to output(/number.+3.+position.+1/i).to_stdout
      end
    end
    context "when hint isn't available" do
      it 'returns nil' do
        expect(CLI.show_hint).to be_falsey
      end
    end
  end
end
