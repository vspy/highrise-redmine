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
  mapping:
    alice: 2 # bob
    clara: 3 # dave
  default_mapping: 1 # admin
```
