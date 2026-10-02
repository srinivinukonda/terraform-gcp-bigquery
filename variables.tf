variable "project_id" {
  description = "Project that owns the dataset."
  type        = string
}

variable "dataset_id" {
  description = "Dataset ID. Letters, numbers and underscores only."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_]+$", var.dataset_id)) && length(var.dataset_id) <= 1024
    error_message = "dataset_id may contain only letters, numbers and underscores (max 1024 chars)."
  }
}

variable "location" {
  description = "Dataset location, e.g. europe-west2 or EU."
  type        = string
}

variable "friendly_name" {
  description = "Human-readable dataset name."
  type        = string
  default     = null
}

variable "description" {
  description = "Dataset description."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to the dataset."
  type        = map(string)
  default     = {}
}

variable "kms_key_name" {
  description = <<-EOT
    Cloud KMS key used as the dataset's default encryption key (CMEK), in the form
    projects/<p>/locations/<loc>/keyRings/<ring>/cryptoKeys/<key>. The key must be in
    the same location as the dataset, and the BigQuery encryption service agent must
    hold roles/cloudkms.cryptoKeyEncrypterDecrypter on it.
    Optional for now; null means Google-managed encryption.
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_name == null || can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.kms_key_name))
    error_message = "kms_key_name must be a full key path: projects/<p>/locations/<loc>/keyRings/<ring>/cryptoKeys/<key>."
  }
}

variable "default_table_expiration_ms" {
  description = "Default lifetime for new tables, in milliseconds. Null means no expiry."
  type        = number
  default     = null
}

variable "default_partition_expiration_ms" {
  description = "Default lifetime for partitions in new partitioned tables, in milliseconds. Null means no expiry."
  type        = number
  default     = null
}

variable "delete_contents_on_destroy" {
  description = "Delete all tables when the dataset is destroyed."
  type        = bool
  default     = false
}

variable "iam_members" {
  description = <<-EOT
    Additive dataset IAM, as a map of role => list of principals. Principals use the
    standard prefixes: user:, group:, serviceAccount:, domain:.
    Uses google_bigquery_dataset_iam_member, so grants made outside Terraform are kept.
  EOT
  type        = map(list(string))
  default     = {}

  validation {
    condition = alltrue([
      for m in flatten(values(var.iam_members)) :
      can(regex("^(user|group|serviceAccount|domain):.+", m))
    ])
    error_message = "Each principal must start with user:, group:, serviceAccount: or domain:."
  }
}
