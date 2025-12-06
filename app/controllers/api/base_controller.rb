module Api
  class BaseController < ActionController::API
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :forbid

    private

    def forbid
      head :forbidden
    end
  end
end