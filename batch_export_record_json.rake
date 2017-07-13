STDOUT.sync = true

#conding: utf-8
# rake udesk_ticket:export_ticket_json subdomain=domain file_path=/home/user/tickets.json
namespace :udesk_ticket do
  desc "export tickets json for company"
  task export_ticket_json: :environment do
    subdomain = ENV['subdomain']
    # company = Company.find_by(subdomain: 'toowell')
    puts "++++++ start doing the export job"
    company = Company.find_by(subdomain: subdomain)
    file_path = ENV['file_path']
    _id = 1
    loop do
      tickets = company.tickets.includes({ user: [:org, :cellphones] }, :assignee, :priority, :creator,
                                                    :status, :platform, :callcenter_source,
                                                    :tags, :followers, :attachments, :user_group,
                                                    :template)
                       .where("id > ?", _id)
                       .limit(1000)
      if tickets.blank?
        puts "++++++ job is over"
        break
      end
      tickets.each do |ticket|
        attachments = ticket.attachments.map do |attachment|
          {id: attachment.id, url: attachment.file.url, file_name: attachment.file_file_name, content_type: attachment.file_content_type}
        end
        organization = ""
        if org = ticket.try(:user).try(:org)
          organization = org.slice(:id, :name, :description, :domains, :created_at, :custom_fields)
        end
        hash = {
          id: ticket.id,
          customer_id: ticket.user_id,
          customer_name: ticket.user.try(:nick_name),
          customer_email: ticket.user.try(:valid_email?) ? ticket.user_email : "",
          customer_cellphone: ticket.user_cellphone,
          customer_telephone: ticket.user_telephone,
          customer_owner_id: ticket.try(:user).try(:owner_id),
          customer_owner_group_id: ticket.try(:user).try(:owner_group_id),
          assignee_id: ticket.assignee_id,
          assignee_name: ticket.assignee.try(:nick_name),
          assignee_email: ticket.assignee_email,
          assignee_cellphone: ticket.assignee_cellphone,
          field_nu: ticket.field_num,
          agent_group_id: ticket.user_group_id,
          agent_group_name: ticket.user_group_name,
          priority_id: ticket.priority.id,
          priority: ticket.priority.zh_name,
          status: ticket.status.zh_name,
          platform_zh_name: ticket.platform.zh_name,
          platform_name: ticket.platform.name,
          status_id: ticket.status.id,
          subject: ticket.subject,
          satisfaction: ticket.try(:satisfaction),
          content: ticket.parse_content,
          call_direction: ticket.call_direction,
          connected_status: ticket.connected_status,
          all_tags: ticket.all_tags,
          followers: ticket.followers.map {|follower| {id: follower.id, nick_name: follower.nick_name}},
          created_at: ticket.created_at,
          custom_fields: ticket.custom_fields.to_h,
          agent_replied_at: ticket.agent_replied_at,
          customer_replied_at: ticket.customer_replied_at,
          replied_at: ticket.replied_at,
          replied_by: ticket.last_replier_nick_name,
          replier_id: ticket.replier_id,
          replier_type: ticket.replier_type,
          forward_email: ticket.forward_email,
          solved_deadline: ticket.solved_deadline,
          creator_id: ticket.try(:creator_id) || ticket.user_id,
          creator_nick_name: ticket.try(:creator_nick_name) || ticket.user.try(:nick_name),
          updated_at:  ticket.updated_at,
          closed_at: ticket.closed_at,
          resolved_at: ticket.resolved_at,
          solving_at:  ticket.solving_at,
          attachments: attachments,
          organization: organization,
          template: {template_id: ticket.template.try(:id), template_name: ticket.template.try(:name)}
        }
        json_data = hash.to_json

        open(file_path, 'a') do |file|
          file.puts json_data
        end
      end
      _id = tickets.last.id
      puts "++++++++++++++++ id: #{_id}"
    end
  end
end
