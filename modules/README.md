# 🛡️ Secure Web App on AWS using Terraform

This project provisions a secure, scalable web application infrastructure on AWS using Terraform. It includes **private backend servers**, **internal and public ALBs**, and **reverse proxy setup with Nginx**.

---

## ✅ Architecture Overview

<img width="1237" height="699" alt="Screenshot from 2025-07-18 20-26-02" src="https://github.com/user-attachments/assets/9dbb284d-c84a-4e2e-98fd-8326e4f459d7" />


## 🔧 Infrastructure Components

- **VPC** with 2 public & 2 private subnets
- **Internet Gateway**, **Route Tables**, **NAT Gateway**
- **EC2 instances**:
  - Public (proxy servers with Nginx)
  - Private (Flask backend app)
- **Application Load Balancers**:
  - Public ALB (exposed to internet)
  - Internal ALB (private, connected to backend)
- **Security Groups** for fine-grained access control
- **Bastion host** pattern for provisioning backend via Terraform

---

## 📦 Terraform Modules

- `modules/vpc`: Creates networking
- `modules/ec2-public`: Proxy EC2s with Nginx
- `modules/ec2-private`: Backend EC2s with Flask
- `modules/public-alb`: External ALB
- `modules/internal-alb`: Internal ALB for backend

---

## 🚀 Deployment Steps

1. Clone the repo:
   ```bash
   git clone git@github.com:OmarAdawy17/secure-webapp-terraform.git
   cd secure-webapp-terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the infrastructure:
   ```bash
   terraform apply
   ```
<img width="1920" height="1080" alt="Screenshot from 2025-07-18 20-19-12" src="https://github.com/user-attachments/assets/22a57824-c30f-4ae6-b9e2-cee7d7d48c5a" />
---

## 🖥️ Accessing the App

After deployment:

- Go to the output of `terraform output public_alb_dns`
- Visit:  
  ```bash
  http://<public_alb_dns>
  ```

You should see:
```
Hello from backend!
```
<img width="1920" height="1080" alt="Screenshot from 2025-07-18 20-20-12" src="https://github.com/user-attachments/assets/6be36250-0f4b-4879-b837-7f441a492876" />

---

## 📁 Project Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── app/                   # Flask app code
├── modules/
│   ├── vpc/
│   ├── ec2-public/
│   ├── ec2-private/
│   ├── public-alb/
│   └── internal-alb/
```

---

## 🧠 Notes

- The backend Flask app is automatically installed and started by Terraform using `remote-exec` and `file` provisioners.
- Uses **Bastion Host** pattern to access private instances.
- You must add your SSH key to `~/.ssh/mykey` and import it into AWS as `mykey`.

---

## 📜 License

MIT License. Use freely and contribute!

---

## ✍️ Author

Developed by [@OmarAdawy17](https://github.com/OmarAdawy17)
