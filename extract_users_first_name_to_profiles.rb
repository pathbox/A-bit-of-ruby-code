class ExtractUsersFirstNameToProfiles < ActiveRecord::Migration
  class User < ActiveRecord::Base; end
  class Profile < ActiveRecord::Base; end

  def up
    add_reference :users, :profile, index: true, unique: true, foreign_key: true

    User.find_each do |user|
      profile = Profile.create!(first_name: user.first_name)
      user.update!(profile_id: profile.id)
    end
    change_column_null :users, :profile_id, false
  end

  def down
    remove_reference :users, :profile
  end
end

class User < ActiveRecord::Base
  belongs_to :profile, autosave: true

  def first_name
    log_backtrace(:first_name)
    profile.first_name
  end

  def first_name=(new_first_name)
    log_backtrace(:first_name)

    super

    profile.first_name = new_first_name
  end

  private

  def log_backtrace
    filtered_backtrace = caller.select do |item|
      item.start_with?(Rails.root.to_s)
    end
    Rails.logger.warn(<<-END)
    A reference to an obsolete attribute #{name} at:
    #{filtered_backtrace.join("\n")}
    END
  end
end
