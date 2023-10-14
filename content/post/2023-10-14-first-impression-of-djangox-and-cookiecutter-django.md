---
title: "First impression of DjangoX and Cookiecutter Django"
date: 2023-10-14T12:04:35Z
tags: ["django"]
toc: true
---

I searched Django nice project templates I can use to make a simple personal project. There are two Django project templates I'm interested in: Cookiecutter Django and DjangoX. This is my first impression of those project templates.

<!--more-->

## Cookiecutter Django

[Cookiecutter](https://cookiecutter.readthedocs.io/en/stable/) is a popular tool that can generate project structure generated from a pre-configured project template in Python ecosystem.

The [Cookiecutter Django](https://github.com/cookiecutter/cookiecutter-django) is one of such project template. It has a long history, so there are a lot of options and setting up features requires users to select multiple initialization options asked by cookiecutter.

It might be overwhelming users at first, but it would be nice start for the larger projects.

## DjangoX

The [DjangoX](https://github.com/wsvincent/djangox) has a nice default configurations such as the default email username usage, django-debug-toolbar integration, popular Bootstrap v5 integration etc.

It looks like a simple and minimum set up, but all of pre-configured features are nice-to-have features for many Django project. So most people would set up similar configurations from the base Django project created the built-in `python -m manage createproject` command.

I think it's a good start for any kind of projects and I may use this for the new small personal project.

## References

- [Cookiecutter: Better Project Templates — cookiecutter 2.4.0 documentation](https://cookiecutter.readthedocs.io/en/stable/)
- [cookiecutter/cookiecutter-django: Cookiecutter Django is a framework for jumpstarting production-ready Django projects quickly.](https://github.com/cookiecutter/cookiecutter-django)
- [wsvincent/djangox: Django starter project with 🔋](https://github.com/wsvincent/djangox) 
