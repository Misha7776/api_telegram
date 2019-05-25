class ContentService
  def fetch
    object_array = []
    10.times do
      object_array << { first_name: fake_first_name, last_name: fake_last_name, username: fake_username }
    end
    object_array
  end

  private

  def fake_first_name
    Faker::Name.first_name
  end

  def fake_last_name
    Faker::Name.last_name
  end

  def fake_username
    Faker::Internet.user_name
  end
end
