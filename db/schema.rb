# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_01_161509) do

  create_table "activities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "user_id"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "modifier"
    t.text "cached_html"
    t.index ["resource_type", "resource_id"], name: "index_activities_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "story_id"
    t.integer "activity_rating"
    t.datetime "active_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["active_at", "activity_rating"], name: "activities_combined"
    t.index ["active_at"], name: "index_activity_histories_on_active_at"
    t.index ["activity_rating"], name: "index_activity_histories_on_activity_rating"
    t.index ["story_id", "active_at"], name: "index_activity_histories_on_story_id_and_active_at"
  end

  create_table "blog_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.text "extended_body"
    t.integer "user_id"
    t.string "cached_tag_list"
    t.datetime "published_at"
    t.integer "blog_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "basename"
    t.index ["basename"], name: "index_blog_posts_on_basename"
  end

  create_table "bookmarks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "user_id"
    t.text "notes"
    t.boolean "is_public", default: true
    t.boolean "is_own", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenge_submissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "story_id"
    t.integer "challenge_id"
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["challenge_id", "story_id"], name: "index_challenge_submissions_on_challenge_id_and_story_id"
  end

  create_table "challenges", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "winner_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "ratings_count", default: 0
    t.integer "total_ratings_score", default: 0
    t.float "average_rating", default: 0.0
    t.datetime "featured_at"
    t.integer "view_count"
    t.integer "activity_rating", default: 0
    t.boolean "is_mature", default: false
    t.index ["activity_rating"], name: "index_challenges_on_activity_rating"
    t.index ["is_mature"], name: "index_challenges_on_is_mature"
  end

  create_table "clusters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "data"
    t.integer "stories_count", default: 0
    t.integer "activity_rating", default: 0
    t.integer "active_story_id"
    t.integer "story_id"
    t.integer "first_story_id"
    t.integer "last_story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.integer "resource_id"
    t.string "resource_type"
    t.boolean "is_deleted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resource_id", "resource_type", "created_at"], name: "index_comments_on_resource_id_and_resource_type_and_created_at"
  end

  create_table "flickr_photos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "farm_id"
    t.integer "server_id"
    t.integer "photo_id"
    t.string "secret"
    t.string "flickr_username"
    t.string "flickr_display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "size"
    t.string "content_type"
    t.string "filename"
    t.string "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inspirations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "resource_id"
    t.string "resource_type"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inspirations_stories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "inspiration_id"
    t.integer "story_id"
  end

  create_table "notes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipient_id"
    t.string "subject"
    t.text "body"
    t.boolean "user_deleted", default: false
    t.boolean "recipient_deleted", default: false
    t.boolean "recipient_read"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_notes_on_parent_id"
    t.index ["recipient_id"], name: "index_notes_on_recipient_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "pages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "basename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "resource_id"
    t.string "resource_type"
    t.integer "user_id"
    t.integer "score", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resource_type", "resource_id", "created_at"], name: "ratings_resources_created_at"
    t.index ["resource_type", "resource_id"], name: "index_ratings_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reputation_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "event_type"
    t.integer "user_id"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["created_at", "resource_type", "resource_id"], name: "reputation_resources"
    t.index ["event_type"], name: "index_reputation_events_on_type"
    t.index ["resource_id", "resource_type"], name: "index_reputation_events_on_resource_id_and_resource_type"
    t.index ["resource_type", "resource_id", "created_at"], name: "reputation_events_resource_created_at"
    t.index ["user_id"], name: "index_reputation_events_on_user_id"
  end

  create_table "stories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "published_at"
    t.boolean "is_draft", default: false
    t.text "tags"
    t.integer "sequel_to"
    t.integer "prequel_to"
    t.integer "inspiration_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "ratings_count", default: 0
    t.integer "total_ratings_score", default: 0
    t.float "average_rating", default: 0.0
    t.boolean "is_deleted", default: false
    t.datetime "featured_at"
    t.boolean "is_mature", default: false
    t.integer "view_count", default: 0
    t.integer "activity_rating", default: 0
    t.text "cached_html"
    t.string "snippet"
    t.integer "cluster_id"
    t.index ["activity_rating"], name: "index_stories_on_activity_rating"
    t.index ["average_rating"], name: "index_stories_on_average_rating"
    t.index ["cluster_id"], name: "index_stories_on_cluster_id"
    t.index ["inspiration_id"], name: "index_stories_on_inspiration_id"
    t.index ["prequel_to"], name: "index_stories_on_prequel_to"
    t.index ["published_at"], name: "index_stories_on_published_at"
    t.index ["sequel_to"], name: "index_stories_on_sequel_to"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.datetime "created_at"
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "taggings_tag_id_id_type"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "login_key"
    t.string "uri_name"
    t.text "bio"
    t.string "url"
    t.string "url_title"
    t.boolean "is_admin", default: false
    t.string "icon_url"
    t.string "login_type"
    t.string "thumbnail"
    t.string "filename"
    t.integer "size"
    t.string "content_type"
    t.integer "icon_id"
    t.boolean "show_mature", default: false
    t.string "time_zone"
    t.integer "activity_rating", default: 0
    t.integer "total_activity_rating", default: 0
    t.integer "commenter_rating", default: 0
    t.integer "continuity_rating", default: 0
    t.integer "authorship_rating", default: 0
    t.integer "challenger_rating", default: 0
    t.string "email"
    t.boolean "send_daily_activity", default: false
    t.boolean "send_new_comments", default: false
    t.boolean "send_new_sequels", default: false
    t.boolean "send_new_challenge_entries", default: false
    t.boolean "send_new_notes", default: false
    t.boolean "user_is_deleted", default: false
    t.boolean "active", default: false
    t.index ["activity_rating"], name: "index_users_on_activity_rating"
    t.index ["authorship_rating"], name: "index_users_on_authorship_rating"
    t.index ["challenger_rating"], name: "index_users_on_challenger_rating"
    t.index ["commenter_rating"], name: "index_users_on_commenter_rating"
    t.index ["continuity_rating"], name: "index_users_on_continuity_rating"
    t.index ["email"], name: "index_users_on_email"
    t.index ["login_key", "login_type"], name: "index_users_on_login_key_and_login_type", unique: true
    t.index ["send_daily_activity"], name: "index_users_on_send_daily_activity"
    t.index ["send_new_notes"], name: "index_users_on_send_new_notes"
    t.index ["total_activity_rating"], name: "index_users_on_total_activity_rating"
    t.index ["uri_name"], name: "index_users_on_uri_name"
  end

end
