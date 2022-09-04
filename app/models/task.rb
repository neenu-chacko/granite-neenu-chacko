# frozen_string_literal: true

class Task < ApplicationRecord
  # MAX_TITLE_LENGTH = 125
  # , length : {maximum : MAX_TITLE_LENGTH}
  belongs_to :assigned_user, foreign_key: "assigned_user_id", class_name: "User"
  belongs_to :task_owner, foreign_key: "task_owner_id", class_name: "User"

  validates :title, presence: true, length: { maximum: 50 }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug

  before_validation :set_title, if: :title_not_present
  has_many :comments, dependent: :destroy

  private

    def set_slug
      title_slug = title.parameterize
      regex_pattern = "slug #{Constants::DB_REGEX_OPERATOR} ?"
      latest_task_slug = Task.where(
        regex_pattern,
        "#{title_slug}$|#{title_slug}-[0-9]+$"
      ).order("LENGTH(slug) DESC", slug: :desc).first&.slug
      slug_count = 0
      if latest_task_slug.present?
        slug_count = latest_task_slug.split("-").last.to_i
        only_one_slug_exists = slug_count == 0
        slug_count = 1 if only_one_slug_exists
      end
      slug_candidate = slug_count.positive? ? "#{title_slug}-#{slug_count + 1}" : title_slug
      self.slug = slug_candidate
    end

    def slug_not_changed
      if slug_changed? && self.persisted?
        errors.add(:slug, t("task.slug.immutable"))
      end
    end

    def title_not_present
      self.title.blank?
    end

    def set_title
      self.title = "Pay electricity bill"
    end

    def print_set_title
      puts self.title
    end
end
