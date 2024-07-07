{{- define "config.yml" -}}
# This is an example of a configuration file "config.xml" rewritten in YAML
# You can read this documentation for detailed information about YAML configuration:
# https://clickhouse.com/docs/en/operations/configuration-files/

# NOTE: User and query level settings are set up in "users.yaml" file.
# If you have accidentally specified user-level settings here, server won't start.
# You can either move the settings to the right place inside "users.xml" file
# or add skip_check_for_incorrect_settings: 1 here.
logger:
    # Possible levels [1]:
    # - none (turns off logging)
    # - fatal
    # - critical
    # - error
    # - warning
    # - notice
    # - information
    # - debug
    # - trace
    # [1]: https://github.com/pocoproject/poco/blob/poco-1.9.4-release/Foundation/include/Poco/Logger.h#L105-L114
    level: debug
    # log: /var/log/clickhouse-server/clickhouse-server.log
    # errorlog: /var/log/clickhouse-server/clickhouse-server.err.log
    # Rotation policy
    # See https://github.com/pocoproject/poco/blob/poco-1.9.4-release/Foundation/include/Poco/FileChannel.h#L54-L85
    # size: 1000M
    # count: 10
    console: 1
    # Default behavior is autodetection (log to console if not daemon mode and is tty)

    # Per level overrides (legacy):
    # For example to suppress logging of the ConfigReloader you can use:
    # NOTE: levels.logger is reserved, see below.
    # levels:
    #     ConfigReloader: none

    # Per level overrides:
    # For example to suppress logging of the RBAC for default user you can use:
    # (But please note that the logger name maybe changed from version to version, even after minor upgrade)
    # levels:
    #     - logger:
    #         name: 'ContextAccess (default)'
    #         level: none
    #     - logger:
    #         name: 'DatabaseOrdinary (test)'
    #         level: none

# It is the name that will be shown in the clickhouse-client.
# By default, anything with "production" will be highlighted in red in query prompt.
# display_name: production

# Port for HTTP API. See also 'https_port' for secure connections.
# This interface is also used by ODBC and JDBC drivers (DataGrip, Dbeaver, ...)
# and by most of web interfaces (embedded UI, Grafana, Redash, ...).
http_port: 8123

# Port for interaction by native protocol with:
# - clickhouse-client and other native ClickHouse tools (clickhouse-benchmark);
# - clickhouse-server with other clickhouse-servers for distributed query processing;
# - ClickHouse drivers and applications supporting native protocol
# (this protocol is also informally called as "the TCP protocol");
# See also 'tcp_port_secure' for secure connections.
tcp_port: 9000

# Compatibility with MySQL protocol.
# ClickHouse will pretend to be MySQL for applications connecting to this port.
# mysql_port: 9004

# Compatibility with PostgreSQL protocol.
# ClickHouse will pretend to be PostgreSQL for applications connecting to this port.
# postgresql_port: 9005

# HTTP API with TLS (HTTPS).
# You have to configure certificate to enable this interface.
# See the openSSL section below.
# https_port: 8443

# Native interface with TLS.
# You have to configure certificate to enable this interface.
# See the openSSL section below.
# tcp_port_secure: 9440

# Native interface wrapped with PROXYv1 protocol
# PROXYv1 header sent for every connection.
# ClickHouse will extract information about proxy-forwarded client address from the header.
# tcp_with_proxy_port: 9011

# Port for communication between replicas. Used for data exchange.
# It provides low-level data access between servers.
# This port should not be accessible from untrusted networks.
# See also 'interserver_http_credentials'.
# Data transferred over connections to this port should not go through untrusted networks.
# See also 'interserver_https_port'.
interserver_http_port: 9009

# Port for communication between replicas with TLS.
# You have to configure certificate to enable this interface.
# See the openSSL section below.
# See also 'interserver_http_credentials'.
# interserver_https_port: 9010

# Hostname that is used by other replicas to request this server.
# If not specified, than it is determined analogous to 'hostname -f' command.
# This setting could be used to switch replication to another network interface
# (the server may be connected to multiple networks via multiple addresses)
# interserver_http_host: example.clickhouse.com

# You can specify credentials for authenthication between replicas.
# This is required when interserver_https_port is accessible from untrusted networks,
# and also recommended to avoid SSRF attacks from possibly compromised services in your network.
# interserver_http_credentials:
#     user: interserver
#     password: ''

# Listen specified address.
# Use :: (wildcard IPv6 address), if you want to accept connections both with IPv4 and IPv6 from everywhere.
# Notes:
# If you open connections from wildcard address, make sure that at least one of the following measures applied:
# - server is protected by firewall and not accessible from untrusted networks;
# - all users are restricted to subset of network addresses (see users.xml);
# - all users have strong passwords, only secure (TLS) interfaces are accessible, or connections are only made via TLS interfaces.
# - users without password have readonly access.
# See also: https://www.shodan.io/search?query=clickhouse
# listen_host: '::'

# Same for hosts without support for IPv6:
# listen_host: 0.0.0.0

# Default values - try listen localhost on IPv4 and IPv6.
# listen_host: '::1'
# listen_host: 127.0.0.1

# Don't exit if IPv6 or IPv4 networks are unavailable while trying to listen.
# listen_try: 0

# Allow multiple servers to listen on the same address:port. This is not recommended.
# listen_reuse_port: 0

# listen_backlog: 64
max_connections: 4096

# For 'Connection: keep-alive' in HTTP 1.1
keep_alive_timeout: 3

# gRPC protocol (see src/Server/grpc_protos/clickhouse_grpc.proto for the API)
# grpc_port: 9100
grpc:
    enable_ssl: false

    # The following two files are used only if enable_ssl=1
    ssl_cert_file: /path/to/ssl_cert_file
    ssl_key_file: /path/to/ssl_key_file

    # Whether server will request client for a certificate
    ssl_require_client_auth: false

    # The following file is used only if ssl_require_client_auth=1
    ssl_ca_cert_file: /path/to/ssl_ca_cert_file

    # Default compression algorithm (applied if client doesn't specify another algorithm).
    # Supported algorithms: none, deflate, gzip, stream_gzip
    compression: deflate

    # Default compression level (applied if client doesn't specify another level).
    # Supported levels: none, low, medium, high
    compression_level: medium

    # Send/receive message size limits in bytes. -1 means unlimited
    max_send_message_size: -1
    max_receive_message_size: -1

    # Enable if you want very detailed logs
    verbose_logs: false

# Used with https_port and tcp_port_secure. Full ssl options list: https://github.com/ClickHouse-Extras/poco/blob/master/NetSSL_OpenSSL/include/Poco/Net/SSLManager.h#L71
openSSL:
    server:
        # Used for https server AND secure tcp port
        # openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/clickhouse-server/server.key -out /etc/clickhouse-server/server.crt
        # certificateFile: /etc/clickhouse-server/server.crt
        # privateKeyFile: /etc/clickhouse-server/server.key

        # dhparams are optional. You can delete the dhParamsFile: element.
        # To generate dhparams, use the following command:
        # openssl dhparam -out /etc/clickhouse-server/dhparam.pem 4096
        # Only file format with BEGIN DH PARAMETERS is supported.
        dhParamsFile: /etc/clickhouse-server/dhparam.pem
        verificationMode: none
        loadDefaultCAFile: true
        cacheSessions: true
        disableProtocols: 'sslv2,sslv3'
        preferServerCiphers: true
    client:
        # Used for connecting to https dictionary source and secured Zookeeper communication
        loadDefaultCAFile: true
        cacheSessions: true
        disableProtocols: 'sslv2,sslv3'
        preferServerCiphers: true

        # Use for self-signed: verificationMode: none
        invalidCertificateHandler:
            # Use for self-signed: name: AcceptCertificateHandler
            name: RejectCertificateHandler

# Default root page on http[s] server. For example load UI from https://tabix.io/ when opening http://localhost:8123
# http_server_default_response: |-
#     <html ng-app="SMI2"><head><base href="http://ui.tabix.io/"></head><body><div ui-view="" class="content-ui"></div><script src="http://loader.tabix.io/master.js"></script></body></html>

# Maximum number of concurrent queries.
max_concurrent_queries: 100

# Maximum memory usage (resident set size) for server process.
# Zero value or unset means default. Default is "max_server_memory_usage_to_ram_ratio" of available physical RAM.
# If the value is larger than "max_server_memory_usage_to_ram_ratio" of available physical RAM, it will be cut down.

# The constraint is checked on query execution time.
# If a query tries to allocate memory and the current memory usage plus allocation is greater
# than specified threshold, exception will be thrown.

# It is not practical to set this constraint to small values like just a few gigabytes,
# because memory allocator will keep this amount of memory in caches and the server will deny service of queries.
max_server_memory_usage: 0

# Maximum number of threads in the Global thread pool.
# This will default to a maximum of 10000 threads if not specified.
# This setting will be useful in scenarios where there are a large number
# of distributed queries that are running concurrently but are idling most
# of the time, in which case a higher number of threads might be required.
max_thread_pool_size: 10000

# On memory constrained environments you may have to set this to value larger than 1.
max_server_memory_usage_to_ram_ratio: 0.9

# Simple server-wide memory profiler. Collect a stack trace at every peak allocation step (in bytes).
# Data will be stored in system.trace_log table with query_id = empty string.
# Zero means disabled.
total_memory_profiler_step: 4194304

# Collect random allocations and deallocations and write them into system.trace_log with 'MemorySample' trace_type.
# The probability is for every alloc/free regardless to the size of the allocation.
# Note that sampling happens only when the amount of untracked memory exceeds the untracked memory limit,
# which is 4 MiB by default but can be lowered if 'total_memory_profiler_step' is lowered.
# You may want to set 'total_memory_profiler_step' to 1 for extra fine grained sampling.
total_memory_tracker_sample_probability: 0

# Set limit on number of open files (default: maximum). This setting makes sense on Mac OS X because getrlimit() fails to retrieve
# correct maximum value.
# max_open_files: 262144

# Size of cache of uncompressed blocks of data, used in tables of MergeTree family.
# In bytes. Cache is single for server. Memory is allocated only on demand.
# Cache is used when 'use_uncompressed_cache' user setting turned on (off by default).
# Uncompressed cache is advantageous only for very short queries and in rare cases.

# Note: uncompressed cache can be pointless for lz4, because memory bandwidth
# is slower than multi-core decompression on some server configurations.
# Enabling it can sometimes paradoxically make queries slower.
uncompressed_cache_size: 8589934592

# Approximate size of mark cache, used in tables of MergeTree family.
# In bytes. Cache is single for server. Memory is allocated only on demand.
# You should not lower this value.
# mark_cache_size: 5368709120

# For marks of secondary indices.
# index_mark_cache_size: 5368709120

# If you enable the `min_bytes_to_use_mmap_io` setting,
# the data in MergeTree tables can be read with mmap to avoid copying from kernel to userspace.
# It makes sense only for large files and helps only if data reside in page cache.
# To avoid frequent open/mmap/munmap/close calls (which are very expensive due to consequent page faults)
# and to reuse mappings from several threads and queries,
# the cache of mapped files is maintained. Its size is the number of mapped regions (usually equal to the number of mapped files).
# The amount of data in mapped files can be monitored
# in system.metrics, system.metric_log by the MMappedFiles, MMappedFileBytes metrics
# and in system.asynchronous_metrics, system.asynchronous_metrics_log by the MMapCacheCells metric,
# and also in system.events, system.processes, system.query_log, system.query_thread_log, system.query_views_log by the
# CreatedReadBufferMMap, CreatedReadBufferMMapFailed, MMappedFileCacheHits, MMappedFileCacheMisses events.
# Note that the amount of data in mapped files does not consume memory directly and is not accounted
# in query or server memory usage - because this memory can be discarded similar to OS page cache.
# The cache is dropped (the files are closed) automatically on removal of old parts in MergeTree,
# also it can be dropped manually by the SYSTEM DROP MMAP CACHE query.
# mmap_cache_size: 1024

# Cache size in bytes for compiled expressions.
# compiled_expression_cache_size: 134217728

# Cache size in elements for compiled expressions.
# compiled_expression_cache_elements_size: 10000

# Configuration for the query cache
# query_cache:
#     max_size_in_bytes: 1073741824
#     max_entries: 1024
#     max_entry_size_in_bytes: 1048576
#     max_entry_size_in_rows: 30000000

# Path to data directory, with trailing slash.
path: /var/lib/clickhouse/

# Path to temporary data for processing hard queries.
tmp_path: /var/lib/clickhouse/tmp/

# Policy from the <storage_configuration> for the temporary files.
# If not set <tmp_path> is used, otherwise <tmp_path> is ignored.

# Notes:
# - move_factor              is ignored
# - keep_free_space_bytes    is ignored
# - max_data_part_size_bytes is ignored
# - you must have exactly one volume in that policy
# tmp_policy: tmp

# Directory with user provided files that are accessible by 'file' table function.
user_files_path: /var/lib/clickhouse/user_files/

# LDAP server definitions.
ldap_servers: ''

# List LDAP servers with their connection parameters here to later 1) use them as authenticators for dedicated local users,
# who have 'ldap' authentication mechanism specified instead of 'password', or to 2) use them as remote user directories.
# Parameters:
# host - LDAP server hostname or IP, this parameter is mandatory and cannot be empty.
# port - LDAP server port, default is 636 if enable_tls is set to true, 389 otherwise.
# bind_dn - template used to construct the DN to bind to.
# The resulting DN will be constructed by replacing all '{user_name}' substrings of the template with the actual
# user name during each authentication attempt.
# user_dn_detection - section with LDAP search parameters for detecting the actual user DN of the bound user.
# This is mainly used in search filters for further role mapping when the server is Active Directory. The
# resulting user DN will be used when replacing '{user_dn}' substrings wherever they are allowed. By default,
# user DN is set equal to bind DN, but once search is performed, it will be updated with to the actual detected
# user DN value.
# base_dn - template used to construct the base DN for the LDAP search.
# The resulting DN will be constructed by replacing all '{user_name}' and '{bind_dn}' substrings
# of the template with the actual user name and bind DN during the LDAP search.
# scope - scope of the LDAP search.
# Accepted values are: 'base', 'one_level', 'children', 'subtree' (the default).
# search_filter - template used to construct the search filter for the LDAP search.
# The resulting filter will be constructed by replacing all '{user_name}', '{bind_dn}', and '{base_dn}'
# substrings of the template with the actual user name, bind DN, and base DN during the LDAP search.
# Note, that the special characters must be escaped properly in XML.
# verification_cooldown - a period of time, in seconds, after a successful bind attempt, during which a user will be assumed
# to be successfully authenticated for all consecutive requests without contacting the LDAP server.
# Specify 0 (the default) to disable caching and force contacting the LDAP server for each authentication request.
# enable_tls - flag to trigger use of secure connection to the LDAP server.
# Specify 'no' for plain text (ldap://) protocol (not recommended).
# Specify 'yes' for LDAP over SSL/TLS (ldaps://) protocol (recommended, the default).
# Specify 'starttls' for legacy StartTLS protocol (plain text (ldap://) protocol, upgraded to TLS).
# tls_minimum_protocol_version - the minimum protocol version of SSL/TLS.
# Accepted values are: 'ssl2', 'ssl3', 'tls1.0', 'tls1.1', 'tls1.2' (the default).
# tls_require_cert - SSL/TLS peer certificate verification behavior.
# Accepted values are: 'never', 'allow', 'try', 'demand' (the default).
# tls_cert_file - path to certificate file.
# tls_key_file - path to certificate key file.
# tls_ca_cert_file - path to CA certificate file.
# tls_ca_cert_dir - path to the directory containing CA certificates.
# tls_cipher_suite - allowed cipher suite (in OpenSSL notation).
# Example:
# my_ldap_server:
#     host: localhost
#     port: 636
#     bind_dn: 'uid={user_name},ou=users,dc=example,dc=com'
#     verification_cooldown: 300
#     enable_tls: yes
#     tls_minimum_protocol_version: tls1.2
#     tls_require_cert: demand
#     tls_cert_file: /path/to/tls_cert_file
#     tls_key_file: /path/to/tls_key_file
#     tls_ca_cert_file: /path/to/tls_ca_cert_file
#     tls_ca_cert_dir: /path/to/tls_ca_cert_dir
#     tls_cipher_suite: ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:AES256-GCM-SHA384

# Example (typical Active Directory with configured user DN detection for further role mapping):
# my_ad_server:
#     host: localhost
#     port: 389
#     bind_dn: 'EXAMPLE\{user_name}'
#     user_dn_detection:
#         base_dn: CN=Users,DC=example,DC=com
#         search_filter: '(&amp;(objectClass=user)(sAMAccountName={user_name}))'
#     enable_tls: no

# To enable Kerberos authentication support for HTTP requests (GSS-SPNEGO), for those users who are explicitly configured
# to authenticate via Kerberos, define a single 'kerberos' section here.
# Parameters:
# principal - canonical service principal name, that will be acquired and used when accepting security contexts.
# This parameter is optional, if omitted, the default principal will be used.
# This parameter cannot be specified together with 'realm' parameter.
# realm - a realm, that will be used to restrict authentication to only those requests whose initiator's realm matches it.
# This parameter is optional, if omitted, no additional filtering by realm will be applied.
# This parameter cannot be specified together with 'principal' parameter.
# Example:
# kerberos: ''

# Example:
# kerberos:
#     principal: HTTP/clickhouse.example.com@EXAMPLE.COM

# Example:
# kerberos:
#     realm: EXAMPLE.COM

# Sources to read users, roles, access rights, profiles of settings, quotas.
user_directories:
    # users_xml:
        # Path to configuration file with predefined users.
        # path: users.yaml
    local_directory:
        # Path to folder where users created by SQL commands are stored.
        path: /var/lib/clickhouse/access/

#   # To add an LDAP server as a remote user directory of users that are not defined locally, define a single 'ldap' section
#   # with the following parameters:
#   # server - one of LDAP server names defined in 'ldap_servers' config section above.
#   # This parameter is mandatory and cannot be empty.
#   # roles - section with a list of locally defined roles that will be assigned to each user retrieved from the LDAP server.
#   # If no roles are specified here or assigned during role mapping (below), user will not be able to perform any
#   # actions after authentication.
#   # role_mapping - section with LDAP search parameters and mapping rules.
#   # When a user authenticates, while still bound to LDAP, an LDAP search is performed using search_filter and the
#   # name of the logged in user. For each entry found during that search, the value of the specified attribute is
#   # extracted. For each attribute value that has the specified prefix, the prefix is removed, and the rest of the
#   # value becomes the name of a local role defined in ClickHouse, which is expected to be created beforehand by
#   # CREATE ROLE command.
#   # There can be multiple 'role_mapping' sections defined inside the same 'ldap' section. All of them will be
#   # applied.
#   # base_dn - template used to construct the base DN for the LDAP search.
#   # The resulting DN will be constructed by replacing all '{user_name}', '{bind_dn}', and '{user_dn}'
#   # substrings of the template with the actual user name, bind DN, and user DN during each LDAP search.
#   # scope - scope of the LDAP search.
#   # Accepted values are: 'base', 'one_level', 'children', 'subtree' (the default).
#   # search_filter - template used to construct the search filter for the LDAP search.
#   # The resulting filter will be constructed by replacing all '{user_name}', '{bind_dn}', '{user_dn}', and
#   # '{base_dn}' substrings of the template with the actual user name, bind DN, user DN, and base DN during
#   # each LDAP search.
#   # Note, that the special characters must be escaped properly in XML.
#   # attribute - attribute name whose values will be returned by the LDAP search. 'cn', by default.
#   # prefix - prefix, that will be expected to be in front of each string in the original list of strings returned by
#   # the LDAP search. Prefix will be removed from the original strings and resulting strings will be treated
#   # as local role names. Empty, by default.
#   # Example:
#   # ldap:
#   #     server: my_ldap_server
#   #     roles:
#   #         my_local_role1: ''
#   #         my_local_role2: ''
#   #     role_mapping:
#   #         base_dn: 'ou=groups,dc=example,dc=com'
#   #         scope: subtree
#   #         search_filter: '(&amp;(objectClass=groupOfNames)(member={bind_dn}))'
#   #         attribute: cn
#   #         prefix: clickhouse_
#   # Example (typical Active Directory with role mapping that relies on the detected user DN):
#   # ldap:
#   #     server: my_ad_server
#   #     role_mapping:
#   #         base_dn: 'CN=Users,DC=example,DC=com'
#   #         attribute: CN
#   #         scope: subtree
#   #         search_filter: '(&amp;(objectClass=group)(member={user_dn}))'
#   #         prefix: clickhouse_

# Default profile of settings.
default_profile: default

# Comma-separated list of prefixes for user-defined settings.
# custom_settings_prefixes: ''
# System profile of settings. This settings are used by internal processes (Distributed DDL worker and so on).
# system_profile: default

# Buffer profile of settings.
# This settings are used by Buffer storage to flush data to the underlying table.
# Default: used from system_profile directive.
# buffer_profile: default

# Default database.
default_database: default

# Server time zone could be set here.

# Time zone is used when converting between String and DateTime types,
# when printing DateTime in text formats and parsing DateTime from text,
# it is used in date and time related functions, if specific time zone was not passed as an argument.

# Time zone is specified as identifier from IANA time zone database, like UTC or Africa/Abidjan.
# If not specified, system time zone at server startup is used.

# Please note, that server could display time zone alias instead of specified name.
# Example: Zulu is an alias for UTC.
# timezone: UTC

# You can specify umask here (see "man umask"). Server will apply it on startup.
# Number is always parsed as octal. Default umask is 027 (other users cannot read logs, data files, etc; group can only read).
# umask: 022

# Perform mlockall after startup to lower first queries latency
# and to prevent clickhouse executable from being paged out under high IO load.
# Enabling this option is recommended but will lead to increased startup time for up to a few seconds.
mlock_executable: true

# Reallocate memory for machine code ("text") using huge pages. Highly experimental.
remap_executable: false

# Uncomment below in order to use JDBC table engine and function.
# To install and run JDBC bridge in background:
# * [Debian/Ubuntu]
# export MVN_URL=https://repo1.maven.org/maven2/ru/yandex/clickhouse/clickhouse-jdbc-bridge
# export PKG_VER=$(curl -sL $MVN_URL/maven-metadata.xml | grep '<release>' | sed -e 's|.*>\(.*\)<.*|\1|')
# wget https://github.com/ClickHouse/clickhouse-jdbc-bridge/releases/download/v$PKG_VER/clickhouse-jdbc-bridge_$PKG_VER-1_all.deb
# apt install --no-install-recommends -f ./clickhouse-jdbc-bridge_$PKG_VER-1_all.deb
# clickhouse-jdbc-bridge &
# * [CentOS/RHEL]
# export MVN_URL=https://repo1.maven.org/maven2/ru/yandex/clickhouse/clickhouse-jdbc-bridge
# export PKG_VER=$(curl -sL $MVN_URL/maven-metadata.xml | grep '<release>' | sed -e 's|.*>\(.*\)<.*|\1|')
# wget https://github.com/ClickHouse/clickhouse-jdbc-bridge/releases/download/v$PKG_VER/clickhouse-jdbc-bridge-$PKG_VER-1.noarch.rpm
# yum localinstall -y clickhouse-jdbc-bridge-$PKG_VER-1.noarch.rpm
# clickhouse-jdbc-bridge &
# Please refer to https://github.com/ClickHouse/clickhouse-jdbc-bridge#usage for more information.

# jdbc_bridge:
#     host: 127.0.0.1
#     port: 9019

# Configuration of clusters that could be used in Distributed tables.
# https://clickhouse.com/docs/en/operations/table_engines/distributed/
# remote_servers:
    # Test only shard config for testing distributed storage
    # default:
        # Inter-server per-cluster secret for Distributed queries
        # default: no secret (no authentication will be performed)

        # If set, then Distributed queries will be validated on shards, so at least:
        # - such cluster should exist on the shard,
        # - such cluster should have the same secret.

        # And also (and which is more important), the initial_user will
        # be used as current user for the query.

        # Right now the protocol is pretty simple and it only takes into account:
        # - cluster name
        # - query

        # Also it will be nice if the following will be implemented:
        # - source hostname (see interserver_http_host), but then it will depends from DNS,
        # it can use IP address instead, but then the you need to get correct on the initiator node.
        # - target hostname / ip address (same notes as for source hostname)
        # - time-based security tokens
        # secret: ''
        # shard:
            # Optional. Whether to write data to just one of the replicas. Default: false (write data to all replicas).
            # internal_replication: false
            # Optional. Shard weight when writing data. Default: 1.
            # weight: 1
            # replica:
                # host: localhost
                # port: 9000
                # Optional. Priority of the replica for load_balancing. Default: 1 (less value has more priority).
                # priority: 1
                # Use SSL? Default: no
                # secure: 0

# The list of hosts allowed to use in URL-related storage engines and table functions.
# If this section is not present in configuration, all hosts are allowed.
# remote_url_allow_hosts:

# Host should be specified exactly as in URL. The name is checked before DNS resolution.
# Example: "clickhouse.com", "clickhouse.com." and "www.clickhouse.com" are different hosts.
# If port is explicitly specified in URL, the host:port is checked as a whole.
# If host specified here without port, any port with this host allowed.
# "clickhouse.com" -> "clickhouse.com:443", "clickhouse.com:80" etc. is allowed, but "clickhouse.com:80" -> only "clickhouse.com:80" is allowed.
# If the host is specified as IP address, it is checked as specified in URL. Example: "[2a02:6b8:a::a]".
# If there are redirects and support for redirects is enabled, every redirect (the Location field) is checked.

# Regular expression can be specified. RE2 engine is used for regexps.
# Regexps are not aligned: don't forget to add ^ and $. Also don't forget to escape dot (.) metacharacter
# (forgetting to do so is a common source of error).

# If element has 'incl' attribute, then for it's value will be used corresponding substitution from another file.
# By default, path to file with substitutions is /etc/metrika.xml. It could be changed in config in 'include_from' element.
# Values for substitutions are specified in /clickhouse/name_of_substitution elements in that file.

# ZooKeeper is used to store metadata about replicas, when using Replicated tables.
# Optional. If you don't use replicated tables, you could omit that.
# See https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replication/

# zookeeper:
#     - node:
#         host: example1
#         port: 2181
#     - node:
#         host: example2
#         port: 2181
#     - node:
#         host: example3
#         port: 2181

# Substitutions for parameters of replicated tables.
# Optional. If you don't use replicated tables, you could omit that.
# See https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replication/#creating-replicated-tables
# macros:
#     shard: 01
#     replica: example01-01-1

# Reloading interval for embedded dictionaries, in seconds. Default: 3600.
builtin_dictionaries_reload_interval: 3600

# Maximum session timeout, in seconds. Default: 3600.
max_session_timeout: 3600

# Default session timeout, in seconds. Default: 60.
default_session_timeout: 60

# Sending data to Graphite for monitoring. Several sections can be defined.
# interval - send every X second
# root_path - prefix for keys
# hostname_in_path - append hostname to root_path (default = true)
# metrics - send data from table system.metrics
# events - send data from table system.events
# asynchronous_metrics - send data from table system.asynchronous_metrics

# graphite:
#     host: localhost
#     port: 42000
#     timeout: 0.1
#     interval: 60
#     root_path: one_min
#     hostname_in_path: true

#     metrics: true
#     events: true
#     events_cumulative: false
#     asynchronous_metrics: true

# graphite:
#     host: localhost
#     port: 42000
#     timeout: 0.1
#     interval: 1
#     root_path: one_sec

#     metrics: true
#     events: true
#     events_cumulative: false
#     asynchronous_metrics: false

# Serve endpoint for Prometheus monitoring.
# endpoint - mertics path (relative to root, statring with "/")
# port - port to setup server. If not defined or 0 than http_port used
# metrics - send data from table system.metrics
# events - send data from table system.events
# asynchronous_metrics - send data from table system.asynchronous_metrics

prometheus:
    endpoint: /metrics
    port: 9363

    metrics: true
    events: true
    asynchronous_metrics: true

# Query log. Used only for queries with setting log_queries = 1.
query_log:
    # What table to insert data. If table is not exist, it will be created.
    # When query log structure is changed after system update,
    # then old table will be renamed and new table will be created automatically.
    database: system
    table: query_log

    # PARTITION BY expr: https://clickhouse.com/docs/en/table_engines/mergetree-family/custom_partitioning_key/
    # Example:
    # event_date
    # toMonday(event_date)
    # toYYYYMM(event_date)
    # toStartOfHour(event_time)
    partition_by: toYYYYMM(event_date)

    # Table TTL specification: https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/mergetree/#mergetree-table-ttl
    # Example:
    # event_date + INTERVAL 1 WEEK
    # event_date + INTERVAL 7 DAY DELETE
    # event_date + INTERVAL 2 WEEK TO DISK 'bbb'

    # ttl: 'event_date + INTERVAL 30 DAY DELETE'

    # Instead of partition_by, you can provide full engine expression (starting with ENGINE = ) with parameters,
    # Example: engine: 'ENGINE = MergeTree PARTITION BY toYYYYMM(event_date) ORDER BY (event_date, event_time) SETTINGS index_granularity = 1024'

    # Interval of flushing data.
    flush_interval_milliseconds: 7500

# Trace log. Stores stack traces collected by query profilers.
# See query_profiler_real_time_period_ns and query_profiler_cpu_time_period_ns settings.
# trace_log:
#     database: system
#     table: trace_log
#     partition_by: toYYYYMM(event_date)
#     flush_interval_milliseconds: 7500

# Query thread log. Has information about all threads participated in query execution.
# Used only for queries with setting log_query_threads = 1.
query_thread_log:
    database: system
    table: query_thread_log
    partition_by: toYYYYMM(event_date)
    flush_interval_milliseconds: 7500

# Query views log. Has information about all dependent views associated with a query.
# Used only for queries with setting log_query_views = 1.
query_views_log:
    database: system
    table: query_views_log
    partition_by: toYYYYMM(event_date)
    flush_interval_milliseconds: 7500

# Uncomment if use part log.
# Part log contains information about all actions with parts in MergeTree tables (creation, deletion, merges, downloads).
# part_log:
#     database: system
#     table: part_log
#     partition_by: toYYYYMM(event_date)
#     flush_interval_milliseconds: 7500

# Uncomment to write text log into table.
# Text log contains all information from usual server log but stores it in structured and efficient way.
# The level of the messages that goes to the table can be limited (<level>), if not specified all messages will go to the table.
# text_log:
#     database: system
#     table: text_log
#     flush_interval_milliseconds: 7500
#     level: ''

# Metric log contains rows with current values of ProfileEvents, CurrentMetrics collected with "collect_interval_milliseconds" interval.
# metric_log:
#     database: system
#     table: metric_log
#     flush_interval_milliseconds: 7500
#     collect_interval_milliseconds: 1000

# Error log contains rows with current values of errors collected with "collect_interval_milliseconds" interval.
# error_log:
#     database: system
#     table: error_log
#     flush_interval_milliseconds: 7500
#     collect_interval_milliseconds: 1000

# Asynchronous metric log contains values of metrics from
# system.asynchronous_metrics.
# asynchronous_metric_log:
#     database: system
#     table: asynchronous_metric_log

    # Asynchronous metrics are updated once a minute, so there is
    # no need to flush more often.
    # flush_interval_milliseconds: 60000

# OpenTelemetry log contains OpenTelemetry trace spans.
# opentelemetry_span_log:

    # The default table creation code is insufficient, this <engine> spec
    # is a workaround. There is no 'event_time' for this log, but two times,
    # start and finish. It is sorted by finish time, to avoid inserting
    # data too far away in the past (probably we can sometimes insert a span
    # that is seconds earlier than the last span in the table, due to a race
    # between several spans inserted in parallel). This gives the spans a
    # global order that we can use to e.g. retry insertion into some external
    # system.
    # engine: |-
    #     engine MergeTree
    #          partition by toYYYYMM(finish_date)
    #          order by (finish_date, finish_time_us, trace_id)
    # database: system
    # table: opentelemetry_span_log
    # flush_interval_milliseconds: 7500

# Crash log. Stores stack traces for fatal errors.
# This table is normally empty.
crash_log:
    database: system
    table: crash_log
    partition_by: ''
    flush_interval_milliseconds: 1000

# top_level_domains_path: /var/lib/clickhouse/top_level_domains/
# Custom TLD lists.
# Format: name: /path/to/file

# Changes will not be applied w/o server restart.
# Path to the list is under top_level_domains_path (see above).
top_level_domains_lists: ''

# public_suffix_list: /path/to/public_suffix_list.dat

# Configuration of external dictionaries. See:
# https://clickhouse.com/docs/en/sql-reference/dictionaries/external-dictionaries/external-dicts
dictionaries_config: '*_dictionary.xml'

# Uncomment if you want data to be compressed 30-100% better.
# Don't do that if you just started using ClickHouse.

# compression:
#     # Set of variants. Checked in order. Last matching case wins. If nothing matches, lz4 will be used.
#     case:
#         Conditions. All must be satisfied. Some conditions may be omitted.
#         # min_part_size: 10000000000    # Min part size in bytes.
#         # min_part_size_ratio: 0.01     # Min size of part relative to whole table size.
#         # What compression method to use.
#         method: zstd

# Allow to execute distributed DDL queries (CREATE, DROP, ALTER, RENAME) on cluster.
# Works only if ZooKeeper is enabled. Comment it if such functionality isn't required.
distributed_ddl:
    # Path in ZooKeeper to queue with DDL queries
    path: /clickhouse/task_queue/ddl

    # Settings from this profile will be used to execute DDL queries
    # profile: default

    # Controls how much ON CLUSTER queries can be run simultaneously.
    # pool_size: 1

    # Cleanup settings (active tasks will not be removed)

    # Controls task TTL (default 1 week)
    # task_max_lifetime: 604800

    # Controls how often cleanup should be performed (in seconds)
    # cleanup_delay_period: 60

    # Controls how many tasks could be in the queue
    # max_tasks_in_queue: 1000

# Settings to fine tune MergeTree tables. See documentation in source code, in MergeTreeSettings.h
# merge_tree:
#     max_suspicious_broken_parts: 5

# Protection from accidental DROP.
# If size of a MergeTree table is greater than max_table_size_to_drop (in bytes) than table could not be dropped with any DROP query.
# If you want do delete one table and don't want to change clickhouse-server config, you could create special file <clickhouse-path>/flags/force_drop_table and make DROP once.
# By default max_table_size_to_drop is 50GB; max_table_size_to_drop=0 allows to DROP any tables.
# The same for max_partition_size_to_drop.
# Uncomment to disable protection.

# max_table_size_to_drop: 0
# max_partition_size_to_drop: 0

# Example of parameters for GraphiteMergeTree table engine
# graphite_rollup_example:
#     pattern:
#         regexp: click_cost
#         function: any
#         retention:
#             - age: 0
#               precision: 3600
#             - age: 86400
#               precision: 60
#     default:
#         function: max
#         retention:
#             - age: 0
#               precision: 60
#             - age: 3600
#               precision: 300
#             - age: 86400
#               precision: 3600

# Directory in <clickhouse-path> containing schema files for various input formats.
# The directory will be created if it doesn't exist.
format_schema_path: /var/lib/clickhouse/format_schemas/

# Default query masking rules, matching lines would be replaced with something else in the logs
# (both text logs and system.query_log).
# name - name for the rule (optional)
# regexp - RE2 compatible regular expression (mandatory)
# replace - substitution string for sensitive data (optional, by default - six asterisks)
query_masking_rules:
    rule:
        name: hide encrypt/decrypt arguments
        regexp: '((?:aes_)?(?:encrypt|decrypt)(?:_mysql)?)\s*\(\s*(?:''(?:\\''|.)+''|.*?)\s*\)'
        # or more secure, but also more invasive:
        # (aes_\w+)\s*\(.*\)
        replace: \1(???)

# Uncomment to use custom http handlers.
# rules are checked from top to bottom, first match runs the handler
# url - to match request URL, you can use 'regex:' prefix to use regex match(optional)
# methods - to match request method, you can use commas to separate multiple method matches(optional)
# headers - to match request headers, match each child element(child element name is header name), you can use 'regex:' prefix to use regex match(optional)
# handler is request handler
# type - supported types: static, dynamic_query_handler, predefined_query_handler
# query - use with predefined_query_handler type, executes query when the handler is called
# query_param_name - use with dynamic_query_handler type, extracts and executes the value corresponding to the <query_param_name> value in HTTP request params
# status - use with static type, response status code
# content_type - use with static type, response content-type
# response_content - use with static type, Response content sent to client, when using the prefix 'file://' or 'config://', find the content from the file or configuration send to client.

# http_handlers:
#     - rule:
#         url: /
#         methods: POST,GET
#         headers:
#           pragma: no-cache
#         handler:
#           type: dynamic_query_handler
#           query_param_name: query
#     - rule:
#         url: /predefined_query
#         methods: POST,GET
#         handler:
#           type: predefined_query_handler
#           query: 'SELECT * FROM system.settings'
#     - rule:
#         handler:
#           type: static
#           status: 200
#           content_type: 'text/plain; charset=UTF-8'
#           response_content: config://http_server_default_response

send_crash_reports:
    # Changing <enabled> to true allows sending crash reports to
    # the ClickHouse core developers team via Sentry https://sentry.io
    # Doing so at least in pre-production environments is highly appreciated
    enabled: false
    # Change <anonymize> to true if you don't feel comfortable attaching the server hostname to the crash report
    anonymize: false
    # Default endpoint should be changed to different Sentry DSN only if you have
    # some in-house engineers or hired consultants who're going to debug ClickHouse issues for you
    endpoint: 'https://6f33034cfe684dd7a3ab9875e57b1c8d@o388870.ingest.sentry.io/5226277'
    # Uncomment to disable ClickHouse internal DNS caching.
    # disable_internal_dns_cache: 1
{{- end -}}
