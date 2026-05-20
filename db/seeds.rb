user = User.find_or_create_by!(email: "advisor@signalforge.ai") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end

client = user.clients.find_or_create_by!(email: "olivia.hart@example.com") do |c|
  c.full_name = "Olivia Hart"
  c.phone = "+1 212 555 0123"
  c.risk_profile = "Balanced"
  c.lifecycle_stage = "active"
  c.profile_notes = "Prefers quarterly rebalancing and tax-aware strategies."
end

note = user.notes.find_or_create_by!(client: client, title: "Initial discovery call") do |n|
  n.source_type = "meeting_note"
  n.raw_content = "Client is planning retirement in 8 years, asks for downside protection and moderate growth."
  n.summary = "Discussed retirement target, risk tolerance, and transition strategy."
  n.action_items = "1) Prepare allocation proposal\n2) Share tax optimization checklist"
  n.email_draft = "Hi Olivia, great meeting today. Attached is a first-pass proposal and next steps."
  n.processing_status = "completed"
end

user.documents.find_or_create_by!(title: "Retirement Planning Framework") do |d|
  d.client = client
  d.content = "Use glide path adjustments annually, monitor sequence-of-returns risk, and automate contribution reviews."
  d.status = "ready"
  d.source_type = "advisor_doc"
end

ActivityLog.find_or_create_by!(user: user, client: client, note: note, log_type: "seed_activity") do |log|
  log.content = "Seed data initialized for demo workflow."
end

puts "Seeded user: advisor@signalforge.ai / password123"
