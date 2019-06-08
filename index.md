---
title: Deep Kranzky
---

{% for post in site.posts %}
  [{{ post.date | date: "%Y-%m-%d" }}]({{ post.url }})
  {{ post.content }}
{% endfor %}
