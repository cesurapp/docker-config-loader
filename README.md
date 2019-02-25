# Docker Config Loader

Docker is designed for entrypoint. Creates key=value config store using environment variables. Environment variables are deleted after the config store is created.

## Example Application
Dockerfile:
```dockerfile
FROM centos:latest

...

# -----------------------------------------------------------------------------
# Run Config Loader
# -----------------------------------------------------------------------------
COPY ./loadConfig.sh /loadConfig.sh
RUN chmod +x /loadConfig.sh
ENTRYPOINT [ "/loadConfig.sh" ]

...
CMD ["php-fpm", "-F"]
```

Docker-compose:
```yaml
version: '3'

services:
    phpcentos:
        build: .
        environment:
            # PHP Dynamic Configuration
            - PHP_1=output_buffering:4096
            - PHP_2=display_errors:Off
            - PHP_3=max_execution_time:60
            - PHP_4=max_input_time:60
            - PHP_5=memory_limit:512M
            - PHP_6=post_max_size:500M
            - PHP_7=upload_max_filesize:25M
            - PHP_8=max_file_uploads:50
            - PHP_9=log_errors:On
            - PHP_10=error_log:"\/logs\/php_error.log"
            - PHP_11=opcache.enable:1
            - PHP_12=opcache.max_accelerated_files:75000
            # PHP-FPM Dynamic Configuration
            - FPM_1=user:apache
            - FPM_2=group:apache
            - FPM_3=listen:127.0.0.1:9000
            - FPM_4=pm:dynamic
            - FPM_5=pm.max_children:15
            - FPM_6=pm.start_servers:6
            - FPM_7=pm.min_spare_servers:2
            - FPM_8=pm.max_spare_servers:10
            - FPM_9=php_admin_value\[error_log\]:"\/logs\/php-fpm-error.log"

            # ... You can increase as much as you want.
```
loadConfig.sh:
```bash
#!/bin/bash

# Parameters
# $1 => Environment Prefix
# $2 => Config File Path
# $3 => Config Bracer = | : vs..
function loadConfig()
{
    ...  
}

# Load PHP Config
loadConfig PHP_ /etc/php.d/php.ini =
# Load PHP-FPM Config
loadConfig FPM_ /etc/php-fpm.d/www.conf =

exec "$@"
```
