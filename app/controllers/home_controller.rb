class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @recent_quests = QuestPolicy::Scope.new(current_user, Quest).resolve.recent.limit(5)
    @quest_counts_by_status = Quest.status.values.index_with do |status|
      Quest.where(status: status).count
    end
  end
end
