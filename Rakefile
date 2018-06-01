desc "Create today's post"
task :post do
  require 'date'
  name = File.join('_posts', Date.today.strftime + "-post.md")
  unless File.exist?(name)
    content = "---\nlayout: post\n---\n\nTBD.\n"
    File.open(name, "w") { |file| file << content }
  end
  sh "vim #{name}"
  sh "git add #{name}"
end

desc "Eyeball the blog locally"
task :test do
  sh "jekyll serve --open-url"
end

desc "Publish everything"
task :push do
  files = `git diff --name-only --cached`.split
  if files.count > 0
    count = Dir["_posts/*.md"].count
    sh "git commit -m #{count}"
    sh "git push"
  else
    puts "No staged posts."
  end
end

task default: :test

task :help do
  sh "rake -T"
end
