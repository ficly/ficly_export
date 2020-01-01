class Page < ActiveRecord::Base

  def to_html
    r = RedCloth.new(self.body)
		return r.to_html
  end

end
