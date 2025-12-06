module Api
  module V1
    class QuestsController < Api::BaseController
      before_action :set_quest, only: :show

      def index
        @quests = policy_scope(Quest)
        render json: @quests
      end

      def show
        authorize @quest
        render json: @quest
      end

      private

      def set_quest
        @quest = Quest.friendly.find(params[:id])
      end
    end
  end
end