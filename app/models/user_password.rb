class UserPassword < ApplicationRecord
  # Viewer can only view the password
  # Editor can update password
  # Owner can view, edit and share password
  ROLES = %w[viewer editor owner].freeze

  belongs_to :user
  belongs_to :password

  validates :role, presence: true, inclusion: { in: ROLES }

  attribute :role, default: :viewer

  def editable?
    owner? || editor?
  end

  def shareable?
    owner?
  end

  def deleteable?
    owner?
  end

  private

  def owner?
    role == 'owner'
  end

  def viewer?
    role == 'viewer'
  end

  def editor?
    role == 'editor'
  end
end
