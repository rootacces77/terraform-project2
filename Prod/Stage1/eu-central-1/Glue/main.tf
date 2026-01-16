############################################
# Glue Database (Data Catalog database)
############################################

resource "aws_glue_catalog_database" "athena" {
  name = var.glue_database_name

  description = "Glue Data Catalog DB for Athena tables"
}


############################################
# Glue Crawler (builds tables for Athena)
############################################

resource "aws_glue_crawler" "athena" {
  name          = "athena-crawler"
  role          = aws_iam_role.glue_crawler.arn
  database_name = aws_glue_catalog_database.athena.name

  # Create tables using this prefix (optional)
  # table_prefix = var.glue_table_prefix

  # One or more S3 targets
  dynamic "s3_target" {
    for_each = local.glue_s3_targets
    content {
      path = s3_target.value
    }
  }

  # Group crawler output logically
  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  tags = {Name = "Glue Catalog"}
}