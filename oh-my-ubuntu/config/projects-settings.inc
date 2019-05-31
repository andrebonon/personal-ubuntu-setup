<?php
/**
 * @file
 * Local development overrides for settings.php
 */

// Database configurations.
$databases['default']['default'] = array(
  'host' => 'localhost',
  'username' => 'root',
  'password' => 'root',
  'driver' => 'mysql',
  'database' => 'projects',
);

// Cache settings.
$conf['cache'] = 0;
$conf['preprocess_js'] = 0;
$conf['preprocess_css'] = 0;

// Less development settings.
$conf['less_devel'] = 1;
$conf['less_source_maps'] = 1;

// Other Drupal settings.
$conf['file_temporary_path'] = '/tmp';
$conf['cron_safe_threshold'] = 0;
