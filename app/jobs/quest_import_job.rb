class QuestImportJob
  @queue = :quest_imports

  def self.perform(source_url, user_id)
    user = User.find(user_id)
    QuestImporter.new(source: source_url, user: user).import!
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn("Quest import failed: user #{user_id} not found")
  end
end