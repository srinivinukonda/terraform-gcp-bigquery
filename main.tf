locals {
  # Flatten role => [members] into one entry per (role, member) pair.
  iam_pairs = {
    for pair in flatten([
      for role, members in var.iam_members : [
        for member in members : { role = role, member = member }
      ]
    ]) : "${pair.role}|${pair.member}" => pair
  }
}

resource "google_bigquery_dataset" "this" {
  project                         = var.project_id
  dataset_id                      = var.dataset_id
  location                        = var.location
  friendly_name                   = var.friendly_name
  description                     = var.description
  labels                          = var.labels
  default_table_expiration_ms     = var.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms
  delete_contents_on_destroy      = var.delete_contents_on_destroy

  dynamic "default_encryption_configuration" {
    for_each = var.kms_key_name == null ? [] : [var.kms_key_name]
    content {
      kms_key_name = default_encryption_configuration.value
    }
  }
}

resource "google_bigquery_dataset_iam_member" "this" {
  for_each = local.iam_pairs

  project    = var.project_id
  dataset_id = google_bigquery_dataset.this.dataset_id
  role       = each.value.role
  member     = each.value.member
}
