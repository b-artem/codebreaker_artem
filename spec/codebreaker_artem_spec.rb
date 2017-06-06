require "spec_helper"
require 'codebreaker_artem'

RSpec.describe CodebreakerArtem do
  it "has a version number" do
    expect(CodebreakerArtem::VERSION).not_to be nil
  end
end
