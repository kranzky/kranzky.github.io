#!/usr/bin/env ruby

require 'nokogiri'
require 'reverse_markdown'
require 'fileutils'

puts "Converting HTML files to Markdown..."

site_dir = File.join(Dir.pwd, '_site')

# Process all HTML files in the _site directory
Dir.glob(File.join(site_dir, "**", "*.html")).each do |html_file|
  # Create corresponding markdown filename
  md_file = html_file.sub(/\.html$/, '.md')
  
  puts "Processing: #{html_file}"
  
  # Read HTML content
  html_content = File.read(html_file)
  
  # Parse with Nokogiri
  doc = Nokogiri::HTML(html_content)
  
  # Extract the main content
  # Look for common content containers
  main_content = doc.at('#main_content') || 
                doc.at('main') || 
                doc.at('article') || 
                doc.at('.content') ||
                doc.at('.post-content')
  
  if main_content
    # Convert to Markdown with better options
    markdown = ReverseMarkdown.convert(main_content.to_html, 
                                      github_flavored: true,
                                      unknown_tags: :bypass,
                                      block_tags: [:div, :p, :header, :section],
                                      inline_tags: [:span, :a, :code, :em, :strong],
                                      preserve_comments: false)
    
    # Clean up the markdown
    markdown = markdown.gsub(/\n{3,}/, "\n\n")         # Remove excessive newlines
                      .gsub(/<\/?div[^>]*>/, '')      # Remove div tags
                      .gsub(/<\/?span[^>]*>/, '')     # Remove span tags
                      .gsub(/<\/?section[^>]*>/, '')  # Remove section tags
                      .gsub(/<header>.*?<\/header>/m, '') # Remove header tags and content
                      .gsub(/<\/?[a-z][^>]*>/i, '')   # Remove any remaining HTML tags
                      .gsub(/\n\s*\n\s*\n/, "\n\n")   # Normalize multiple newlines
    
    # Add front matter if the HTML contains it
    front_matter = ""
    if html_content =~ /---(.+?)---/m
      front_matter = "---\n#{$1}---\n\n"
    end
    
    # Write Markdown file
    File.write(md_file, front_matter + markdown.strip)
    puts "Created: #{md_file}"
    
    # Remove the HTML file
    File.delete(html_file)
    puts "Removed: #{html_file}"
  else
    # If no main content container was found, try converting the body
    body = doc.at('body')
    if body
      # Try to extract the content part from body, excluding headers and footers
      content_html = body.to_html
      
      # Convert to Markdown
      markdown = ReverseMarkdown.convert(content_html, 
                                        github_flavored: true,
                                        unknown_tags: :bypass,
                                        block_tags: [:div, :p, :header, :section],
                                        inline_tags: [:span, :a, :code, :em, :strong],
                                        preserve_comments: false)
      
      # Clean up the markdown
      markdown = markdown.gsub(/\n{3,}/, "\n\n")         # Remove excessive newlines
                        .gsub(/<\/?div[^>]*>/, '')      # Remove div tags
                        .gsub(/<\/?span[^>]*>/, '')     # Remove span tags
                        .gsub(/<\/?section[^>]*>/, '')  # Remove section tags
                        .gsub(/<header>.*?<\/header>/m, '') # Remove header tags and content
                        .gsub(/<\/?[a-z][^>]*>/i, '')   # Remove any remaining HTML tags
                        .gsub(/\n\s*\n\s*\n/, "\n\n")   # Normalize multiple newlines
      
      # Write Markdown file
      File.write(md_file, markdown.strip)
      puts "Created: #{md_file} (from body)"
      
      # Remove the HTML file
      File.delete(html_file)
      puts "Removed: #{html_file}"
    else
      puts "Skipping: #{html_file} - no content found"
    end
  end
end

# Remove CSS files
puts "\nRemoving CSS files..."
Dir.glob(File.join(site_dir, "**", "*.css")).each do |css_file|
  File.delete(css_file)
  puts "Removed: #{css_file}"
end

# Remove other HTML files that might be left (like error pages)
puts "\nRemoving any remaining HTML files..."
Dir.glob(File.join(site_dir, "**", "*.html")).each do |html_file|
  File.delete(html_file)
  puts "Removed: #{html_file}"
end

# Clean up empty directories
puts "\nRemoving empty directories..."
# Function to recursively remove empty directories
def remove_empty_dirs(dir)
  return unless File.directory?(dir)
  
  Dir.children(dir).each do |child|
    child_path = File.join(dir, child)
    remove_empty_dirs(child_path) if File.directory?(child_path)
  end
  
  if Dir.empty?(dir)
    Dir.rmdir(dir)
    puts "Removed empty directory: #{dir}"
  end
end

remove_empty_dirs(site_dir)

puts "\nConversion complete! All HTML and CSS files have been removed."