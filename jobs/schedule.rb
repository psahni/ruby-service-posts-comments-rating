require 'rufus/scheduler'
require_relative 'feedback_job'

scheduler = Rufus::Scheduler.new

scheduler.cron '30 16 * * *' do
  puts "==> Generating xml"
  puts Time.now.to_s
  job  = FeedbackJob.new
  xml = job.generate_xml
  job.write_to_file(xml)
  puts "==> Done"
end

# scheduler.in('4s') do
#   puts "==> Generating xml"
#   job  = FeedbackJob.new
#   xml = job.generate_xml
#   job.write_to_file(xml)
#   puts "==> Done"
# end

scheduler.join
