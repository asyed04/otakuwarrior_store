namespace :rubocop do
  desc 'Run RuboCop on the app directory'
  task app: :environment do
    sh 'rubocop app --format progress'
  end

  desc 'Run RuboCop on the lib directory'
  task lib: :environment do
    sh 'rubocop lib --format progress'
  end

  desc 'Run RuboCop on the test directory'
  task test: :environment do
    sh 'rubocop test --format progress'
  end

  desc 'Run RuboCop on the app, lib, and test directories'
  task all: %i[app lib test]

  desc 'Run auto-correct on all directories'
  task autocorrect: :environment do
    sh 'rubocop -A --format progress'
  end

  desc 'Show only offense counts by cop'
  task stats: :environment do
    sh 'rubocop --format offenses'
  end

  desc 'Run with only a specific cop enabled'
  task :only, [:cop] => :environment do |_t, args|
    cop = args[:cop] || 'Style/StringLiterals'
    sh "rubocop --only #{cop}"
  end

  desc 'Generate a todo file to temporarily disable all current offenses'
  task todo: :environment do
    sh 'rubocop --auto-gen-config'
  end
end

desc 'Run RuboCop on the app, lib, and test directories'
task rubocop: ['rubocop:all']
