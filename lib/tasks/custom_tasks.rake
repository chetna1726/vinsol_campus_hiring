namespace :create do
  desc "Creates a default super admin"
  task super_admin: :environment do
    Admin.create(email: 'yukti@vinsol.com', super_admin: true)
  end

  desc "Creates default difficulty levels"
  task difficulty_levels: :environment do
    3.times do |index|
      DifficultyLevel.create(name: "Difficulty Level#{ index }")
    end
  end

  desc "Creates default categories"
  task categories: :environment do
    5.times do |index|
      Category.create(name: "Category#{ index }")
    end
    parent_categories = Category.root.ids
    10.times do |index|
      Category.create(name: "Category#{ index + 5 }", parent_id: parent_categories.sample)
    end
  end
end