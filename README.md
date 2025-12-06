# NextReplica

NextReplica is an imaginative Rails 7.0 application that showcases a mix of
Action Cable, Action Text, Devise, Pundit, FriendlyId, Resque/Resque Scheduler,
ActiveModel Serializers, Prometheus metrics, and a CSV/XLSX importer powered by
SmarterCSV, Roo, and HTTParty.

## Highlights

1. **Authentication & authorization** – Devise manages confirmation and lock
	flows while Pundit guards quest actions and scopes. Users gain enumerized
	roles (`member`, `organizer`, `admin`) with `friendly_id` slugs for quests.
2. **Quest content** – Action Text powers the rich-text summary, PaperTrail
	records every change, and Prometheus counters/gauges track quest events and
	publication timestamps.
3. **Imports & background work** – `QuestImportJob` enqueues Resque workers.
	The importer handles remote CSV/XLSX sources using HTTParty, SmarterCSV, and
	Roo before persisting structured metadata via Oj.
4. **Streaming** – Action Cable broadcasts quest updates via
	`QuestUpdatesChannel`, enabling live client hooks.
5. **API surface** – `Api::V1::QuestsController` renders JSON via
	`ActiveModel::Serializer`, exposing `summary_html`, metadata, and user
	display data.

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Defaults assume SQLite for development, Redis (at `redis://localhost:6379/0`)
for Resque, and Rails credentials handle mailer host configuration. Use
`REDIS_URL` to point Resque to a different backend.

## Testing & jobs

```bash
bundle exec rspec
```

Run `QUEUE=* bundle exec rake resque:work` (or a Procfile equivalent) to process
imports. The importer loads `db/quests_seed.csv` by default but accepts a
`source_url` when scheduling `POST /quests/import`.

## Routes

```
root GET     /                        home#index
quests GET    /quests(.:format)        quests#index
		 POST   /quests/import(.:format) quests#import
		 GET    /quests/:id(.:format)    quests#show
		 ...
api_v1_quests GET /api/v1/quests(.:format)    api/v1/quests#index
					GET /api/v1/quests/:id(.:format) api/v1/quests#show
``` 

## Notes

- Devise requires `config.action_mailer.default_url_options` per environment.
- `QuestImporter` normalizes metadata into JSON via `Oj`, ensuring `metadata_hash`
  always returns a symbolized hash.
- All views render flash messages, navigation, and a Simple Form-based quest
  editor that submits to Action Text.
