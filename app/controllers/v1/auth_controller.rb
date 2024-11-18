# frozen_string_literal: true

module V1
  class AuthController < ApiController
    skip_before_action :check_authenticate!, only: %i[create], raise: false

    def create
      token = request.headers['Authorization']

      firebase_response = Firebase.get_user_by_token(token)
      firebase_data = JSON.parse(firebase_response.body)

      if firebase_data['users'] && firebase_data['users'].any?
        @firebase_user = firebase_data['users'].first
        @firebase_id = @firebase_user['localId']

        token = generate_token(@firebase_id)
        user = User.find_by(firebase_id: @firebase_id)
        user_id = user.id

        render json: { token: token, user_id: user_id }, status: :created
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.require(:auth).permit(:firebase_id, :email)
    end

    def generate_token(firebase_id)
      JsonWebToken.encode({ firebase_id: firebase_id }, Settings.jwt.time_exp.hours.from_now, Settings.jwt.alg)
    end
  end
end
