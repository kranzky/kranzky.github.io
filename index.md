---
title: Diary of Kranzky
---

{% for post in site.posts %}
  ## [{{ post.date }}a]({{ post.url}})
  {{ post.excerpt }}
{% endfor %}
