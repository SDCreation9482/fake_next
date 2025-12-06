require "prometheus/client"

module PrometheusRegistry
  extend self

  def registry
    @registry ||= Prometheus::Client.registry
  end

  def quest_events
    @quest_events ||= Prometheus::Client::Counter.new(
      :quest_events_total,
      docstring: "Total number of quest lifecycle events",
      labels: [:status]
    )
  end

  def quest_status_gauge
    @quest_status_gauge ||= Prometheus::Client::Gauge.new(
      :quest_status_published_at,
      docstring: "Published timestamp of the latest quest per status",
      labels: [:status]
    )
  end

  def ensure_registered!
    return if @registered

    registry.register(quest_events)
    registry.register(quest_status_gauge)
    @registered = true
  rescue Prometheus::Client::Registry::AlreadyRegisteredError
    @registered = true
  end

end

PrometheusRegistry.ensure_registered!
