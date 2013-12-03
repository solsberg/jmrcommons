module JMRCommons
  class Profile
    attr_reader :user

    def initialize(user)
      @user = user
    end

    Answer = Struct.new :question, :response

    def answers
      answers = user.profile_answers
      ProfileQuestion.all.map do |question|
        answer = answers.find { |a| a.question_id == question.id }
        Answer.new question, answer ? answer.text : ""
      end
    end

    def update(params)
      params.select { |k,v| k =~ /response_[0-9]+/ }.each do |k, v|
        question_id = k[9..-1].to_i
        user.respond_to question_id, v
      end
    end
  end
end