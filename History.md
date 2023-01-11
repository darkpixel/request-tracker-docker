
v2.0.4 / 2023-01-11
==================

  * Add a basic README file to help people get started

v2.0.3 / 2023-01-11
==================

  * Update to RT 5.0.3
  * Do not suppress inline text files

v2.0.2 / 2022-07-14
==================

  * Add ShowTransactionSquelching, ActivityReports, RepliesToResolved
  * Adjust QuickCall names
  * Add vendor quick call
  * Add ticket locking
  * Updated request-tracker-docker-base

v2.0.1 / 2021-11-16
==================

  * Automatically add CCs to ticket
  * Add an option to start in RTIR mode

v2.0.0 / 2021-10-28
==================

  * Support for running container securely as rtuser (ID 1000)
  * Bind to unprivileged port
  * Touch msmtprc and fetchmailrc so rtuser can write them

v1.0.2 / 2021-10-08
==================

  * Add --fetchmail arg for proper handling of exit code 1

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
