# Inception

## Overview

Inception is a System Administration project at 42 school that focuses on Docker containerization and services orchestration. The project requires setting up a small infrastructure composed of different services under specific rules using Docker Compose.

## Project Requirements

### Mandatory Part

- Set up a mini infrastructure composed of different services:
  - A Docker container with NGINX using TLSv1.2 or TLSv1.3
  - A Docker container with WordPress + php-fpm
  - A Docker container with MariaDB
  - A volume for WordPress database
  - A volume for WordPress website files
  - A docker-network connecting the containers
- Each container must be built from the penultimate stable version of Alpine or Debian
- Each service must run in a dedicated container
- Containers must restart in case of a crash

### Technical Constraints

- Docker Compose usage is mandatory
- Containers must be custom-built (no ready-made Docker images)
- Services must be set up with their own Dockerfile
- Images must be built from scratch (no dockerhub)
- The NGINX container must be the only entry point into the infrastructure (port 443)
- Environment variables must be used
- Domain name must point to local IP (localhost)

## Project Structure

```
inception/
├── Makefile
└── srcs/
    │── docker-compose.yml
    │── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/
        └── mariadb/
            ├── Dockerfile
            └── tools/

```

## Installation & Setup

### Prerequisites

- Docker Engine
- Docker Compose
- Make

### Build and Run

1. Clone the repository:

```bash
git clone https://github.com/ismailassil/Inception inception
cd inception
```

2. Create necessary environment variables in `srcs/.env`

3. Build and start the containers:

```bash
make up
```

### Available Make Commands

Run `make` or `make help` to get information about the available commands

## Services Configuration

### NGINX

- Listens on port 443 (HTTPS)
- TLS 1.2/1.3 configuration
- Serves as reverse proxy for WordPress

### WordPress

- Latest WordPress installation
- php-fpm configuration
- Connected to MariaDB
- Custom themes and plugins can be added

### MariaDB

- Secure database configuration
- Persistent data storage
- Custom user and database creation

## Volumes

- `/home/$(login)/data/wordpress`: WordPress files
- `/home/$(login)/data/mariadb`: Database files

## Networks

- Custom Docker network for internal communication between containers

## Security Considerations

- All passwords and sensitive data should be stored in environment variables
- SSL/TLS certificates must be properly configured
- Database access should be restricted to necessary users
- Regular security updates should be maintained

## Troubleshooting

### Common Issues

1. Container startup failures
   - Check logs: `docker logs <container-name>`
   - Verify environment variables
   - Check service configurations

2. Network connectivity issues
   - Verify Docker network creation
   - Check container DNS resolution
   - Confirm proper port mappings

3. Volume mounting problems
   - Verify correct paths in docker-compose.yml
   - Check directory permissions
   - Ensure volumes are properly created

### Debug Commands

```bash
# Check container status
make ps

# View container logs
make logs

# Access container shell
make $(service_name)

# Check network configuration
docker network ls
```

## Best Practices

- Keep sensitive data in environment variables
- Use specific versions for base images
- Implement health checks
- Follow Docker best practices for Dockerfile creation
- Maintain proper documentation
- Regular backups of volumes
- Monitor container resources

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)

## Contributing

When contributing to this project:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
