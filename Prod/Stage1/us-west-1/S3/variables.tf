locals {
  scripts_dir   = "${path.module}/website"
  scripts_files = fileset(local.scripts_dir, "**/*")

}