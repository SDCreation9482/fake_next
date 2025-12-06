require "tempfile"
require "fileutils"
require "roo"
require "smarter_csv"

class QuestImporter
  SOURCE_HEADERS = %i[title status summary published_at].freeze

  attr_reader :source, :user

  def initialize(source:, user:)
    @source = source
    @user = user
    @downloaded_path = nil
  end

  def import!
    normalized_rows.each do |row|
      metadata = row.except(*SOURCE_HEADERS)
      quest = user.quests.find_or_initialize_by(title: row[:title].presence || default_title)
      quest.status = row[:status].presence || "drafted"
      quest.published_at = parse_time(row[:published_at]) || Time.current
      quest.summary = row[:summary]
      quest.metadata_hash = metadata
      quest.save! if quest.changed?
    end
  ensure
    cleanup
  end

  private

  def normalized_rows
    return [] unless File.exist?(source_path)

    if spreadsheet?(source_path)
      parse_spreadsheet
    else
      SmarterCSV.process(source_path, file_encoding: "bom|utf-8", convert_values_to_numeric: true).map do |row|
        symbolized(row)
      end
    end
  end

  def parse_spreadsheet
    workbook = Roo::Spreadsheet.open(source_path)
    sheet = workbook.sheet(0)
    headers = sheet.row(1).map { |value| value.to_s.parameterize.underscore.to_sym }

    rows = []
    sheet.each_with_index do |row, index|
      next if index.zero?

      hash = headers.zip(row).to_h
      rows << symbolized(hash)
    end

    rows
  end

  def symbolized(row)
    row.transform_keys { |key| key.to_s.parameterize.underscore.to_sym }
  end

  def spreadsheet?(path)
    %w[.xlsx .xls].include?(File.extname(path).downcase)
  end

  def source_path
    return @source_path if defined?(@source_path)

    @source_path = if remote_source?
      download_remote
    else
      Pathname.new(source.presence || default_seed).to_s
    end
  end

  def remote_source?
    source.present? && source.match?(%r{https?://})
  end

  def download_remote
    response = HTTParty.get(source, headers: { "Accept" => "text/csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }, timeout: 10)
    raise "Unable to fetch #{source}" unless response.success?

    temp = Tempfile.new(["quest-import", File.extname(source)])
    temp.binmode
    temp.write(response.body)
    temp.flush
    @downloaded_path = temp.path
    temp.path
  end

  def default_seed
    Rails.root.join("db", "quests_seed.csv").to_s
  end

  def default_title
    "Imported quest at #{Time.current.iso8601}"
  end

  def parse_time(value)
    return if value.blank?

    Time.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def cleanup
    FileUtils.rm_f(@downloaded_path) if @downloaded_path
  end
end