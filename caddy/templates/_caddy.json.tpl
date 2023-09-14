{{- define "caddy.config" -}}
{
  "admin": {
    "disabled": true
  },
  "apps": {
    "http": {
      "servers": {
        "srv0": {
          "listen": [
            ":443"
          ],
          "logs": {
            "logger_names": {
              "api.cbnr.xyz": "default"
            }
          },
          "routes": [
            {
              "handle": [
                {
                  "handler": "subroute",
                  "routes": [
                    {
                      "handle": [
                        {
                          "handler": "reverse_proxy",
                          "upstreams": [
                            {
                              "dial": "serve.default:8080"
                            }
                          ]
                        }
                      ],
                      "match": [
                        {
                          "path": [
                            "/query"
                          ]
                        }
                      ]
                    }
                  ]
                }
              ],
              "match": [
                {
                  "host": [
                    "api.cbnr.xyz"
                  ]
                }
              ],
              "terminal": true
            }
          ]
        }
      }
    },
    "layer4": {
      "servers": {
        "srv1": {
          "listen": [
            ":517"
          ],
          "routes": [
            {
              "handle": [
                {
                  "handler": "proxy",
                  "upstreams": [
                    {
                      "dial": [
                        "intake.default:8517"
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
    },
    "tls": {
      "automation": {
        "policies": [
          {
            "issuers": [
              {
                "email": "brandon@willett.io",
                "module": "acme"
              },
              {
                "email": "brandon@willett.io",
                "module": "zerossl"
              }
            ],
            "subjects": [
              "api.cbnr.xyz"
            ]
          }
        ]
      }
    }
  },
  "logging": {
    "logs": {
      "default": {
        "encoder": {
          "format": "console"
        }
      }
    }
  },
  "storage": {
    "module": "file_system",
    "root": "/var/lib/caddy/.local/share/caddy"
  }
}
{{- end -}}
