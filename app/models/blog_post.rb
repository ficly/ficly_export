require 'will_paginate'
class BlogPost < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :basename

  belongs_to :user
  belongs_to :blog_category
  has_many :comments,
    :as => :resource

  # index :blog_category_id
  # index :user_id

  def create_basename
    # Autor: Martin Labuschin
    # Erstellt am 27. März 2008
    # Es werden alle Sonderzeichen aus dem String entfernt. Umlaute werden in AE, OE und UE etc., das ß in SS umgewandet. Alle Buchstaben werden in Minuskeln umgewandelt und alle Leerräume werden mit Minuszeichen gefüllt. Ein doppeltes Vorkommen, das Beginnen oder Beenden mit einem Minuszeichen wird verhindert.
    # BEMERKUNG: Es wird nur Plaintext erwartet
    callname = title.dup
    callname.gsub!(/[Ää]+/i,'ae')
    callname.gsub!(/[Üü]+/i,'ue')
    callname.gsub!(/[Öö]+/i,'oe')
    callname.gsub!(/[ß]+/i,'ss')
    callname.downcase!
    callname.gsub!(/[^a-z0-9]+/i, '-')
    callname.gsub!(/(^[-]+|[-]+$)/, '')
    self.basename = callname
  end

	def last_comment
		@last_comment ||= self.comments.find(:first, :order => "created_at desc")
	end

	def to_html
		r = RedCloth.new("#{body} \n #{extended_body}")
		r.to_html
	end

  def hugo_json
    out = {
      title: self.title,
      slug: self.basename,
      date: self.created_at,
      description: "a blog post",
      tags: [],
      comments: [],
      user: User.for_association(self.user),
      taxonomies: ["posts"],
      type: "post"
    }

    unless self.cached_tag_list.blank?
      out[:tags] = Tag.clean_tags(self.cached_tag_list)
    end

    self.comments.find_each do |c|
      out[:comments] << c.for_association
    end

    out
  end

  def hugo_export
    json = JSON.pretty_generate(self.hugo_json)
    body = PandocRuby.convert(self.body, from: :textile, to: :markdown)
    rest_of_body = ""
    unless self.extended_body.blank?
      rest_of_body = PandocRuby.convert(self.extended_body, from: :textile, to: :markdown)
    end

<<-eos
#{json}

#{body}
#{rest_of_body}
eos
  end

  def self.hugo_export
    post_dir = "#{Rails.root}/tmp/hugo/post"
    FileUtils.mkdir_p(post_dir)

    BlogPost.find_each do |p|
      puts "Writing: #{p.id}"
      FileUtils.mkdir_p("#{post_dir}/#{p.basename}")
      f = File.open("#{post_dir}/#{p.basename}/index.md","w+")
      f.puts p.hugo_export
      f.close
    end
  end

  protected

    def before_create
      if self.basename.blank?
        self.create_basename
      end
    end

    def before_validation
      if self.basename_changed? && !self.new_record?
        if self.basename.nil?
          self.basename = BlogPost.create_basename(self.title)
        else
          self.basename = BlogPost.create_basename(self.basename)
        end
      end
    end

end
