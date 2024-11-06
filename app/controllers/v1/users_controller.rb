module V1
  class UsersController < ApiController
    include ActionController::Cookies
    skip_before_action :check_authenticate!, only: %i[create], raise: false
    before_action :authenticate_user, only: [:create]

    def index
      users = User.all
      render json: users
    end

    def show
      user = User.find(params[:id])
      render json: user
    end

    def create
      if @firebase_id == user_params[:firebase_id]
        user = User.new(user_params)

        if user.save
          token = generate_token(@firebase_id)

          user_attributes = {
            id: user.id,
            bio: user.bio,
            nickname: user.nickname,
            username: user.username,
          }

          render json: { user: user_attributes, token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Unauthorized user. UID does not match.' }, status: :unauthorized
      end
    end

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      render json: {}, status: :no_content
    end

    private

    def authenticate_user
      token = request.headers['Authorization']
      return render json: { error: 'Token not provided' }, status: :unauthorized if token.blank?

      firebase_response = Firebase.get_user_by_token(token)
      firebase_data = JSON.parse(firebase_response.body)

      if firebase_data['users'] && firebase_data['users'].any?
        @firebase_user = firebase_data['users'].first
        @firebase_id = @firebase_user['localId']
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    rescue RestClient::Unauthorized, RestClient::Forbidden
      render json: { error: 'Token verification failed' }, status: :unauthorized
    end

    def generate_token(firebase_id)
      JsonWebToken.encode({ firebase_id: firebase_id }, Settings.jwt.time_exp.hours.from_now, Settings.jwt.alg)
    end

    def user_params
      params.require(:user).permit(:firebase_id, :bio, :email, :nickname, :username)
    end
  end
end
