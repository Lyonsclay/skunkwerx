class MaloneTune < ActiveRecord::Base
  has_many :line_items
  has_many :engine_tunes
  has_many :engines, -> { uniq }, through: :engine_tunes
  validates :name, :quantity, :unit_cost, presence: true
  validates :unit_cost, numericality: {greater_than_or_equal_to: 0.01}

  # This method associates the attribute ":image" with a file atachment
  has_attached_file :image,
    styles: {
      thumb: '100x100#',
      square: '200x200#',
      medium: '300x300#'
    },
    default_url: ':style/tune_missing.png',
    bucket: 'skunkwerx',
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_file_name :image, :matches => [/(gif|jp?g|png)\Z/i]

  # For caching
  def self.latest
    Product.order(:updated_at).latest
  end

  def price
    unit_cost || standalone_price || price_with_purchase
  end
end