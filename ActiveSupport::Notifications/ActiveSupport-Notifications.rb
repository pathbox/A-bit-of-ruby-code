# #{Rails.root}/config/initializers/logger_process_action.rb

# process_action.action_controller =>
# {
#   controller: "PostsController",
#   action: "index",
#   params: {"action" => "index", "controller" => "posts"},
#   headers: #<ActionDispatch::Http::Headers:0x0055a67a519b88>,
#   format: :html,
#   method: "GET",
#   path: "/posts",
#   status: 200,
#   view_runtime: 46.848,
#   db_runtime: 0.157
# }

ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new *args

  event.name     #=> process_action.action_controller
  event.duration
  event.payload  #=> { information}

  Rails.logger.info "="*60
  Rails.logger.info event.inspect
end
