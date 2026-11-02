# 🏛️ HistoryVerse on AWS ECS Fargate

Production-grade, modular Infrastructure as Code (IaC) for deploying the **HistoryVerse** Multimodal Historical AI Agent microservices on **AWS ECS Fargate** with High Availability, Autoscaling, and Zero-Trust Networking.

---

## 📐 Architecture Overview

```mermaid
graph TD
    Client([Internet / Museum Visitors]) -->|HTTP :80 / HTTPS :443| ALB[Application Load Balancer\nPublic Subnets]
    
    subgraph VPC ["AWS VPC (Multi-AZ 10.0.0.0/16)"]
        subgraph PublicSubnets ["Public Subnets (AZ-a & AZ-b)"]
            ALB
            NAT[NAT Gateway]
        end
        
        subgraph PrivateSubnets ["Private Subnets (Isolated)"]
            ECS1["HistoryVerse Fargate Task 1\nFastAPI :8000"]
            ECS2["HistoryVerse Fargate Task 2\nFastAPI :8000"]
        end
    end

    ALB -->|Forward Target Group :8000\nHealthCheck: /health/live| ECS1
    ALB -->|Forward Target Group :8000\nHealthCheck: /health/live| ECS2
    
    ECS1 -->|Outbound via NAT| LLM[Google Gemini / External APIs]
    ECS2 -->|Outbound via NAT| LLM
    
    ECS1 -.->|Logs| CW[AWS CloudWatch Logs\n/ecs/historyverse]
    ECS2 -.->|Logs| CW
    
    CW -.-> AS[Target Tracking Autoscaling\nCPU 70% | Memory 80%]
    AS -.->|Scale Out / In| PrivateSubnets
```

---

## 🔒 Security & Zero-Trust Design

1. **Private Subnet Placement**: ECS Fargate container instances are hosted entirely in private subnets with **no public IPs**. Direct inbound traffic from the internet is impossible.
2. **Strict Security Groups**:
   - **ALB Security Group**: Accepts port 80 (HTTP) and 443 (HTTPS) from the world (`0.0.0.0/0`).
   - **ECS Tasks Security Group**: Accepts port `8000` **strictly and exclusively** from the ALB Security Group ID. All direct access attempts are dropped.
3. **IAM Least Privilege**:
   - `AmazonECSTaskExecutionRolePolicy`: Limited strictly to pulling container images and streaming logs.
   - Dedicated SSM/Secrets Manager policy allowing secure runtime decryption of credentials (e.g. `GEMINI_API_KEY`, `APP_API_KEY`) without baking secrets into images.

---

## 📦 Modular Directory Structure

```text
historyverse-on-fargate/
├── README.md                      # Architecture documentation and operations runbook
├── versions.tf                    # Terraform (>= 1.5.0) & AWS provider constraints (>= 5.0)
├── variables.tf                   # Root configuration inputs with types and defaults
├── main.tf                        # Root composition wiring modules together
├── outputs.tf                     # Public ALB DNS, ECS Cluster, and VPC outputs
├── terraform.tfvars.example       # Example variable inputs for dev/staging/prod
└── modules/
    ├── vpc/                       # Multi-AZ VPC, IGW, Public/Private subnets, NAT Gateway
    ├── security/                  # ALB and ECS Task security groups (Zero-Trust)
    ├── alb/                       # Application Load Balancer, Target Group (/health/live), Listeners
    ├── iam/                       # ECS Task Execution & Task runtime roles with least-privilege
    └── ecs_fargate/               # Cluster, Fargate Task Definition (port 8000), Service & Autoscaling
```

---

## 🛠️ Local Code Quality & Validation

Verify and lint the Terraform codebase locally without making any calls or deployments to AWS:

### 1. Initialize Modules & Validate Syntax
```bash
terraform init -backend=false
terraform validate
```

### 2. Format & Style Check
```bash
terraform fmt -check -recursive
```

---

## ⚙️ Configuration Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `aws_region` | Target AWS deployment region | `us-east-1` |
| `project_name` | Resource name prefix and tag | `historyverse` |
| `environment` | Deployment stage (`dev`, `staging`, `production`) | `production` |
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` |
| `container_image` | Docker image URI for HistoryVerse | `0marmohamed/historyverse_chatbot:latest` |
| `container_port` | FastAPI HTTP listening port | `8000` |
| `cpu` | Fargate CPU allocation (512 = 0.5 vCPU) | `512` |
| `memory` | Fargate Memory allocation in MiB | `1024` |
| `desired_count` | Number of running task replicas | `2` |
| `enable_autoscaling` | Dynamic scaling based on CPU & Memory | `true` |

---

## 🚀 Deployment (When Ready for Cloud Apply)

1. Copy the example configuration:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Review the execution plan:
   ```bash
   terraform plan
   ```

3. Apply infrastructure:
   ```bash
   terraform apply
   ```

4. Retrieve the public load balancer URL:
   ```bash
   terraform output api_endpoint
   ```
