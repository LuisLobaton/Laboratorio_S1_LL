# Laboratorio de Dockerización e IaC
## Requisitos
- Docker y Docker Compose
- Terraform
## Despliegue con Docker Compose
1. Ejecutar `docker-compose up --build -d`
2. El entorno Localhost estará en los puertos 4001 (Web) y 4002 (API).
3. El entorno Dev estará en los puertos 5001 (Web) y 5002 (API).
## Despliegue con Terraform
1. Ir a la carpeta `iac/terraform`.
2. Ejecutar `terraform init`.
3. Ejecutar `terraform apply -auto-approve`.