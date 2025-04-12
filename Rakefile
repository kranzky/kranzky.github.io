desc "Create today's post"
task :post do
  require 'date'
  require 'fileutils'
  name = File.join('_posts', Date.today.year.to_s, "%02d" % Date.today.month, Date.today.strftime + "-post.md")
  unless File.exist?(name)
    mkdir_p(File.dirname(name))
    content = "---\nlayout: post\n---\n\nTBD.\n"
    File.open(name, "w") { |file| file << content }
  end
  sh "vim #{name}"
  sh "git add #{name}"
end

desc "Eyeball the blog locally"
task :view do
  sh "jekyll serve --open-url"
end

desc "Publish everything"
task :publish do
  files = `git diff --name-only --cached`.split
  if files.count > 0
    count = Dir["_posts/**/*.md"].count
    sh "git commit -m #{count}"
    sh "git push"
  else
    puts "No staged posts."
  end
end

desc "Generate Markdown versions of all pages"
task :markdown do
  sh "bundle exec jekyll build && ruby html_to_markdown.rb"
end

task default: :view

task :help do
  sh "rake -T"
end
