class UserFavourites
  def initialize(user)
    @user = user
  end

  def add(entry)
    unless favourited?(entry)
      @user.favourites.create(entry: entry)
    end
  end

  def remove(entry)
    @user.favourites.where(entry_id: entry.id, entry_type: entry.class.name).delete_all
  end

  private

  def favourited?(entry)
    @user.favourites.exists?(entry_id: entry.id, entry_type: entry.class.name)
  end
end
