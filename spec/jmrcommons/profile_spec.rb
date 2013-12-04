require 'profile'

Question = Struct.new :id, :title
Answer = Struct.new :question_id, :text

describe JMRCommons::Profile do
  let(:questions) { (1..3).map { |n| Question.new n, "title#{n}" } }
  let(:answers) { (1..3).map { |n| Answer.new n, "answer#{n}" } }
  let(:user) { double("user") }
  before { stub_const("::ProfileQuestion", double(all: questions)) }

  subject { JMRCommons::Profile.new user }

  its(:user) { should eq user }

  context "all questions answered" do
    before { user.stub(profile_answers: answers) }
    
    describe "#answers" do
      it "should include all questions" do
        expect(subject.answers.map(&:question)).to eq questions
      end

      it "should include all answers" do
        expect(subject.answers.map(&:response)).to eq answers.map(&:text)
      end
    end

    describe "#responses" do
      it "should include all questions" do
        expect(subject.responses.map(&:question)).to eq questions
      end

      it "should include all answers" do
        expect(subject.responses.map(&:response)).to eq answers.map(&:text)
      end
    end
  end

  context "some questions unanswered" do
    let(:only_answer) { answers[1] }
    before { user.stub(profile_answers: [only_answer]) }

    describe "#answers" do
      it "should include all questions" do
        expect(subject.answers.map(&:question)).to eq questions
      end

      it "should include all answers" do
        expect(subject.answers.map(&:response)).to eq answers.map{|a| a == only_answer ? a.text : ""}
      end
    end

    describe "#responses" do
      it "should only include answered questions" do
        expect(subject.responses.map(&:question)).to eq [questions[1]]
      end

      it "should only include answers with responses" do
        expect(subject.responses.map(&:response)).to eq [only_answer.text]
      end
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