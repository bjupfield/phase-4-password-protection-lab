class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :unproccessable
rescue_from ActiveRecord::RecordNotFound, with: :not_found
    def create
        user = User.create(allowed_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    def show
        user = User.find(session[:user_id])
        render json: user
    end
    private
    
    def allowed_params
        params.permit(:username, :password, :password_confirmation)
    end
    def unproccessable(invalid)
        render json: {error: invalid.record.errors}, status: :unproccessable_entity
    end
    def not_found
        render json: {error: "Not real"}, status: :unauthorized
    end
end
