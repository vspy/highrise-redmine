Sample configuration file:

```
src: 
  url: https://example.highrisehq.com
  authToken: 841557ff...

dst: 
  url: http://example.org/redmine/
  authToken: 9228bc14...
  project_id: 1
  tracker_id: 1
  priority_id: 4
  status_id: 1
  attachments_url: http://example.org/files/
  attachments_dir: ~/Documents/highrise_attachments/
  url_field: 1
  custom_fields:
    2: check once again
  mapping:
    alice@example.org: 2 # bob
    clara@example.org: 3 # dave
  default_mapping: 1 # admin
```
