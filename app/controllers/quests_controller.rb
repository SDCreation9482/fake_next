class QuestsController < ApplicationController
  before_action :set_quest, only: %i[show edit update destroy]

  def index
    @quests = policy_scope(Quest).recent.limit(20)
  end

  def show
    authorize @quest
  end

  def new
    @quest = current_user.quests.build
    authorize @quest
  end

  def edit
    authorize @quest
  end

  def create
    @quest = current_user.quests.build(quest_params)
    authorize @quest

    if @quest.save
      redirect_to @quest, notice: "Quest saved and will be broadcast shortly."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @quest

    if @quest.update(quest_params)
      redirect_to @quest, notice: "Quest updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @quest
    @quest.destroy

    redirect_to quests_path, notice: "Quest removed."
  end

  def import
    authorize Quest
    Resque.enqueue(QuestImportJob, quest_import_params[:source_url], current_user.id)

    redirect_to quests_path, notice: "Quest import scheduled."
  end

  private

  def set_quest
    @quest = Quest.friendly.find(params[:id])
  end

  def quest_params
    params.require(:quest).permit(:title, :status, :metadata, :published_at, :summary)
  end

  def quest_import_params
    params.require(:import).permit(:source_url)
  end
end
