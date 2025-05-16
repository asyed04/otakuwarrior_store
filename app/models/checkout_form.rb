class CheckoutForm
  include ActiveModel::Model

  attr_accessor :name, :email, :address, :city, :postal_code, :province

  validates :name, :email, :address, :city, :postal_code, :province, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postal_code,
            format: { with: /\A[ABCEGHJ-NPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ -]?\d[ABCEGHJ-NPRSTV-Z]\d\z/i,
                      message: 'is invalid (e.g., A1A 1A1)', }
end
