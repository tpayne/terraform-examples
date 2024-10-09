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

locals {
  env_vars       = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env            = local.env_vars.locals.env
  backend_cidr   = local.env_vars.locals.backend_cidr
  backendsn_cidr = local.env_vars.locals.backendsn_cidr
}

# Include the root `terragrunt.hcl` configuration. The root configuration contains 
# settings that are common across all components and environments, such as how to 
# configure remote state.
include "root" {
  path = find_in_parent_folders()
}

include "defs" {
  path = "${dirname(find_in_parent_folders())}/defs/k8s.hcl"
}

inputs = {
  tags = {
    env  = local.env
    team = local.env
  }
  name                 = "${local.env}_rg_001"
  project              = "tdm${local.env}"
  backend_cidr_range   = "${local.backend_cidr}"
  backendsn_cidr_range = "${local.backendsn_cidr}"
}
