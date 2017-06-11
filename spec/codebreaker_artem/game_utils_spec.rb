require 'spec_helper'

RSpec.describe GameUtils do
  let(:game_utils) { Class.new { include GameUtils }.new }

  it 'prints welcome message' do
    expect { game_utils.welcome_msg }.to output(/Welcome/).to_stdout
  end

end
