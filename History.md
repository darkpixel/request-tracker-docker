
v1.0.1 / 2021-10-07
==================

  * Fix bad fetchmail permissions

v1.0.0 / 2021-10-07
==================

  * Allow launching commands after running envsubst
  * Stop runing cronjobs and fetchmail through entrypoint, use k8s CronJob definitions with new --cmd option

v0.9.5 / 2021-08-19
==================

  * Pin to request-tracker-docker-base v0.9.5

v0.9.3 / 2021-08-19
==================

  * Update to RT5
  * Remove a bunch of legacy plugins
  * Enable MergeUsers
  * Add WEB_URL env var

v0.9.2 / 2019-09-09
==================

  * Include DATABASE_HOST in envsubst

v0.9.1 / 2019-09-09
==================

  * Fix database name environment variable

v0.9.0 / 2019-09-09
==================

  * Run c_rehash on certs

v0.8.9 / 2019-09-09
==================

  * Update request tracker from 4.4.2 to 4.4.4
  * Update to new reuqest-tracker-docker-base that includes LDAP
