CREATE TABLE "profiles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "firstname" varchar(255), "lastname" varchar(255), "email" varchar(255), "bio" text, "languages" varchar(255), "city" varchar(255), "twitter" varchar(255), "picture" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "confirmation_token" varchar(255), "confirmed_at" datetime, "confirmation_sent_at" datetime, "unconfirmed_email" varchar(255), "talks" varchar(255), "admin" boolean DEFAULT 'f', "provider" varchar(255), "uid" varchar(255));
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "taggings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tag_id" integer, "taggable_id" integer, "taggable_type" varchar(255), "tagger_id" integer, "tagger_type" varchar(255), "context" varchar(128), "created_at" datetime);
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255));
CREATE VIEW searches AS
      SELECT profiles.id AS profile_id, profiles.bio, profiles.firstname, profiles.lastname, profiles.languages, profiles.city, tags.name AS tag FROM profiles
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id 
      LEFT JOIN tags ON tags.id = taggings.tag_id;
CREATE UNIQUE INDEX "index_profiles_on_confirmation_token" ON "profiles" ("confirmation_token");
CREATE UNIQUE INDEX "index_profiles_on_email" ON "profiles" ("email");
CREATE UNIQUE INDEX "index_profiles_on_reset_password_token" ON "profiles" ("reset_password_token");
CREATE INDEX "index_taggings_on_tag_id" ON "taggings" ("tag_id");
CREATE INDEX "index_taggings_on_taggable_id_and_taggable_type_and_context" ON "taggings" ("taggable_id", "taggable_type", "context");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130211181848');

INSERT INTO schema_migrations (version) VALUES ('20130304192943');

INSERT INTO schema_migrations (version) VALUES ('20130304200508');

INSERT INTO schema_migrations (version) VALUES ('20130328122746');

INSERT INTO schema_migrations (version) VALUES ('20130406093746');

INSERT INTO schema_migrations (version) VALUES ('20130406112654');

INSERT INTO schema_migrations (version) VALUES ('20130407114403');

INSERT INTO schema_migrations (version) VALUES ('20130408192616');

INSERT INTO schema_migrations (version) VALUES ('20130408194211');

INSERT INTO schema_migrations (version) VALUES ('20130517204532');