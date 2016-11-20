class Volunteers

  def initialize(year:)
    @year = year
  end

  def relation_select
    volunteer_ids = GroupMembership.select(:person_id).shool_year(@year)
    pta_member_ids = PtaMembership.select(:person_id).school_year(@year)

    Person
      .active
      .default
      .where(id: volunteer_ids)
      .where.not(id: pta_member_ids)
      .order(:last_name)
  end

  def relation_pluck
    volunteer_ids = GroupMembership.shool_year(@year).pluck(:person_id)
    pta_member_ids = PtaMembership.school_year(@year).pluck(:person_id)

    Person
        .active
        .default
        .where(id: volunteer_ids)
        .where.not(id: pta_member_ids)
        .order(:last_name)
  end
end

# relation_select SQL:   one sql find
# SELECT people.*
# FROM people
# WHERE people.status = 0
# AND people.kind != "student"
# AND (people.id IN (SELECT group_memberships.person_id FROM group_memberships WHERE group_memberships.school_year_id = 1))
# AND (people.id NOT IN (SELECT pta_memberships.person_id FROM pta_memberships WHERE pta_memberships.school_year_id = 1))
# ORDER BY people.last_name ASC

# relation_pluck SQL:  three sql find

# SELECT group_memberships.person_id FROM group_memberships WHERE group_memberships.school_year_id = 1

# SELECT pta_memberships.person_id FROM pta_memberships WHERE pta_memberships.school_year_id = 1

# SELECT people.*
# FROM people
# WHERE people.status = 0
# AND people.kind != "student"
# AND (people.id IN ([1,2,3,4,5])
# AND (people.id NOT IN ([1,2,3,4,5]))
# ORDER BY people.last_name ASC


Post.where(published: true).joins(:comments).merge( Comment.where(spam: false) )
# Performs a single join query with both where conditions.

recent_posts = Post.order('created_at DESC').first(5)
Post.where(published: true).merge(recent_posts)
# Returns the intersection of all published posts with the 5 most recently created posts.
# (This is just an example. You'd probably want to do this with a single query!)

Post.where(published: true).merge(-> { joins(:comments) })
# => Post.where(published: true).joins(:comments)