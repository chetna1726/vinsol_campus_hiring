class Admin < ActiveRecord::Base
  auto_strip_attributes :name, :email, squish: true

  has_many :questions, dependent: :restrict_with_exception
  has_many :quizzes, dependent: :restrict_with_exception

  validates :uid, uniqueness: { scope: :provider }, if: 'uid.present?'
  validates :email, presence: true

  with_options if: 'email.present?' do |admin|
    admin.validates :email, format: { with: /\A\w+\.?\w+@vinsol.com\z/, message: 'should be a vinsol email' }
    admin.validates :email, uniqueness: true
  end

  def set_oauth_information(auth)
    self.provider = auth["provider"]
    self.uid = auth["uid"]
    self.refresh_token = auth["credentials"]["refresh_token"]
    self.access_token = auth["credentials"]["token"]
    self.expires = Time.at(auth["credentials"]["expires_at"])
    self.name = auth["info"]["name"]
  end

end
