class String
  # helper for correctly possessifying a string
  def possessify
    if self.last == "s"
      return self + "'"
    else
      return self + "'s"
    end
  end
end