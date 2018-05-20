---
title: Diary of Kranzky
---

{% for post in site.posts reversed %}
  [{{ post.title }}]({{ post.url }})
  {{ post.excerpt }}
{% endfor %}
