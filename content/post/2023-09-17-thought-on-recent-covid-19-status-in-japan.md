---
title: "A perspective on recent COVID-19 status in Japan"
date: 2023-09-17T19:31:37+09:00
tags: ["non-software-engineering", "covid-19"]
toc: true
---

There have been a lot of events, information, and data since the beginning of COVID-19. But I haven't recorded almost any records on my perspective on COVID-19. I'd like to record at least the current status, especially how I'm checking the latest information and brief summary of the current status in Japan.

<!--more-->

## Available monitoring is very limited

Like the US, the Japanese government and most municipalities let themselves blind to the COVID-19 monitoring. Previously, most cases were reported from hospitals and data was published daily basis (unfortunately many data were in non-machine readable formats like PDF). That's not available anymore and only officially published data is limited sample hospital cases now like how the pre-COVID flu survey.

The recent re-surge is definitely not unexpected. I've never thought this is a reasonable scientific decision same as many doctors and researchers. Objectively, the risk of COVID-19 is much higher than flu. There has been some progress in research on the mechanism of long-COVID, but many parts are still unknown and there is no available treatment for long-COVID yet.

![moderna dashboard chart as of 2023-09-17](/post/2023-09-17-moderna-dashboard.png)
([chart public source](https://public.tableau.com/views/_16823360497460/sheet10?:language=ja-JP&:embed=y&:embed_code_version=3&:loadOrderID=6&:display_count=y&:origin=viz_share_link) via [新型コロナ・季節性インフルエンザ・RSウイルス リアルタイム流行・疫学情報](https://moderna-epi-report.jp/))

Recently, I've been relying on Moderna's case number estimation, which is only one of a few reliable data sources now but based on data gathered by a private company from many hospitals. Neither the original data nor what methodology they are estimating with are not publicly available. This kind of search could and should be done by a publicly funded project, then all data could be freely available for the public and researchers. But I don't know how many people know this dashboard, and it is widely used in Japan.

Variant surveillance has also been scaled down. [National Institute of Infectious Disease (NIID)](https://www.niid.go.jp/niid/ja/diseases/ka/corona-virus/covid-19.html) cannot provide the latest results frequently and doesn't conduct the testing in a wider area. Another option is more timely results published by [Bureau of Public Health, Tokyo Metropolitan Government](https://www.hokeniryo.metro.tokyo.lg.jp/kansen/corona_portal/henikabu/screening.html).

By the way, sadly, the NIID website still doesn't support a responsive style, making it hard or stressful to check the latest updates on mobile phones. The other website always puts data as images with an empty alt or machine-unreadable PDF format. No accessibility considered in the year when the not-so-strict [Disability Discrimination Elimination Act](https://www.japaneselawtranslation.go.jp/ja/laws/view/3052) was renewed lately. For Tokyo, that's unfortunate when thinking about widely successful opensource development of the [Tokyo COVID-19 stats dashboard]([Tokyo-Metro-Gov/covid19](https://github.com/Tokyo-Metro-Gov/covid19)) with Vue.js on GitHub.

There were clear information logistics issues across many organizations in the public sector in Japan since the pandemic started though. Many hospitals use FAX to send cases and diagnosis data to regional health authorities. Honestly, that's ridiculous. These few years were a very good opportunity to solve many problems with software technology.

It's also disappointing to abandon the most monitoring without solving the clear issues using good engineering. That's not impossible at all if any proper decision-making. There are good internet infrastructures here, good software engineers, and people would want to provide help, but I couldn't see not much required coordination has been done.

## New COVID-19 (yearly?) booster will be available timely

This is a good news. I have not been allowed to get a new booster since last October, so I was concerned that my immune system has been weaned down enough not to prevent long-COVID in case I got COVID-19 again.

Until the last booster, most COVID-19 vaccines were available in Japan a month or so after new shots were available in the US. I'm just describing that and not complaining here since there are many countries around the world not necessarily better than Japan.

However, unexpectedly, it seems that we can get the new XBB 1.5 updated vaccines timely almost the same as the US. [The city website](https://www.city.matsudo.chiba.jp/iryoutoshi/corona_vaccine/detail/r5kaisituikasessyu.html) wrote that the vaccine was not approved yet but would provide a new shot since 2023-09-20 and now [FDA approved it last week](https://www.npr.org/sections/health-shots/2023/09/11/1198719166/new-covid-vaccines-get-fda-approval). I guess this might be because a low vaccination rate in US, and they prioritized other nations similarly, but I don't know the actual process. As far as I know, information on how the vaccine supply is negotiated between the Japanese government and US pharmaceutical companies is not publicly available. I'm not satisfied with this anti-openness.

## People stop wearing mask

I don't understand how people are thinking about the situation. The SARS-CoV-2 is just a biological machine and just follows the rule of physics using its body's biological mechanism. They never react to political decisions or people's optimistic/blinded thoughts. This fact will never be changed until, for example, we give up our biological body...?

In Japan, ~90% of people were wearing masks both indoors and outdoors (but I didn't understand why too many people wanted to wear the masks in low-risk sparse open spaces) until the government (kind of) declared "COVID-19 is over" several months ago (though COVID-19 is not over at all). But many people (over 50%(?), still higher than in other countries) now stop wearing masks even in very crowded indoor spaces. I'm feared that the recent surges won't change those people's behavior anymore. Maybe many people just react to the atmosphere of other people or some news media and haven't acted based on scientific or factual data.

I'm not sure how much risk of long-COVID is acknowledged properly in Japan. Also, Japan almost never adopted the term "COVID-19" and still uses "new coronavirus infection" in many places against world standard and never use "long-COVID"... That's a bad thing for everyone since this kind of not-using correct terminology will decrease accessibility to correct latest information.

## Conclusion

I don't have any plan to change how to behave to protect myself from infection, which potentially disables me from working for several months. I got COVID-19 from a family member around the first rise of the Omicron variant, and it made me unable to get up for several hours for about a month even after two doses.

Also, I'd like to avoid any possibly deadly indirect infections for vulnerable others as possible.

I wish many areas can be improved by learning new better ways from the still continuing COVID-19 challenge.

## Information sources

I'm currently learning the latest updates about COVID-19 mainly from these resources:

- NPR's [Short Wave](https://www.npr.org/podcasts/510351/short-wave) and many other programs.
- Latest news and interviews from many scientists working on the latest research on [Science Friday](https://www.sciencefriday.com/).
- [Eric Topol](https://en.wikipedia.org/wiki/Eric_Topol)'s post about latest COVID-19 research papers.
