task :code_analysis do
  sh 'bundle exec rubocop config lib spec'
  sh 'bundle exec reek config lib'
end
