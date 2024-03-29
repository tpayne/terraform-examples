/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

output "arm_deployment001-output" {
  value = module.arm_deployment001.armop_output
}

output "arm_deployment001-id" {
  value = module.arm_deployment001.armop_id
}

output "arm_deploymentvmss001-output" {
  value = module.arm_deploymentvmss001.armop_output
}

output "arm_deploymentvmss001-id" {
  value = module.arm_deploymentvmss001.armop_id
}

output "arm_deploymentk8s-output" {
  value = module.arm_deploymentk8s.armop_output
}

output "arm_deploymentk8s-id" {
  value = module.arm_deploymentk8s.armop_id
}

output "arm_deployments3t-output" {
  value = module.arm_deployments3t.armop_output
}

output "arm_deployments3t-id" {
  value = module.arm_deployments3t.armop_id
}
