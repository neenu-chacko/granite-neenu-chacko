# frozen_string_literal: true

class Task < ApplicationRecord
  # MAX_TITLE_LENGTH = 125
  # , length : {maximum : MAX_TITLE_LENGTH}
  validates :title, presence: true
end
