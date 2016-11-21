User.preload(:posts).to_a

# =>

# SELECT "users".* FROM "users"
# SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1)

User.preload(:posts).where("posts.desc='ruby is awesome'")

# =>

# SQLite3::SQLException: no such column: posts.desc:
# SELECT "users".* FROM "users" WHERE (posts.desc='ruby is awesome')

User.preload(:posts).where("users.name='Neeraj'")

# =>
# SELECT "users".* FROM "users" WHERE (users.name = 'Neeraj')
# SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (3)

User.includes(:posts).where('posts.desc = "ruby is awesome"').to_a

# =>
# SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "posts"."id" AS t1_r0, "posts"."title" AS t1_r1,
#        "posts"."user_id" AS t1_r2, "posts"."desc" AS t1_r3
# FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"
# WHERE (posts.desc = "ruby is awesome")

User.includes(:posts).references(:posts).to_a

# =>
# SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "posts"."id" AS t1_r0,
#        "posts"."title" AS t1_r1,
#        "posts"."user_id" AS t1_r2, "posts"."desc" AS t1_r3
# FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"

User.eager_load(:posts).to_a

# =>
# SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "posts"."id" AS t1_r0,
#        "posts"."title" AS t1_r1, "posts"."user_id" AS t1_r2, "posts"."desc" AS t1_r3
# FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"

User.joins(:posts)
# =>
# SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id"

User.joins(:posts).select('distinct users.*').to_a