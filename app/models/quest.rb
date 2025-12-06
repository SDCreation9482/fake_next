require "oj"

class Quest < ApplicationRecord
  extend FriendlyId
  extend Enumerize

  friendly_id :title, use: %i[slugged finders]

  belongs_to :user
  has_rich_text :summary
  has_paper_trail

  enumerize :status, in: %i[drafted launched completed archived], predicates: true, scope: true

  validates :title, :status, :user, presence: true

  scope :recent, -> { order(published_at: :desc) }
  scope :published, -> { where("published_at <= ?", Time.current) }

  after_save :broadcast_status
  after_commit :record_metrics, on: %i[create update]

  def metadata_hash
    return {} if metadata.blank?

    Oj.load(metadata)
  rescue Oj::ParseError
    {}
  end

  def metadata_hash=(value)
    self.metadata = Oj.dump(value.presence || {})
  end

  def should_generate_new_friendly_id?
    will_save_change_to_title?
  end

  private

  def broadcast_status
    QuestUpdatesChannel.broadcast_to(user, {
      id: id,
      title: title,
      slug: slug,
      status: status,
      published_at: published_at,
      summary: summary&.body&.to_s
    })
  end

  def record_metrics
    PrometheusRegistry.ensure_registered!
    PrometheusRegistry.quest_events.increment(labels: { status: status })
    PrometheusRegistry.quest_status_gauge.set(published_at&.to_i.to_i, labels: { status: status })
  end
end
