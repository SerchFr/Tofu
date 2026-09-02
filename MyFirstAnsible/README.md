# Ansible - Configuration nginx sur VM Infomaniak

## Structure
```
.
├── ansible.cfg
├── inventory/
│   └── hosts.ini          <- à adapter avec l'IP de la VM
├── playbook.yml
└── roles/
    └── nginx/
        ├── defaults/main.yml
        ├── handlers/main.yml
        ├── tasks/main.yml
        └── templates/
            ├── nginx-site.conf.j2
            └── index.html.j2
```

## Avant de lancer

1. Récupérez l'IP publique de la VM créée par OpenTofu :
   ```bash
   cd /chemin/vers/votre/projet/opentofu
   tofu output
   ```

2. Modifiez `inventory/hosts.ini` :
   ```ini
   infomaniak_vm ansible_host=<IP_REELLE> ansible_user=<UTILISATEUR> ansible_ssh_private_key_file=~/.ssh/id_ed25519
   ```
   - `ansible_user` dépend de l'image utilisée (souvent `ubuntu`, `debian`, ou `root`).
   - Adaptez le chemin de la clé SSH si nécessaire.

3. Testez la connexion :
   ```bash
   ansible webserver -m ping
   ```

## Lancer la configuration

```bash
ansible-playbook playbook.yml
```

## Vérifier

Une fois terminé, ouvrez `http://<IP_REELLE>` dans un navigateur — vous devriez voir la page de test.

## Personnalisation

Les variables dans `roles/nginx/defaults/main.yml` peuvent être surchargées :
- `nginx_port` (défaut: 80)
- `nginx_server_name` (défaut: "_", accepte tout nom d'hôte)
- `nginx_root` (défaut: /var/www/html)
