---
title: Diary of Kranzky
---

{% for post in site.posts reversed %}
  [{{ post.date | date "%Y-%m-%d" }}]({{ post.url }})
  {{ post.content }}
{% endfor %}
