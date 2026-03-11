# no-public-s3
Beginner policy-as-code lab to block public AWS s3 buckets

# Lab 01: No Public Buckets Allowed

Prevent insecure AWS S3 bucket configurations using **Policy-as-Code with Rego and Conftest**.

This lab demonstrates how security and compliance rules can be converted into executable policies that automatically detect risky infrastructure configurations.

---

# Overview

Public AWS S3 buckets are one of the most common cloud misconfigurations and have been responsible for many high-profile data breaches.

This project demonstrates how to enforce a security rule:

> **S3 buckets must not be publicly readable**

The rule is implemented using:

- **Rego** (policy language)
- **Conftest** (policy testing engine)
- **GitHub Codespaces** (development environment)

---

# Skills Demonstrated

- Policy-as-Code
- Cloud Security Guardrails
- DevSecOps Testing
- Infrastructure Configuration Validation
- Security Control Automation

---

# Repository Structure
no-public-s3
│
├── README.md
├── input.json
├── conftest.toml
└── policy
└── s3.rego
---

# Step 1: Create the Test Configuration

Create a file called `input.json`.
{
"resource_type": "aws_s3_bucket",
"acl": "public-read"
}

This simulates a **public S3 bucket configuration**.

---

# Step 2: Create the Policy

Create the file:
policy/s3.rego

Policy:
package s3policy
deny contains message if {
input.resource_type == "aws_s3_bucket"
input.acl == "public-read"
message := "S3 buckets cannot be publicly readable (acl: public-read)"
}


This rule tells the policy engine:

If the resource is an S3 bucket AND the ACL is public-read → **deny the configuration**.

---

# Step 3: Configure Conftest

Create:
conftest.toml

Inside of conftest.toml add policy = "./policy"


This tells Conftest where to find policy files.

---

# Step 4: Run the Policy Test

Inside GitHub Codespaces run:
conftest test input.json --all-namespaces

Result:
FAIL - input.json - S3 buckets cannot be publicly readable (acl: public-read)


The policy successfully detected the insecure configuration.

---

# Step 5: Fix the Misconfiguration

Update `input.json`:
{
"resource_type": "aws_s3_bucket",
"acl": "private"
}

Run the test again:
conftest test input.json --all-namespaces

Result:
PASS - input.json


This confirms the policy correctly enforces the security rule.

---

# Troubleshooting and Issues Encountered

This lab intentionally documents troubleshooting steps to reflect real-world development and debugging.

---

## Issue: Conftest Command Not Found

Error: bash: conftest: command not found

Cause:

Conftest was not installed in the Codespaces environment.

Solution: 
curl -L https://github.com/open-policy-agent/conftest/releases/download/v0.61.0/conftest_0.61.0_Linux_x86_64.tar.gz -o conftest.tar.gz
tar -xzf conftest.tar.gz
sudo mv conftest /usr/local/bin/


Verify: conftest --version

conftest --version

---

## Issue: Corrupted Download

Error:
gzip: stdin: not in gzip format

Cause:

The download file was incomplete.

Solution:
rm -f conftest.tar.gz

Then download again.

---

## Issue: Incorrect Terminal Paste

Error:
^[[200~curl ...

Cause:

Terminal paste formatting added extra characters.

Solution:

Re-ran the command without the extra characters.

---

# Final Result

Initial configuration:
acl: public-read

Test result:
FAIL

After fixing configuration:
acl: private

Test result:
PASS


This demonstrates how **policy-as-code can automatically detect insecure infrastructure configurations before deployment**.

---

# Compliance Mapping

This policy supports several security and governance principles:

- **Least Privilege**
- **Access Control Enforcement**
- **Cloud Misconfiguration Prevention**

Related NIST 800-53 controls:

- AC-3 Access Enforcement
- AC-6 Least Privilege
- SC-7 Boundary Protection

---

# Key Takeaway

Instead of documenting a rule like:

> "S3 buckets should not be public"

Policy-as-code allows security teams to **enforce the rule automatically** during development and deployment.

This reduces human error and improves security posture in cloud environments.
