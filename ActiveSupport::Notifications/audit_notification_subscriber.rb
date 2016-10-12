# lib/initializers/audit_notification_subscriber.rb
ActiveSupport::Notifications.subscribe(/audit) do |*args|
  data = args.last
  event_name = data[:event_name]
  audited_object = data[:audited_object]
  current_user = data[:current_user]
  patient = data[:patient]

  audit_data = {
    event: event_name,
    modified_by: {
      name: current_user.full_name,
      email: current_user.email
    },
    data: audited_object.audit_data,
    patient: {
      patient.full_name,
      patient.patient.id
    }

    Audit.create! audit_data
  }
