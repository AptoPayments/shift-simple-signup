class User
  include ActiveModel::Model
  attr_accessor :first_name, :last_name, :email,
                :phone_number, :date_of_birth,
                :address, :city, :state, :zip_code,
                :social_security_number, :access_token


  def create
    params = self.to_shift_params()
    post(params.to_json)
  end

  private

    def post(body)
      response = HTTParty.post('https://api.shiftpayments.com/cardholders',
        body: body,
        basic_auth: {
          username: Rails.application.secrets.shift_api_publishable,
          password: Rails.application.secrets.shift_api_secret
        }
      )
    end

    def to_shift_params
      {
        first_name: self.first_name,
        last_name: self.last_name,
        email: self.email,
        phone_number: self.phone_number,
        access_token: session[:token],
        date_of_birth: self.date_of_birth,
        address: {
          street_one: self.address,
          locality: self.city,
          region: self.state,
          postal_code: self.zip_code,
          country: 'USA'
        },
        document: {
          type: 'SSN',
          value: self.social_security_number
        }
      }
    end
end
