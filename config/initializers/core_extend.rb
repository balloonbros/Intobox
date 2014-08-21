class Integer
  #
  # ファイルサイズ表現に変換します
  #
  def to_size
    if self < 1024
      "#{self}B"
    elsif self < 1024**2
      "#{self / 1024}KB"
    elsif self < 1024**3
      "#{self / 1024**2}MB"
    end
  end
end
