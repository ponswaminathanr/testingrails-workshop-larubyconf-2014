class Group < ActiveRecord::Base
  validates :name, presence: true

  has_many :memberships
  has_many :users, through: :memberships

  def empty_post date
    Post.new(group: self, date: date)
  end

  def is_member? user
    users.include? user
  end

  def add_member user
    users << user unless is_member? user
  end

  def remove_member user
    users.destroy user if is_member? user
  end

  def posts_for date
    Post.where(group: self, date: date)
  end

  def post_for user, date
    Post.where(group: self, date: date, user: user).first
  end

  def add_post user, date, body
    Post.create group_id: self.id, user_id: user.id,
                date:     date,    body:    body
  end
end
