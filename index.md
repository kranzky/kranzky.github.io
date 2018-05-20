---
title: Diary of Kranzky
---

## test

{% for post in site.posts reversed %}
  [{{ post.title }}]({{ post.url }})
  {{ post.excerpt }}
{% endfor %}
