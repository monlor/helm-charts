# Headplane Helm Chart

## Overview
This Helm chart deploys Headplane and Headscale in a Kubernetes cluster. Headplane provides an interface to manage headscale instances, which is a Tailscale-compatible coordination server.

## Installation

### Prerequisites
- Kubernetes cluster
- Helm installed (`helm version`)

### Add Helm Repository
```sh
helm repo add nbcloud https://charts.nbcloud.io
helm repo update
```

### Install the Chart
```sh
helm install headplane nbcloud/headplane
```

### Upgrade the Chart
```sh
helm upgrade headplane nbcloud/headplane
```

### Uninstall the Chart
```sh
helm uninstall headplane
```

## Configuration
This chart supports customization through the `values.yaml` file.

### Values

#### Global Configuration
| Key | Description | Default |
|------|------------|---------|
| `nodeSelector` | Global node selector for all pods | `{}` |

#### `headplane`
| Key | Description | Default |
|------|------------|---------|
| `image` | Headplane container image | `ghcr.io/tale/headplane:0.5.5` |
| `nodeSelector` | Node selector for headplane pods (inherits from global if not specified) | `{}` |
| `config.server.host` | Server host | `0.0.0.0` |
| `config.server.port` | Server port | `3000` |
| `config.server.cookie_secure` | Use secure cookies | `true` |
| `config.headscale.url` | Headscale URL | `https://vpn.example.com` |
| `config.headscale.config_path` | Path to Headscale config | `/etc/headscale/config.yaml` |
| `config.headscale.config_strict` | Enable strict config mode | `true` |
| `config.integration.kubernetes.enabled` | Enable Kubernetes integration | `true` |
| `config.integration.kubernetes.validate_manifest` | Validate Kubernetes manifest | `true` |
| `config.integration.kubernetes.pod_name` | Headplane pod name | `headplane-0` |
| `config.oidc.issuer` | OIDC issuer URL | `https://your-oidc-issuer-url.com` |
| `config.oidc.disable_api_key_login` | Disable API key login | `true` |
| `config.oidc.token_endpoint_auth_method` | OIDC token auth method | `client_secret_post` |
| `config.oidc.redirect_uri` | OIDC redirect URI | `https://your-headplane-admin-domain.com/admin/oidc/callback` |
| `config.oidc.client_id` | OIDC Client ID | `REPLACE_IT_WITH_YOUR_OIDC_CLIENT_ID_FOR_HEADPLANE` |

#### `headplane.secret`
| Key | Description | Default |
|------|------------|---------|
| `name` | Secret name | `headplane-secret` |
| `create` | Whether to create the secret | `true` |
| `server.cookie_secret` | Cookie secret | `yjbqijkvfrgrtwwkoanqquykeyuyffywd` |
| `oidc.client_secret` | OIDC client secret | `REPLACE_IT_WITH_YOUR_OIDC_CLIENT_SECRET_FOR_HEADPLANE` |
| `oidc.headscale_api_key` | Headscale API key | `REPLACE_IT_WITH_YOUR_HEADSCALE_API_KEY` |

#### `headscale`
| Key | Description | Default |
|------|------------|---------|
| `image` | Headscale container image | `headscale/headscale:0.25.1` |
| `nodeSelector` | Node selector for headscale pods (inherits from global if not specified) | `{}` |
| `derp.enabled` | Enable custom DERP configuration | `false` |
| `derp.config` | Custom DERP configuration (YAML) | See example below |

#### `relay`
| Key | Description | Default |
|------|------------|---------|
| `enabled` | Enable tailscale relay | `true` |
| `image` | Tailscale relay image | `ghcr.io/tailscale/tailscale:v1.80.3` |
| `nodeSelector` | Node selector for tailscale relay pods (inherits from global if not specified) | `{}` |

#### Node Selector Configuration
You can configure node selectors at different levels:

**Global node selector (applies to all pods):**
```yaml
nodeSelector:
  kubernetes.io/os: linux
  node-role.kubernetes.io/worker: "true"
```

**Component-specific node selectors:**
```yaml
headplane:
  nodeSelector:
    kubernetes.io/os: linux
    node-role.kubernetes.io/worker: "true"

relay:
  nodeSelector:
    kubernetes.io/os: linux
    node-role.kubernetes.io/edge: "true"
```

#### Custom DERP Configuration
You can configure custom DERP servers by enabling the `headscale.derp.enabled` option and providing your DERP configuration:

```yaml
headscale:
  derp:
    enabled: true
    config: |
      regions:
        999:
          stun4: "stun.l.google.com:19302"
          stun6: "stun.l.google.com:19302"
          derp4: "derp.example.com:443"
          derp6: "derp.example.com:443"
          regionid: 999
          regioncode: "example"
          regionname: "Example DERP"
          weight: 100
          use_region: true
```

This configuration will be mounted as `/etc/headscale/derp.yaml` in the Headscale container and automatically included in the Headscale configuration.

## Using the Chart
1. Modify `values.yaml` with your settings.
2. Install or upgrade the Helm chart.
3. Check logs with `kubectl logs -l app=headplane`.

For further customization, refer to the Kubernetes documentation on ConfigMaps and Secrets.

## License
Copyright © 2025 nbcloud.io

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at:

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
