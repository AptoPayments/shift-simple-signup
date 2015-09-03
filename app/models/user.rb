class User
  include ActiveModel::Model
  attr_accessor :first_name, :last_name, :email,
                :phone_number, :date_of_birth, :ssn,
                :address, :city, :state, :zip_code,
                :token, :refresh_token, :response

  def create
    self.response = HTTParty.post('https://api.shiftpayments.com/cardholders',
      body: shift_params.to_json,
      basic_auth: {
        username: ENV['SHIFT_API_PUBLISHABLE'],
        password: ENV['SHIFT_API_SECRET']
      }
    )
    !self.response['error']
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
