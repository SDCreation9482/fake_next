# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# seed an admin user with onboarding quests
admin = User.find_or_initialize_by(email: "admin@nextreplica.local") do |user|
	user.name = "Mission Admin"
	user.role = :admin
	user.password = "password"
	user.password_confirmation = "password"
	user.confirmed_at = Time.current
end
admin.save! if admin.changed?

# reuse the CSV importer to ensure metadata stays structured
QuestImporter.new(source: Rails.root.join("db", "quests_seed.csv").to_s, user: admin).import!
