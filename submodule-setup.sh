#!/bin/bash

# Step-by-step guide to convert nested repos to submodules

echo "=== Converting nested repositories to Git submodules ==="
echo ""

echo "Step 1: Create GitHub repositories"
echo "Please create these repositories on GitHub:"
echo "1. terraform-codeserver-module"
echo "2. terraform-azurevm-module"
echo ""

echo "Step 2: After creating the repos, run these commands:"
echo ""

echo "# For codeserver:"
echo "cd /home/deepanshu/development/Terraform/codeserver"
echo "git remote add origin https://github.com/Deepanshu291/terraform-codeserver-module.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""

echo "# For azureVM-tf:"
echo "cd /home/deepanshu/development/Terraform/azureVM-tf"
echo "git remote add origin https://github.com/Deepanshu291/terraform-azurevm-module.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""

echo "Step 3: Remove directories and add as submodules:"
echo "cd /home/deepanshu/development/Terraform"
echo "rm -rf codeserver azureVM-tf"
echo "git submodule add https://github.com/Deepanshu291/terraform-codeserver-module.git codeserver"
echo "git submodule add https://github.com/Deepanshu291/terraform-azurevm-module.git azureVM-tf"
echo "git add ."
echo "git commit -m 'Convert nested repos to submodules'"
echo "git push"
echo ""

echo "Step 4: To clone this repo with submodules in the future:"
echo "git clone --recursive https://github.com/Deepanshu291/terraform-codeserver.git"
echo "# OR after cloning:"
echo "git submodule update --init --recursive"
