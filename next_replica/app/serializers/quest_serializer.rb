class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :status, :published_at, :summary_html, :metadata, :user_display

  def summary_html
    object.summary&.body&.to_html
  end

  def metadata
    object.metadata_hash
  end

  def user_display
    object.user.display_name
  end
end