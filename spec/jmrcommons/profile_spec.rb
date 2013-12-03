require 'profile'

Question = Struct.new :id, :title
Answer = Struct.new :question_id, :text

describe JMRCommons::Profile do
  let(:questions) { (1..3).map { |n| Question.new n, "title#{n}" } }
  let(:answers) { (1..3).map { |n| Answer.new n, "answer#{n}" } }
  let(:user) { double(profile_answers: answers) }
  before { stub_const("::ProfileQuestion", double(all: questions)) }

  subject { JMRCommons::Profile.new user }

  its(:user) { should eq user }

  describe "#answers" do
    it "should include all questions" do
      expect(subject.answers.map(&:question)).to eq questions
    end

    it "should include all answers" do
      expect(subject.answers.map(&:response)).to eq answers.map(&:text)
    end
  end

  describe "#update" do
    it "should update the user's responses" do
      params = {:response_1 => "my response"}
      expect(user).to receive(:respond_to).with(1, "my response")
      subject.update params
    end
  end
end