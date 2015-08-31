class Chist < Sequel::Model
  many_to_one :user
  unrestrict_primary_key

  def before_create
    self.id ||= SecureRandom.hex
    super
  end

  def id
    if values[:id]
      super.gsub("-", "")
    else
      super
    end
  end

  def destroy_cascade
    self.class.db["DELETE FROM user_favorites WHERE user_id = ? AND chist_id = ?", self.user_id, self.id].all
    self.destroy
  end
end
