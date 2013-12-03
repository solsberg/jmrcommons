class User < ActiveRecord::Base
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]{5,50}\Z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A\S+\Z/
  validates :name, 
      presence: true,
      format: {with: VALID_USERNAME_REGEX, message: 'can only contain letters, numbers and underscores.'},
      uniqueness: { case_sensitive: false }
  validates :email, 
      presence: true,
      format: VALID_EMAIL_REGEX,
      uniqueness: { case_sensitive: false }
  validates :password, 
      length: { minimum: 6 },
      format: {with: VALID_PASSWORD_REGEX, message: 'must not contain spaces.'}

  has_secure_password
  has_many :profile_answers

  before_save { email.downcase! }

  def respond_to(question, response_text)
    question_id = question.is_a?(Fixnum) ? question : question.id
    current_answer = profile_answers.find_by_question_id(question_id)
    if current_answer.nil?
      answer = self.profile_answers.build(question_id: question_id, text: response_text)
      answer.save
    else
      current_answer.update_attributes(text: response_text)
    end
  end
end
