Heroku-Logplex
========

Heroku-Logplex lets you monitor your heroku dynos and databases using its log drain service.

It does this through a very thin setup of rack + redis.

You can read more about Heroku's log drain service and how to set it up here:

https://devcenter.heroku.com/articles/log-drains


How to Use
----------

- Set up a new dyno for Heroku-Logplex.
- Set up a new redis server for Heroku-Logplex. Heroku provides a free tier that is more than suitable.
- You will be using HTTPS drains, so you will need to set up username and password. The username and password for Heroku-Logplex should be set in the config.ru file.
- Set up the log drain service using your new dyno address, as well as the username and password. You will recieve a logplex drain token. Set the drain token as an environment variable (LOGPLEX_DRAIN_TOKEN) on your new dyno.
- Configure which services you want to monitor via conifg/application.yml

How it works
------------

Heroku's log drain will send its data via POST requests to Heroku-Logplex. Heroku-Logplex will then parse this data and feed it to redis with an expiry. If Heroku-Logplex doesn't recieve a logplex message for a certain service, the assumption is made that something is wrong.