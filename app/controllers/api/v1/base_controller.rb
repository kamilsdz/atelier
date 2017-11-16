module Api
  module V1
    class BaseController < ActionController::API
      #before_action :checklogin

      private
      def checklogin
        render(json: {Error: 'Acces denied'}, status: 401) unless current_user
      end

    end
  end
end
