require 'spec_helper'

describe User do

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:todos) }

  describe 'should be valid' do
    it 'with correct data' do
      user = User.new(name: "Example User", email: "correct@email.com")
      expect(user).to be_valid
    end
  end

  describe 'should not be valid' do
    it 'with no name' do
      user = User.new(name: "", email: "some@email.com")
      expect(user).not_to be_valid
    end
    it 'with no email' do
      user = User.new(name: "Example User", email: "")
      expect(user).not_to be_valid
    end
    it 'with incorrect email' do
      user = User.new(name: "Example User", email: "dsfasasdfsadf")
      expect(user).not_to be_valid
    end
  end

end
