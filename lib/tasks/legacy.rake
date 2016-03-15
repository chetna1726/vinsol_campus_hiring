require 'bcrypt'
namespace :legacy do
  multi_answer_questions = []

  ##################################
  #
  # All migrations
  #
  ##################################
  desc 'Run all migrations'
  task :all => [:difficulty_levels, :admins, :categories, :questions, :options, :taggings, :tags, :answers]

  desc 'Create Legacy Difficulty Levels'
  task :difficulty_levels => :environment do
    LEGACY_LEVELS.each do |leg_level|
      DifficultyLevel.create(name: leg_level)
    end
  end

  desc 'Migrate Admins'
  task :admins => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Admins"
    LegacyAdmin.find_each do |leg_admin|
      begin
        new_admin = Admin.new
        new_admin.attributes = {
          name: leg_admin.name,
          email: leg_admin.email
        }
        new_admin.id = leg_admin.id
        new_admin.save!
      rescue Exception => e
        puts "Error migrating #{leg_admin.id} order: #{e}"
      end
    end
    id_incremented = LegacyAdmin.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Admin.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrate Categories'
  task :categories => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Categories"
    LegacyCategory.find_each do |leg_category|
      begin
        new_category = Category.new
        new_category.attributes = {
          name: leg_category.name
        }
        new_category.id = leg_category.id
        new_category.save!
      rescue Exception => e
        puts "Error migrating #{leg_category.id} order: #{e}"
      end
    end
    sub_categories = LegacyCategory.all.ids
    c = Category.find_or_create_by(name: 'Others')
    c.sub_category_ids = sub_categories
    id_incremented = LegacyCategory.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Category.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrate Questions'
  task :questions => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Questions"
    LegacyQuestion.find_each do |leg_question|
      if leg_question.ques_type == 'Subjective' || leg_question.ques_type == 'Multiple Choice'
        ques_type = leg_question.ques_type
        if leg_question.ques_type == 'Multiple Choice'
          ques_type = 'MCQ'
        end
        begin
          new_question = Question.new
          new_question.attributes = {
            content:  CGI::escapeHTML(leg_question.body),
            difficulty_level_id: (leg_question.level + 1),
            category_id: leg_question.category_id,
            admin_id: leg_question.admin_id,
            type: ques_type,
            status: 'active'
          }
          new_question.id = leg_question.id
          new_question.save!
        rescue Exception => e
          puts "Error migrating #{leg_question.id} order: #{e}"
        end
      else
        multi_answer_questions << leg_question.id
      end
    end
    id_incremented = LegacyQuestion.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Question.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrate Tags'
  task :tags => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Tags"
    LegacyTag.find_each do |leg_tag|
      begin
        new_tag = Tag.new
        new_tag.attributes = leg_tag.attributes
        new_tag.save!
      rescue Exception => e
        puts "Error migrating #{leg_tag.id} order: #{e}"
      end
    end
    id_incremented = LegacyTag.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Tag.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrate Taggings'
  task :taggings => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Taggings"
    LegacyTagging.find_each do |leg_tagging|
      begin
        new_tagging = Tagging.new
        new_tagging.attributes = leg_tagging.attributes
        new_tagging.save!
      rescue Exception => e
        puts "Error migrating #{leg_tagging.id} order: #{e}"
      end
    end
    id_incremented = LegacyTagging.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Tagging.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrate Options'
  task :options => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Options"
    LegacyOption.find_each do |leg_option|
      unless multi_answer_questions.include?(leg_option.question_id)
        begin
          new_option = Option.new
          new_option.attributes =  {
            question_id: leg_option.question_id,
            value: CGI::escapeHTML(leg_option.body)
          }
          new_option.id = leg_option.id
          new_option.save!
        rescue Exception => e
          puts "Error migrating #{leg_option.id} order: #{e}"
        end
      end
    end
    id_incremented = LegacyOption.order("id DESC").first.id + DATABASE_ID_DIFFERENCE
    ActiveRecord::Base.connection.execute("ALTER TABLE #{Option.table_name} AUTO_INCREMENT = #{id_incremented}")
    puts "Time: #{Time.current}"
  end

  desc 'Migrating Answers'
  task :answers => :environment do
    puts "Time: #{Time.current}"
    puts "Migrating Answers"
    LegacyAnswer.find_each do |leg_answer|
      begin
        question = Question.find_by(id: leg_answer.question_id)
        if question
          if (question.type == 'Subjective')
            new_option = Option.new
            new_option.attributes =  {
              question_id: leg_answer.question_id,
              value: CGI::escapeHTML(leg_answer.body),
              answer: true
            }
            new_option.save!
          else
            option = Option.find_by(question_id: leg_answer.question_id, value: CGI::escapeHTML(leg_answer.body))
            if option
              option.answer = true
              option.save!
            end
          end
        end
      rescue Exception => e
        puts "Error migrating #{leg_answer.id} order: #{e}"
      end
    end
    puts "Time: #{Time.current}"
  end
end