class User
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email,
                :phone_number, :date_of_birth, :ssn,
                :address, :city, :state, :zip_code, :country,
                :token, :refresh_token, :card_design,
                :response

  validates_presence_of :first_name, :last_name, :email,
                        :phone_number, :date_of_birth,
                        :address, :city, :state, :zip_code

  validates :phone_number, numericality: true, length: { minimum: 10, maximum: 11 }
  validates :zip_code, numericality: true, length: { is: 5 }
  validates :ssn, numericality: true, length: { is: 9 }
  validates :cardholder_agreement, acceptance: true

  def create
    puts "[API REQUEST]: email=#{self.email}, body=#{shift_params.to_json.inspect}"

    resp = HTTParty.post('https://api.shiftpayments.com/cardholders',
      body: shift_params.to_json,
      basic_auth: {
        username: ENV['SHIFT_API_PUBLISHABLE'],
        password: ENV['SHIFT_API_SECRET']
      }
    )

    puts "[API RESPONSE]: email=#{self.email}, body=#{resp.body}"

    self.response = JSON.parse(resp.body)
    self.response['cardholder'] && self.response['cardholder']['created_at']
  end

  private

    def shift_params
      {
        first_name: self.first_name,
        last_name: self.last_name,
        email: self.email,
        phone_number: self.phone_number,
        access_token: self.token,
        refresh_token: self.refresh_token,
        date_of_birth: self.date_of_birth,
        card_design: self.card_design,
        address: {
          street_one: self.address,
          street_two: '',
          locality: self.city,
          region: self.state,
          postal_code: self.zip_code,
          country: 'USA'
        },
        document: {
          type: 'SSN',
          value: self.ssn
        }
      }
    end
end
