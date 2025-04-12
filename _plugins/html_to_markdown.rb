# A simple Jekyll plugin to convert HTML files to Markdown
# This plugin runs as a post-build processor

Jekyll::Hooks.register :site, :post_write do |site|
  require 'nokogiri' rescue nil
  require 'reverse_markdown' rescue nil
  
  if !defined?(Nokogiri) || !defined?(ReverseMarkdown)
    Jekyll.logger.warn "HTML to Markdown:", "Required gems 'nokogiri' and 'reverse_markdown' not found."
    Jekyll.logger.warn "", "Please run 'bundle install' to install missing dependencies."
    return
  end
  
  Jekyll.logger.info "HTML to Markdown:", "Converting HTML files to Markdown..."
  
  # Process all HTML files in the _site directory
  Dir.glob(File.join(site.dest, "**", "*.html")).each do |html_file|
    # Create corresponding markdown filename
    md_file = html_file.sub(/\.html$/, '.md')
    
    # Read HTML content
    html_content = File.read(html_file)
    
    # Parse with Nokogiri
    doc = Nokogiri::HTML(html_content)
    
    # Extract the body content
    body_content = doc.at('body')
    
    if body_content
      # Convert to Markdown
      markdown = ReverseMarkdown.convert(body_content.inner_html, github_flavored: true)
      
      # Write Markdown file
      File.write(md_file, markdown)
      Jekyll.logger.info "", "Created #{md_file.sub(site.dest + '/', '')}"
    end
  end
end