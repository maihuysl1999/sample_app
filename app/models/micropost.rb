class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  delegate :name, to: :user, prefix: true

  PERMITTED_FIELDS = %i(content image).freeze

  validates :user_id, presence: true
  validates :content, presence: true,
            length:
              {maximum: Settings.validate.micropost.max}
  validates :image,
            content_type: {
              in: Settings.image_restricted_types,
              message: I18n.t("image_type")
            },
            size: {
              less_than: Settings.validate.image.size.megabytes,
              message: I18n.t("image_size", size: Settings.validate.image.size)
            }

  scope :newest, ->{order created_at: :desc}

  scope :by_user_id, ->(id){where user_id: id}

  def display_image
    image.variant resize_to_limit: Settings.image.limit
  end
end
