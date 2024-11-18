module V1
  class ApiController < ApplicationController
    before_action :check_authenticate!

    private

    def check_authenticate!
      token = request.headers['Authorization']
      return render_unauthorized('Authorization token is missing') if token.blank?

      begin
        decoded = JsonWebToken.decode(token)
        user = User.find_by(firebase_id: decoded[:firebase_id])

        if user.nil?
          render_unauthorized('User not found')
          return
        end

        requested_user_id = user.id

        requested_user_id = params[:user_id].to_i
        if user.id != requested_user_id
          render_unauthorized('Unauthorized access to user information')
          return
        end
      rescue ActiveRecord::RecordNotFound => e
        render_unauthorized(e.message)
      rescue JWT::DecodeError => e
        render_unauthorized(e.message)
      end
    end

    def render_unauthorized(errors)
      render json: { errors: errors }, status: :unauthorized
    end
  end
end