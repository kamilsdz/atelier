require "rails_helper"

RSpec.describe GivenBackPolicy, type: :service do
  let(:user) { double }
  let(:book) { double }
  subject { described_class.new(user: user, book: book) }

  describe '#applies' do
    context 'without any reservations' do
      before { allow(book).to receive_message_chain(:reservations, :find_by).and_return(nil) }
    it {
      expect(subject.applies?).to be_falsey
    }
  end

    context 'without any reservations' do
      before { allow(book).to receive_message_chain(:reservations, :find_by).and_return('reservation') }
    it {
      expect(subject.applies?).to be_truthy
    }
    end
  end

end
