output "dataset_id" {
  description = "Dataset ID."
  value       = google_bigquery_dataset.this.dataset_id
}

output "id" {
  description = "Fully qualified dataset resource ID (projects/<p>/datasets/<d>)."
  value       = google_bigquery_dataset.this.id
}

output "self_link" {
  description = "Dataset self link."
  value       = google_bigquery_dataset.this.self_link
}

output "kms_key_name" {
  description = "CMEK key in use, or null for Google-managed encryption."
  value       = var.kms_key_name
}

output "iam_members" {
  description = "IAM grants created, keyed by role|member."
  value       = { for k, v in google_bigquery_dataset_iam_member.this : k => { role = v.role, member = v.member } }
}
