## Jenkins pipeline notes and setup

1. **Jenkins credentials**
   - `dockerhub-creds`: Username/password for Docker registry (Docker Hub). Add it as "Username with password".
   - `ec2-ssh-key`: SSH private key for connecting to EC2 (credential type: "SSH Username with private key" or using ssh-agent plugin). Use username `ec2-user` or the appropriate user for your AMI.

2. **Jenkins environment**
   - Ensure the Jenkins agent that runs the job has Docker installed and permissions to run Docker commands
     (or run within a Docker-in-Docker agent).
   - If using a hosted Jenkins controller without Docker, use a node/agent with Docker.

3. **EC2**
   - Install Docker: `sudo apt-get update && sudo apt-get install -y docker.io` (Ubuntu) or `amazon-linux-extras install docker` (Amazon Linux) then `sudo service docker start` and add `ec2-user` to docker group if desired.
   - Ensure security group allows SSH from the Jenkins host/IP.

4. **Placeholders to replace**
   - `<DOCKERHUB_REPO>` -> your Docker Hub username/namespace (ex: `mydockerhubuser`)
   - `<EC2_HOST>` -> EC2 public IP or DNS

5. **Deployment flow**
   - Jenkins builds jar -> Docker image -> pushes to registry -> SSH into EC2 -> pulls image -> runs container.

6. **Optional**
   - Use AWS ECR instead of Docker Hub (modify Jenkinsfile to login to ECR via AWS CLI and push).
   - Use systemd + docker-compose to manage services on EC2.
