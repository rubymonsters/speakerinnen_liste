--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_tokens (
    id integer NOT NULL,
    name character varying(255),
    token character varying(255)
);


--
-- Name: api_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_tokens_id_seq OWNED BY api_tokens.id;


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blog_posts (
    id integer NOT NULL,
    title character varying(255),
    body text,
    url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blog_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blog_posts_id_seq OWNED BY blog_posts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories_tags (
    id integer NOT NULL,
    category_id integer,
    tag_id integer
);


--
-- Name: categories_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_tags_id_seq OWNED BY categories_tags.id;


--
-- Name: category_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category_translations (
    id integer NOT NULL,
    category_id integer NOT NULL,
    locale character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255)
);


--
-- Name: category_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE category_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE category_translations_id_seq OWNED BY category_translations.id;


--
-- Name: medialinks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medialinks (
    id integer NOT NULL,
    profile_id integer,
    url text,
    title text,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer
);


--
-- Name: medialinks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medialinks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medialinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medialinks_id_seq OWNED BY medialinks.id;


--
-- Name: profile_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_translations (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    locale character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    main_topic character varying(255),
    bio text
);


--
-- Name: profile_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_translations_id_seq OWNED BY profile_translations.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    email character varying(255),
    languages character varying(255),
    city character varying(255),
    twitter character varying(255),
    picture character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    talks character varying(255),
    admin boolean DEFAULT false,
    provider character varying(255),
    uid character varying(255),
    media_url character varying(255),
    published boolean DEFAULT false,
    website character varying(255),
    admin_comment text
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE searches (
    profile_id integer,
    search_field text
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_tokens ALTER COLUMN id SET DEFAULT nextval('api_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blog_posts ALTER COLUMN id SET DEFAULT nextval('blog_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories_tags ALTER COLUMN id SET DEFAULT nextval('categories_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_translations ALTER COLUMN id SET DEFAULT nextval('category_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medialinks ALTER COLUMN id SET DEFAULT nextval('medialinks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profile_translations ALTER COLUMN id SET DEFAULT nextval('profile_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: api_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);


--
-- Name: blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories_tags
    ADD CONSTRAINT categories_tags_pkey PRIMARY KEY (id);


--
-- Name: category_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category_translations
    ADD CONSTRAINT category_translations_pkey PRIMARY KEY (id);


--
-- Name: medialinks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medialinks
    ADD CONSTRAINT medialinks_pkey PRIMARY KEY (id);


--
-- Name: profile_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_translations
    ADD CONSTRAINT profile_translations_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: index_categories_tags_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_tags_on_category_id ON categories_tags USING btree (category_id);


--
-- Name: index_categories_tags_on_category_id_and_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_tags_on_category_id_and_tag_id ON categories_tags USING btree (category_id, tag_id);


--
-- Name: index_categories_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_tags_on_tag_id ON categories_tags USING btree (tag_id);


--
-- Name: index_category_translations_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_translations_on_category_id ON category_translations USING btree (category_id);


--
-- Name: index_category_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_translations_on_locale ON category_translations USING btree (locale);


--
-- Name: index_medialinks_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_medialinks_on_profile_id ON medialinks USING btree (profile_id);


--
-- Name: index_profile_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_translations_on_locale ON profile_translations USING btree (locale);


--
-- Name: index_profile_translations_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_translations_on_profile_id ON profile_translations USING btree (profile_id);


--
-- Name: index_profiles_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_profiles_on_confirmation_token ON profiles USING btree (confirmation_token);


--
-- Name: index_profiles_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_profiles_on_email ON profiles USING btree (email);


--
-- Name: index_profiles_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_profiles_on_reset_password_token ON profiles USING btree (reset_password_token);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE RULE "_RETURN" AS
    ON SELECT TO searches DO INSTEAD  SELECT profiles.id AS profile_id,
    array_to_string(ARRAY[profiles.firstname, profiles.lastname, profiles.languages, profiles.city, (string_agg(DISTINCT medialinks.title, ' '::text))::character varying, (string_agg(DISTINCT medialinks.description, ' '::text))::character varying, (string_agg(DISTINCT profile_translations.bio, ' '::text))::character varying, (string_agg(DISTINCT (profile_translations.main_topic)::text, ' '::text))::character varying, (string_agg(DISTINCT (tags.name)::text, ' '::text))::character varying], ' '::text) AS search_field
   FROM ((((profiles
     LEFT JOIN medialinks ON ((medialinks.profile_id = profiles.id)))
     LEFT JOIN profile_translations ON ((profile_translations.profile_id = profiles.id)))
     LEFT JOIN taggings ON ((taggings.taggable_id = profiles.id)))
     LEFT JOIN tags ON ((tags.id = taggings.tag_id)))
  WHERE (profiles.published = true)
  GROUP BY profiles.id;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20130525141752');

INSERT INTO schema_migrations (version) VALUES ('20130826181457');

INSERT INTO schema_migrations (version) VALUES ('20140120190118');

INSERT INTO schema_migrations (version) VALUES ('20140127194625');

INSERT INTO schema_migrations (version) VALUES ('20140217201851');

INSERT INTO schema_migrations (version) VALUES ('20140313204403');

INSERT INTO schema_migrations (version) VALUES ('20140316183319');

INSERT INTO schema_migrations (version) VALUES ('20140317175539');

INSERT INTO schema_migrations (version) VALUES ('20140317201619');

INSERT INTO schema_migrations (version) VALUES ('20140317202150');

INSERT INTO schema_migrations (version) VALUES ('20140323075148');

INSERT INTO schema_migrations (version) VALUES ('20140323150343');

INSERT INTO schema_migrations (version) VALUES ('20140330183449');

INSERT INTO schema_migrations (version) VALUES ('20140330185248');

INSERT INTO schema_migrations (version) VALUES ('20140505155338');

INSERT INTO schema_migrations (version) VALUES ('20140506200134');

INSERT INTO schema_migrations (version) VALUES ('20140602180400');

INSERT INTO schema_migrations (version) VALUES ('20140901194313');

INSERT INTO schema_migrations (version) VALUES ('20140901194314');

INSERT INTO schema_migrations (version) VALUES ('20140901194315');

INSERT INTO schema_migrations (version) VALUES ('20150131194544');

INSERT INTO schema_migrations (version) VALUES ('20150715095533');

INSERT INTO schema_migrations (version) VALUES ('20151216091821');

