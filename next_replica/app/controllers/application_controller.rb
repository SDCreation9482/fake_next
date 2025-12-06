class ApplicationController < ActionController::Base
	include Pundit

	before_action :authenticate_user!
	protect_from_forgery with: :exception

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	private

	def user_not_authorized
		respond_to do |format|
			format.html { redirect_back fallback_location: root_path, alert: "You are not authorized to perform this action." }
			format.json { render json: { error: "unauthorized" }, status: :forbidden }
		end
	end
end
