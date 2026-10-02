# terraform-gcp-bigquery

Base Terraform module for a single BigQuery dataset, with optional CMEK and additive dataset IAM.

This module is a building block. Applications should consume it through
[terraform-gcp-bq-template](https://github.com/srinivinukonda/terraform-gcp-bq-template), which applies the
organisation's naming, labelling and IAM standards.

## Usage

```hcl
module "dataset" {
  source = "git::https://github.com/srinivinukonda/terraform-gcp-bigquery.git?ref=v1.0.0"

  project_id = "my-project"
  dataset_id = "bronze"
  location   = "europe-west2"

  kms_key_name = null # set to a KMS key path to enable CMEK

  iam_members = {
    "roles/bigquery.dataEditor" = ["serviceAccount:etl@my-project.iam.gserviceaccount.com"]
  }
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `project_id` | string | — | Project that owns the dataset |
| `dataset_id` | string | — | Dataset ID (letters, numbers, `_`) |
| `location` | string | — | Dataset location |
| `friendly_name` | string | `null` | Display name |
| `description` | string | `null` | Description |
| `labels` | map(string) | `{}` | Labels |
| `kms_key_name` | string | `null` | CMEK key path. `null` = Google-managed encryption |
| `default_table_expiration_ms` | number | `null` | Default table TTL |
| `default_partition_expiration_ms` | number | `null` | Default partition TTL |
| `delete_contents_on_destroy` | bool | `false` | Drop tables on destroy |
| `iam_members` | map(list(string)) | `{}` | role => principals (`user:`, `group:`, `serviceAccount:`, `domain:`) |

## Outputs

`dataset_id`, `id`, `self_link`, `kms_key_name`, `iam_members`.

## IAM

IAM uses `google_bigquery_dataset_iam_member`, which is **additive**: it adds the listed grants and leaves
any other grants on the dataset untouched. Don't combine it with `access {}` blocks on the dataset.

## CMEK

When `kms_key_name` is set, the BigQuery encryption service agent
(`bq-<project-number>@bigquery-encryption.iam.gserviceaccount.com`) needs
`roles/cloudkms.cryptoKeyEncrypterDecrypter` on the key, and the key must be in the dataset's location.
Granting that is outside this module.

## Versioning

Released with semver git tags (`vMAJOR.MINOR.PATCH`). Pin with `?ref=<tag>`.
