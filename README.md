Sample configuration file:

```
src: 
  url: https://example.highrisehq.com
  authToken: 841557ff...

dst: 
  url: http://example.org/redmine/
  project_id: 1
  tracker_id: 1
  priority_id: 4
  status_id: 1
  attachments_url: http://example.org/files/
  attachments_dir: ~/Documents/highrise_attachments/
  url_field: 1
  custom_fields:
    2: check once again
  assigned_to_id: 1 # assign created tickets to
  mapping:
    alice@example.org: 9228bc14... # Alice's auth token
    clara@example.org: 0339cd25... # Clara's auth token
  default_token: 8117ab03... # default auth token
```
